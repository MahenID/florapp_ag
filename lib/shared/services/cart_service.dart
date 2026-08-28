import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../features/products/domain/product_model.dart';

class CartService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _cartRef() {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User belum login');
    }

    return _db.collection('users').doc(user.uid).collection('cart');
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCartItems() {
    return _cartRef().snapshots();
  }

  Future<void> addToCart({required Product product}) async {
    final cartDoc = _cartRef().doc(product.id);
    final snapshot = await cartDoc.get();

    if (snapshot.exists) {
      await cartDoc.update({
        'quantity': FieldValue.increment(1),
        'updatedAt': Timestamp.now(),
      });
    } else {
      await cartDoc.set({
        'productId': product.id,
        'name': product.name,
        'image': product.image,
        'price': product.price,
        'quantity': 1,
        'sellerId': product.userId,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      });
    }
  }

  Future<void> updateQuantity({
    required String productId,
    required int quantity,
  }) async {
    if (quantity <= 0) {
      await removeFromCart(productId: productId);
      return;
    }

    await _cartRef().doc(productId).update({
      'quantity': quantity,
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> removeFromCart({required String productId}) async {
    await _cartRef().doc(productId).delete();
  }

  Future<void> clearCart() async {
    final snapshot = await _cartRef().get();

    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
