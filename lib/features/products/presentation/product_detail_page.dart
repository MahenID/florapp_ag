import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../domain/product_model.dart';
import '../../../shared/utils/currency_formatter.dart';
import '../../../shared/services/cart_service.dart';
import '../../../shared/services/favorite_service.dart';
import '../../../shared/widgets/app_network_image.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  Future<void> addProductToCart(BuildContext context) async {
    try {
      await CartService().addToCart(product: product);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produk berhasil dimasukkan ke keranjang'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menambahkan ke keranjang: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.image.trim();
    final description = product.description.trim();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 360,
                    width: double.infinity,
                    child: AppNetworkImage(
                      imageUrl: imageUrl,
                      width: double.infinity,
                      height: 360,
                      fit: BoxFit.cover,
                    ),
                  ),

                  Container(
                    height: 360,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.50),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.30),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),

                  Positioned(
                    top: 16,
                    left: 16,
                    child: buildCircleButton(
                      icon: Icons.arrow_back,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),

                  Positioned(
                    top: 16,
                    right: 16,
                    child: StreamBuilder<bool>(
                      stream: FavoriteService().isFavorite(product.id),
                      builder: (context, snapshot) {
                        final isFav = snapshot.data ?? false;
                        return buildCircleButton(
                          icon: isFav ? Icons.favorite : Icons.favorite_border,
                          iconColor: isFav ? Colors.red : Colors.white,
                          onTap: () async {
                            try {
                              final added = await FavoriteService().toggleFavorite(product);
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    added
                                        ? 'Ditambahkan ke wishlist'
                                        : 'Dihapus dari wishlist',
                                  ),
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Gagal: $e'),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),

                  Positioned(
                    left: 20,
                    bottom: 30,
                    child: Row(
                      children: [
                        buildBadge(
                          icon: Icons.verified,
                          text: 'Produk Aktif',
                          color: Colors.green,
                        ),
                        const SizedBox(width: 10),
                        buildBadge(
                          icon: Icons.eco,
                          text: 'Tanaman',
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Transform.translate(
                offset: const Offset(0, -24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(36),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        formatRupiah(product.price),
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 22),

                      Row(
                        children: [
                          Expanded(
                            child: buildInfoBox(
                              icon: Icons.local_shipping,
                              title: 'Pengiriman',
                              value: 'Siap Kirim',
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: buildInfoBox(
                              icon: Icons.inventory_2,
                              title: 'Stok',
                              value: 'Tersedia',
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 26),

                      buildSellerCard(context),

                      const SizedBox(height: 30),

                      const Text(
                        'Deskripsi Produk',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Text(
                          description.isNotEmpty
                              ? description
                              : 'Tidak ada deskripsi produk.',
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      buildReviewSection(context),

                      const SizedBox(height: 30),

                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info, color: Colors.orange),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Pastikan alamat pengiriman sudah benar sebelum membeli tanaman.',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              buildBottomIconButton(
                icon: Icons.chat,
                label: 'Chat',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fitur chat penjual belum dibuat'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),

              const SizedBox(width: 10),

              buildBottomIconButton(
                icon: Icons.shopping_cart_outlined,
                label: 'Cart',
                onTap: () {
                  addProductToCart(context);
                },
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fitur beli sekarang belum dibuat'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 17),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Beli Sekarang',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSellerCard(BuildContext context) {
    if (product.userId.trim().isEmpty) {
      return buildSellerCardContent(
        context: context,
        sellerName: 'Toko tidak diketahui',
        sellerDescription: 'Produk lama belum memiliki data toko',
        sellerPhoto: '',
        sellerCity: '-',
        sellerIsOpen: true,
        sellerId: '',
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(product.userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Row(
              children: [
                SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 14),
                Text(
                  'Memuat data toko...',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        }

        String sellerName = 'Toko Florapp';
        String sellerDescription = 'Penjual tanaman Florapp';
        String sellerPhoto = '';
        String sellerCity = '-';
        bool sellerIsOpen = true;

        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;

          sellerName = data['storeName'] ?? data['name'] ?? 'Toko Florapp';
          sellerDescription =
              data['storeDescription'] ?? 'Penjual tanaman Florapp';
          sellerPhoto = data['storePhoto'] ?? data['photoUrl'] ?? '';
          sellerCity = data['storeCity'] ?? '-';
          sellerIsOpen = data['storeIsOpen'] ?? true;
        }

        return buildSellerCardContent(
          context: context,
          sellerName: sellerName,
          sellerDescription: sellerDescription,
          sellerPhoto: sellerPhoto,
          sellerCity: sellerCity,
          sellerIsOpen: sellerIsOpen,
          sellerId: product.userId,
        );
      },
    );
  }

  Widget buildSellerCardContent({
    required BuildContext context,
    required String sellerName,
    required String sellerDescription,
    required String sellerPhoto,
    required String sellerCity,
    required bool sellerIsOpen,
    required String sellerId,
  }) {
    final hasSellerPhoto =
        sellerPhoto.startsWith('http://') || sellerPhoto.startsWith('https://');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.green.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.green.withValues(alpha: 0.12),
                backgroundImage: hasSellerPhoto
                    ? NetworkImage(sellerPhoto)
                    : null,
                child: hasSellerPhoto
                    ? null
                    : const Icon(
                        Icons.storefront,
                        color: Colors.green,
                        size: 34,
                      ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sellerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      sellerDescription,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 15,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            sellerCity,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Halaman toko publik belum dibuat'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.green),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Lihat',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: buildSellerInfoItem(
                  icon: Icons.inventory_2,
                  title: 'Produk',
                  value: sellerId.isEmpty ? '-' : 'Lihat',
                  color: Colors.green,
                ),
              ),
              Expanded(
                child: buildSellerInfoItem(
                  icon: Icons.star,
                  title: 'Rating',
                  value: '0.0',
                  color: Colors.amber,
                ),
              ),
              Expanded(
                child: buildSellerInfoItem(
                  icon: sellerIsOpen ? Icons.store : Icons.store_mall_directory,
                  title: 'Status',
                  value: sellerIsOpen ? 'Buka' : 'Tutup',
                  color: sellerIsOpen ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildReviewSection(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .doc(product.id)
          .collection('reviews')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Row(
              children: [
                SizedBox(
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 14),
                Text(
                  'Memuat ulasan...',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        }

        final reviews = snapshot.data?.docs ?? [];

        double totalRating = 0;

        for (final review in reviews) {
          final data = review.data() as Map<String, dynamic>;
          final rating = data['rating'];

          if (rating is num) {
            totalRating += rating.toDouble();
          }
        }

        final averageRating = reviews.isEmpty
            ? 0.0
            : totalRating / reviews.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ulasan Pembeli',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 14),

            buildReviewSummary(
              averageRating: averageRating,
              totalReviews: reviews.length,
            ),

            const SizedBox(height: 16),

            if (reviews.isEmpty)
              buildEmptyReview()
            else
              Column(
                children: reviews.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;

                  final buyerName = data['buyerName'] ?? 'Pembeli Florapp';
                  final buyerPhoto = data['buyerPhoto'] ?? '';
                  final comment = data['comment'] ?? '';
                  final createdAt = data['createdAt'];
                  final ratingValue = data['rating'];

                  final rating = ratingValue is num
                      ? ratingValue.toDouble()
                      : 0.0;

                  return buildReviewCard(
                    buyerName: buyerName,
                    buyerPhoto: buyerPhoto,
                    rating: rating,
                    comment: comment,
                    createdAt: createdAt,
                  );
                }).toList(),
              ),
          ],
        );
      },
    );
  }

  Widget buildReviewSummary({
    required double averageRating,
    required int totalReviews,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.20)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.star, color: Colors.amber, size: 32),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  averageRating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                buildRatingStars(averageRating),
                const SizedBox(height: 4),
                Text(
                  '$totalReviews ulasan pembeli',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReviewCard({
    required String buyerName,
    required String buyerPhoto,
    required double rating,
    required String comment,
    required dynamic createdAt,
  }) {
    final hasBuyerPhoto =
        buyerPhoto.startsWith('http://') || buyerPhoto.startsWith('https://');

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.green.withValues(alpha: 0.12),
            backgroundImage: hasBuyerPhoto ? NetworkImage(buyerPhoto) : null,
            child: hasBuyerPhoto
                ? null
                : const Icon(Icons.person, color: Colors.green),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  buyerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 5),

                Row(
                  children: [
                    buildRatingStars(rating),
                    const SizedBox(width: 8),
                    Text(
                      formatReviewDate(createdAt),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Text(
                  comment.isNotEmpty
                      ? comment
                      : 'Pembeli tidak menulis komentar.',
                  style: TextStyle(color: Colors.grey.shade700, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmptyReview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Icon(
            Icons.rate_review_outlined,
            color: Colors.grey.shade500,
            size: 46,
          ),
          const SizedBox(height: 12),
          const Text(
            'Belum Ada Ulasan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          const SizedBox(height: 6),
          Text(
            'Ulasan pembeli akan tampil setelah transaksi selesai.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget buildRatingStars(double rating) {
    final roundedRating = rating.round();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final isActive = index < roundedRating;

        return Icon(
          isActive ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }

  String formatReviewDate(dynamic value) {
    if (value is Timestamp) {
      final date = value.toDate();

      return '${date.day}/${date.month}/${date.year}';
    }

    return '';
  }

  Widget buildBadge({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSellerInfoItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 3),
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }

  Widget buildBottomIconButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 58,
      width: 64,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.green, size: 22),
              const SizedBox(height: 3),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCircleButton({ required IconData icon, Color iconColor = Colors.white, required VoidCallback onTap }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget buildInfoBox({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 360,
      color: Colors.green.withValues(alpha: 0.12),
      child: const Center(
        child: Icon(Icons.image_not_supported, color: Colors.green, size: 70),
      ),
    );
  }
}




