import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String productId;
  final String name;
  final String image;
  final double price;
  final int quantity;
  final String sellerId;

  OrderItem({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    required this.sellerId,
  });

  factory OrderItem.fromMap(Map<String, dynamic> data) {
    double parsedPrice = 0.0;
    final rawPrice = data['price'];
    if (rawPrice is num) {
      parsedPrice = rawPrice.toDouble();
    } else if (rawPrice is String) {
      parsedPrice = double.tryParse(rawPrice) ?? 0.0;
    }

    int parsedQty = 1;
    final rawQty = data['quantity'];
    if (rawQty is int) {
      parsedQty = rawQty;
    } else if (rawQty is num) {
      parsedQty = rawQty.toInt();
    }

    return OrderItem(
      productId: (data['productId'] ?? '').toString(),
      name: (data['name'] ?? '').toString(),
      image: (data['image'] ?? '').toString(),
      price: parsedPrice,
      quantity: parsedQty,
      sellerId: (data['sellerId'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
      'sellerId': sellerId,
    };
  }
}

class OrderModel {
  final String id;
  final String orderNumber;
  final String buyerId;
  final String buyerName;
  final String sellerId;
  final List<OrderItem> items;
  final double itemsTotal;
  final double shippingFee;
  final double serviceFee;
  final double totalPrice;
  final Map<String, dynamic> shippingAddress;
  final String courier;
  final String paymentMethod;
  final String status; // 'diproses', 'dikirim', 'selesai', 'dibatalkan'
  final String? trackingNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.buyerId,
    required this.buyerName,
    required this.sellerId,
    required this.items,
    required this.itemsTotal,
    required this.shippingFee,
    this.serviceFee = 1000,
    required this.totalPrice,
    required this.shippingAddress,
    required this.courier,
    required this.paymentMethod,
    required this.status,
    this.trackingNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final rawData = doc.data();
    final data =
        (rawData is Map<String, dynamic>) ? rawData : <String, dynamic>{};

    final rawItems = data['items'] as List<dynamic>? ?? [];
    final itemsList = rawItems
        .map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
        .toList();

    DateTime parsedCreatedAt = DateTime.now();
    final rawCreated = data['createdAt'];
    if (rawCreated is Timestamp) {
      parsedCreatedAt = rawCreated.toDate();
    }

    DateTime parsedUpdatedAt = DateTime.now();
    final rawUpdated = data['updatedAt'];
    if (rawUpdated is Timestamp) {
      parsedUpdatedAt = rawUpdated.toDate();
    }

    return OrderModel(
      id: doc.id,
      orderNumber: (data['orderNumber'] ?? '').toString(),
      buyerId: (data['buyerId'] ?? '').toString(),
      buyerName: (data['buyerName'] ?? 'Pembeli').toString(),
      sellerId: (data['sellerId'] ?? '').toString(),
      items: itemsList,
      itemsTotal: (data['itemsTotal'] is num)
          ? (data['itemsTotal'] as num).toDouble()
          : 0.0,
      shippingFee: (data['shippingFee'] is num)
          ? (data['shippingFee'] as num).toDouble()
          : 0.0,
      serviceFee: (data['serviceFee'] is num)
          ? (data['serviceFee'] as num).toDouble()
          : 1000.0,
      totalPrice: (data['totalPrice'] is num)
          ? (data['totalPrice'] as num).toDouble()
          : 0.0,
      shippingAddress:
          (data['shippingAddress'] is Map<String, dynamic>)
              ? (data['shippingAddress'] as Map<String, dynamic>)
              : {},
      courier: (data['courier'] ?? 'JNE Reguler').toString(),
      paymentMethod: (data['paymentMethod'] ?? 'Transfer Bank').toString(),
      status: (data['status'] ?? 'diproses').toString(),
      trackingNumber: data['trackingNumber']?.toString(),
      createdAt: parsedCreatedAt,
      updatedAt: parsedUpdatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderNumber': orderNumber,
      'buyerId': buyerId,
      'buyerName': buyerName,
      'sellerId': sellerId,
      'items': items.map((e) => e.toMap()).toList(),
      'itemsTotal': itemsTotal,
      'shippingFee': shippingFee,
      'serviceFee': serviceFee,
      'totalPrice': totalPrice,
      'shippingAddress': shippingAddress,
      'courier': courier,
      'paymentMethod': paymentMethod,
      'status': status,
      'trackingNumber': trackingNumber,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
