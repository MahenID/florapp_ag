import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String image;
  final double price;
  final String description;
  final String userId;
  final DateTime? createdAt;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.description,
    required this.userId,
    this.createdAt,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final rawData = doc.data();
    final data =
        (rawData is Map<String, dynamic>) ? rawData : <String, dynamic>{};

    double parsedPrice = 0.0;
    final rawPrice = data['price'];
    if (rawPrice is num) {
      parsedPrice = rawPrice.toDouble();
    } else if (rawPrice is String) {
      parsedPrice =
          double.tryParse(rawPrice.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
    }

    DateTime? parsedCreatedAt;
    final rawCreatedAt = data['createdAt'];
    if (rawCreatedAt is Timestamp) {
      parsedCreatedAt = rawCreatedAt.toDate();
    }

    return Product(
      id: doc.id,
      name: (data['name'] ?? '').toString(),
      image: (data['image'] ?? '').toString(),
      price: parsedPrice,
      description: (data['description'] ?? '').toString(),
      userId: (data['userId'] ?? '').toString(),
      createdAt: parsedCreatedAt,
    );
  }

  factory Product.fromMap(Map<String, dynamic> data, {String id = ''}) {
    double parsedPrice = 0.0;
    final rawPrice = data['price'];
    if (rawPrice is num) {
      parsedPrice = rawPrice.toDouble();
    } else if (rawPrice is String) {
      parsedPrice =
          double.tryParse(rawPrice.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
    }

    return Product(
      id: id.isNotEmpty ? id : (data['id'] ?? '').toString(),
      name: (data['name'] ?? '').toString(),
      image: (data['image'] ?? '').toString(),
      price: parsedPrice,
      description: (data['description'] ?? '').toString(),
      userId: (data['userId'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'price': price,
      'description': description,
      'userId': userId,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : Timestamp.now(),
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? image,
    double? price,
    String? description,
    String? userId,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
