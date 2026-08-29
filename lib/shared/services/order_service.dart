import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/orders/domain/order_model.dart';
import 'cart_service.dart';

class OrderService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // GENERATE UNIQUE ORDER NUMBER
  String _generateOrderNumber() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final randomDigits = Random().nextInt(900) + 100;
    return 'FLR-${timestamp.substring(timestamp.length - 6)}$randomDigits';
  }

  // CREATE ORDER(S) FROM CHECKOUT (GROUPS BY SELLER IF MULTIPLE SELLERS)
  Future<List<String>> createOrders({
    required List<OrderItem> items,
    required Map<String, dynamic> shippingAddress,
    required String courier,
    required double shippingFeePerSeller,
    required String paymentMethod,
    double serviceFee = 1000,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Pengguna belum login.');
    }

    // Fetch buyer name from Firestore users
    final userDoc = await _db.collection('users').doc(user.uid).get();
    final userData = userDoc.data() ?? {};
    final buyerName =
        userData['name'] ?? userData['shippingFullName'] ?? 'Pembeli FlorApp';

    // Group items by sellerId
    final Map<String, List<OrderItem>> sellerGroups = {};
    for (final item in items) {
      final sellerId = item.sellerId.isNotEmpty ? item.sellerId : 'admin_seller';
      if (!sellerGroups.containsKey(sellerId)) {
        sellerGroups[sellerId] = [];
      }
      sellerGroups[sellerId]!.add(item);
    }

    final List<String> createdOrderIds = [];

    // Create an order doc for each seller
    for (final entry in sellerGroups.entries) {
      final sellerId = entry.key;
      final sellerItems = entry.value;

      double itemsTotal = 0;
      for (final item in sellerItems) {
        itemsTotal += item.price * item.quantity;
      }

      final totalOrderPrice = itemsTotal + shippingFeePerSeller + serviceFee;
      final orderNumber = _generateOrderNumber();
      final now = DateTime.now();

      final orderData = {
        'orderNumber': orderNumber,
        'buyerId': user.uid,
        'buyerName': buyerName,
        'sellerId': sellerId,
        'items': sellerItems.map((e) => e.toMap()).toList(),
        'itemsTotal': itemsTotal,
        'shippingFee': shippingFeePerSeller,
        'serviceFee': serviceFee,
        'totalPrice': totalOrderPrice,
        'shippingAddress': shippingAddress,
        'courier': courier,
        'paymentMethod': paymentMethod,
        'status': 'diproses',
        'trackingNumber': null,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      };

      final docRef = await _db.collection('orders').add(orderData);
      createdOrderIds.add(docRef.id);
    }

    // Clear cart after successful order creation
    await CartService().clearCart();

    return createdOrderIds;
  }

  // GET BUYER ORDERS STREAM
  Stream<List<OrderModel>> getBuyerOrders({String? status}) {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    Query<Map<String, dynamic>> query = _db
        .collection('orders')
        .where('buyerId', isEqualTo: user.uid);

    if (status != null && status.isNotEmpty) {
      query = query.where('status', isEqualTo: status);
    }

    return query
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList());
  }

  // GET SELLER ORDERS STREAM
  Stream<List<OrderModel>> getSellerOrders({String? status}) {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    Query<Map<String, dynamic>> query = _db
        .collection('orders')
        .where('sellerId', isEqualTo: user.uid);

    if (status != null && status.isNotEmpty) {
      query = query.where('status', isEqualTo: status);
    }

    return query
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList());
  }

  // UPDATE ORDER STATUS (e.g. from seller or system)
  Future<void> updateOrderStatus({
    required String orderId,
    required String status,
    String? trackingNumber,
    String? courier,
  }) async {
    final Map<String, dynamic> updateData = {
      'status': status,
      'updatedAt': Timestamp.now(),
    };

    if (trackingNumber != null && trackingNumber.isNotEmpty) {
      updateData['trackingNumber'] = trackingNumber;
    }
    if (courier != null && courier.isNotEmpty) {
      updateData['courier'] = courier;
    }

    await _db.collection('orders').doc(orderId).update(updateData);
  }

  // BUYER CONFIRMS ORDER RECEIVED
  Future<void> confirmOrderReceived({required String orderId}) async {
    await updateOrderStatus(orderId: orderId, status: 'selesai');
  }
}
