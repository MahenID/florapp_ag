import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../shared/services/cart_service.dart';
import '../../../../shared/utils/currency_formatter.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  int getQuantity(Map<String, dynamic> data) {
    final quantity = data['quantity'];

    if (quantity is int) return quantity;
    if (quantity is num) return quantity.toInt();

    return 1;
  }

  double getPrice(Map<String, dynamic> data) {
    final price = data['price'];

    if (price is int) return price.toDouble();
    if (price is double) return price;
    if (price is num) return price.toDouble();

    return 0;
  }

  double calculateTotal(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    double total = 0;

    for (final doc in docs) {
      final data = doc.data();
      final price = getPrice(data);
      final quantity = getQuantity(data);

      total += price * quantity;
    }

    return total;
  }

  int calculateTotalItem(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    int total = 0;

    for (final doc in docs) {
      total += getQuantity(doc.data());
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: Column(
            children: [
              // ================= HEADER =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 26),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(34),
                    bottomRight: Radius.circular(34),
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaksi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Kelola keranjang dan pesanan pembelianmu',
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ================= TAB BAR =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    tabs: const [
                      Tab(text: 'Keranjang'),
                      Tab(text: 'Diproses'),
                      Tab(text: 'Dikirim'),
                      Tab(text: 'Selesai'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // ================= TAB CONTENT =================
              Expanded(
                child: TabBarView(
                  children: [
                    buildCartTab(context),
                    buildOrderStatusTab(
                      icon: Icons.pending_actions,
                      title: 'Belum Ada Pesanan Diproses',
                      subtitle:
                          'Pesanan yang sedang diproses penjual akan tampil di sini.',
                      color: Colors.orange,
                    ),
                    buildOrderStatusTab(
                      icon: Icons.local_shipping,
                      title: 'Belum Ada Pesanan Dikirim',
                      subtitle:
                          'Pesanan yang sedang dalam pengiriman akan tampil di sini.',
                      color: Colors.blue,
                    ),
                    buildOrderStatusTab(
                      icon: Icons.check_circle,
                      title: 'Belum Ada Pesanan Selesai',
                      subtitle:
                          'Pesanan yang sudah selesai akan tampil di sini.',
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCartTab(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final cartService = CartService();

    if (currentUser == null) {
      return const Center(child: Text('User belum login'));
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: cartService.getCartItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Terjadi kesalahan:\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        final cartItems = snapshot.data?.docs ?? [];
        final totalPrice = calculateTotal(cartItems);
        final totalItem = calculateTotalItem(cartItems);

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: buildSummaryCard(
                            icon: Icons.shopping_cart,
                            title: 'Total Item',
                            value: totalItem.toString(),
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: buildSummaryCard(
                            icon: Icons.payments,
                            title: 'Total Harga',
                            value: formatRupiah(totalPrice),
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Produk di Keranjang',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    if (cartItems.isEmpty)
                      buildEmptyCart()
                    else
                      Column(
                        children: cartItems.map((doc) {
                          final data = doc.data();

                          final productId = data['productId'] ?? doc.id;
                          final name = data['name'] ?? 'Tanpa Nama';
                          final image = data['image'] ?? '';
                          final price = getPrice(data);
                          final quantity = getQuantity(data);

                          return buildCartItem(
                            cartService: cartService,
                            productId: productId,
                            name: name,
                            image: image,
                            price: price,
                            quantity: quantity,
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),

            // ================= CHECKOUT BAR =================
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
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
                top: false,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Pembayaran',
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatRupiah(totalPrice),
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    ElevatedButton(
                      onPressed: cartItems.isEmpty
                          ? null
                          : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Fitur checkout akan dibuat setelah ini',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        disabledBackgroundColor: Colors.grey.shade300,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 26,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Checkout',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
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
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 10),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }

  Widget buildCartItem({
    required CartService cartService,
    required String productId,
    required String name,
    required String image,
    required double price,
    required int quantity,
  }) {
    final subtotal = price * quantity;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: image.isNotEmpty
                ? Image.network(
                    image,
                    width: 92,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return buildImageError();
                    },
                  )
                : buildImageError(),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  formatRupiah(price),
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Subtotal: ${formatRupiah(subtotal)}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    buildQuantityButton(
                      icon: Icons.remove,
                      onTap: () {
                        cartService.updateQuantity(
                          productId: productId,
                          quantity: quantity - 1,
                        );
                      },
                    ),

                    Container(
                      width: 42,
                      alignment: Alignment.center,
                      child: Text(
                        quantity.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    buildQuantityButton(
                      icon: Icons.add,
                      onTap: () {
                        cartService.updateQuantity(
                          productId: productId,
                          quantity: quantity + 1,
                        );
                      },
                    ),

                    const Spacer(),

                    IconButton(
                      onPressed: () {
                        cartService.removeFromCart(productId: productId);
                      },
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.green, size: 18),
      ),
    );
  }

  Widget buildEmptyCart() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
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
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.green,
              size: 54,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Keranjang Kosong',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tambahkan tanaman favoritmu sebelum melakukan checkout.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 15, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget buildOrderStatusTab({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 54),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImageError() {
    return Container(
      width: 92,
      height: 100,
      color: Colors.green.withValues(alpha: 0.10),
      child: const Icon(Icons.image_not_supported, color: Colors.green),
    );
  }
}
