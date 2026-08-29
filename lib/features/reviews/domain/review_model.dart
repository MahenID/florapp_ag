import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String productId;
  final String productName;
  final String orderId;
  final String buyerId;
  final String buyerName;
  final String buyerPhoto;
  final double rating;
  final String comment;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.orderId,
    required this.buyerId,
    required this.buyerName,
    required this.buyerPhoto,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    final rawData = doc.data();
    final data =
        (rawData is Map<String, dynamic>) ? rawData : <String, dynamic>{};

    DateTime parsedDate = DateTime.now();
    final rawCreated = data['createdAt'];
    if (rawCreated is Timestamp) {
      parsedDate = rawCreated.toDate();
    }

    double parsedRating = 5.0;
    final rawRating = data['rating'];
    if (rawRating is num) {
      parsedRating = rawRating.toDouble();
    } else if (rawRating is String) {
      parsedRating = double.tryParse(rawRating) ?? 5.0;
    }

    return ReviewModel(
      id: doc.id,
      productId: (data['productId'] ?? '').toString(),
      productName: (data['productName'] ?? '').toString(),
      orderId: (data['orderId'] ?? '').toString(),
      buyerId: (data['buyerId'] ?? '').toString(),
      buyerName: (data['buyerName'] ?? 'Pembeli Florapp').toString(),
      buyerPhoto: (data['buyerPhoto'] ?? '').toString(),
      rating: parsedRating,
      comment: (data['comment'] ?? '').toString(),
      createdAt: parsedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'orderId': orderId,
      'buyerId': buyerId,
      'buyerName': buyerName,
      'buyerPhoto': buyerPhoto,
      'rating': rating,
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
