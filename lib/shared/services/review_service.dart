import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/reviews/domain/review_model.dart';

class ReviewService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ADD PRODUCT REVIEW
  Future<void> submitReview({
    required String orderId,
    required String productId,
    required String productName,
    required double rating,
    required String comment,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Pengguna belum login.');

    // Fetch buyer info
    final userDoc = await _db.collection('users').doc(user.uid).get();
    final userData = userDoc.data() ?? {};
    final buyerName = userData['name'] ?? userData['shippingFullName'] ?? 'Pembeli Florapp';
    final buyerPhoto = userData['photoUrl'] ?? '';

    final now = DateTime.now();
    final reviewData = {
      'orderId': orderId,
      'productId': productId,
      'productName': productName,
      'buyerId': user.uid,
      'buyerName': buyerName,
      'buyerPhoto': buyerPhoto,
      'rating': rating,
      'comment': comment,
      'createdAt': Timestamp.fromDate(now),
    };

    // Save in products/{productId}/reviews subcollection
    await _db
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .add(reviewData);

    // Also record in global reviews collection
    await _db.collection('reviews').add(reviewData);
  }

  // GET PRODUCT REVIEWS STREAM
  Stream<List<ReviewModel>> getProductReviews(String productId) {
    return _db
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ReviewModel.fromFirestore(doc)).toList());
  }
}
