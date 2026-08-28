import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // GET PRODUCTS
  Stream<QuerySnapshot> getProducts() {
    return _db.collection('products').snapshots();
  }

  // ADD PRODUCT
  Future<void> addProduct({
    required String name,
    required String image,
    required double price,
    required String description,
  }) async {
    await _db.collection('products').add({
      'name': name,
      'image': image,
      'price': price,
      'description': description,
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'createdAt': Timestamp.now(),
    });
  }
}
