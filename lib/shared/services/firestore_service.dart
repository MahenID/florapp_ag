import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // GET ALL PRODUCTS
  Stream<QuerySnapshot<Map<String, dynamic>>> getProducts() {
    return _db
        .collection('products')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // GET PRODUCTS BY CURRENT USER
  Stream<QuerySnapshot<Map<String, dynamic>>> getMyProducts() {
    final user = _auth.currentUser;
    if (user == null) {
      return const Stream.empty();
    }
    return _db
        .collection('products')
        .where('userId', isEqualTo: user.uid)
        .snapshots();
  }

  // ADD PRODUCT
  Future<void> addProduct({
    required String name,
    required String image,
    required double price,
    required String description,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Pengguna belum login. Silakan login terlebih dahulu.');
    }

    await _db.collection('products').add({
      'name': name,
      'image': image,
      'price': price,
      'description': description,
      'userId': user.uid,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    });
  }

  // UPDATE PRODUCT
  Future<void> updateProduct({
    required String productId,
    required String name,
    required String image,
    required double price,
    required String description,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Pengguna belum login. Silakan login terlebih dahulu.');
    }

    await _db.collection('products').doc(productId).update({
      'name': name,
      'image': image,
      'price': price,
      'description': description,
      'updatedAt': Timestamp.now(),
    });
  }

  // DELETE PRODUCT
  Future<void> deleteProduct({required String productId}) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Pengguna belum login. Silakan login terlebih dahulu.');
    }

    await _db.collection('products').doc(productId).delete();
  }
}
