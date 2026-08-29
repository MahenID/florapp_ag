import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/products/domain/product_model.dart';

class FavoriteService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>>? _favoriteRef() {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _db.collection('users').doc(user.uid).collection('favorites');
  }

  Stream<bool> isFavorite(String productId) {
    final ref = _favoriteRef();
    if (ref == null) return Stream.value(false);

    return ref.doc(productId).snapshots().map((doc) => doc.exists);
  }

  Future<bool> toggleFavorite(Product product) async {
    final ref = _favoriteRef();
    if (ref == null) {
      throw Exception('Pengguna belum login.');
    }

    final doc = await ref.doc(product.id).get();
    if (doc.exists) {
      await ref.doc(product.id).delete();
      return false; // removed
    } else {
      await ref.doc(product.id).set({
        'productId': product.id,
        'name': product.name,
        'image': product.image,
        'price': product.price,
        'description': product.description,
        'sellerId': product.userId,
        'addedAt': Timestamp.now(),
      });
      return true; // added
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getFavorites() {
    final ref = _favoriteRef();
    if (ref == null) return const Stream.empty();
    return ref.orderBy('addedAt', descending: true).snapshots();
  }
}
