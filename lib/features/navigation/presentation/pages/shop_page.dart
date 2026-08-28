import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../shop/presentation/pages/sell_page.dart';
import '../../../shop/presentation/pages/my_products_page.dart';
import '../../../shop/presentation/pages/shop_tools_page.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: currentUser == null
            ? const Center(child: Text('User belum login'))
            : StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  String storeName = 'Toko Florapp Saya';
                  String storeDescription = 'Kelola toko tanamanmu di Florapp';
                  String storePhoto = '';

                  if (snapshot.hasData && snapshot.data!.exists) {
                    final data = snapshot.data!.data() as Map<String, dynamic>;

                    storeName =
                        data['storeName'] ??
                        data['name'] ??
                        'Toko Florapp Saya';
                    storeDescription =
                        data['storeDescription'] ??
                        'Kelola toko tanamanmu di Florapp';
                    storePhoto = data['storePhoto'] ?? data['photoUrl'] ?? '';
                  }

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(20, 24, 20, 34),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Shop Center',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Dashboard penjual Florapp',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.16),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.25),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 34,
                                      backgroundColor: Colors.white,
                                      backgroundImage: storePhoto.isNotEmpty
                                          ? NetworkImage(storePhoto)
                                          : null,
                                      child: storePhoto.isEmpty
                                          ? const Icon(
                                              Icons.storefront,
                                              color: Colors.green,
                                              size: 34,
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            storeName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            storeDescription,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 13,
                                              height: 1.3,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: const Text(
                                              'Seller Florapp',
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const ShopToolsPage(),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.settings,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: buildProductCountStat(currentUser.uid),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: buildStatCard(
                                  icon: Icons.shopping_bag,
                                  title: 'Pesanan',
                                  value: '0',
                                  color: Colors.orange,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: buildStatCard(
                                  icon: Icons.star,
                                  title: 'Rating',
                                  value: '0.0',
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withValues(alpha: 0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.account_balance_wallet,
                                    color: Colors.green,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Saldo Penjualan',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        'Rp 0',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    showComingSoon(context, 'Penarikan saldo');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: const Text(
                                    'Tarik',
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

                        const SizedBox(height: 28),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Kelola Toko',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: GridView.count(
                            crossAxisCount: 4,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.78,
                            children: [
                              buildActionItem(
                                context,
                                icon: Icons.add_box,
                                title: 'Jual Barang',
                                color: Colors.green,
                                onTap: () async {
                                  final result = await Navigator.push<bool>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SellPage(),
                                    ),
                                  );

                                  if (!context.mounted) return;

                                  if (result == true) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const MyProductsPage(),
                                      ),
                                    );
                                  }
                                },
                              ),
                              buildActionItem(
                                context,
                                icon: Icons.inventory,
                                title: 'Produk Saya',
                                color: Colors.blue,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const MyProductsPage(),
                                    ),
                                  );
                                },
                              ),
                              buildActionItem(
                                context,
                                icon: Icons.local_shipping,
                                title: 'Pengiriman',
                                color: Colors.orange,
                                onTap: () {
                                  showComingSoon(context, 'Cek Pengiriman');
                                },
                              ),
                              buildActionItem(
                                context,
                                icon: Icons.receipt_long,
                                title: 'Pesanan',
                                color: Colors.purple,
                                onTap: () {
                                  showComingSoon(context, 'Pesanan Masuk');
                                },
                              ),
                              buildActionItem(
                                context,
                                icon: Icons.account_balance_wallet,
                                title: 'Saldo',
                                color: Colors.teal,
                                onTap: () {
                                  showComingSoon(context, 'Transaksi Saldo');
                                },
                              ),
                              buildActionItem(
                                context,
                                icon: Icons.chat,
                                title: 'Chat',
                                color: Colors.indigo,
                                onTap: () {
                                  showComingSoon(context, 'Chat Pembeli');
                                },
                              ),
                              buildActionItem(
                                context,
                                icon: Icons.discount,
                                title: 'Promo',
                                color: Colors.redAccent,
                                onTap: () {
                                  showComingSoon(context, 'Promo Toko');
                                },
                              ),
                              buildActionItem(
                                context,
                                icon: Icons.analytics,
                                title: 'Analitik',
                                color: Colors.brown,
                                onTap: () {
                                  showComingSoon(context, 'Analitik Toko');
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Ringkasan Penjualan',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              buildTransactionTile(
                                icon: Icons.pending_actions,
                                title: 'Menunggu Diproses',
                                subtitle: 'Pesanan baru dari pembeli',
                                count: '0',
                                color: Colors.orange,
                                onTap: () {
                                  showComingSoon(context, 'Menunggu Diproses');
                                },
                              ),
                              buildTransactionTile(
                                icon: Icons.inventory_2,
                                title: 'Perlu Dikirim',
                                subtitle: 'Barang yang harus dikirim',
                                count: '0',
                                color: Colors.blue,
                                onTap: () {
                                  showComingSoon(context, 'Perlu Dikirim');
                                },
                              ),
                              buildTransactionTile(
                                icon: Icons.local_shipping,
                                title: 'Dalam Pengiriman',
                                subtitle: 'Pantau status pengiriman',
                                count: '0',
                                color: Colors.green,
                                onTap: () {
                                  showComingSoon(context, 'Dalam Pengiriman');
                                },
                              ),
                              buildTransactionTile(
                                icon: Icons.check_circle,
                                title: 'Penjualan Selesai',
                                subtitle: 'Pesanan sudah diterima pembeli',
                                count: '0',
                                color: Colors.teal,
                                onTap: () {
                                  showComingSoon(context, 'Penjualan Selesai');
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget buildProductCountStat(String userId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where('userId', isEqualTo: userId)
          .snapshots(),
      builder: (context, snapshot) {
        final totalProduct = snapshot.data?.docs.length ?? 0;

        return buildStatCard(
          icon: Icons.inventory_2,
          title: 'Produk',
          value: totalProduct.toString(),
          color: Colors.green,
        );
      },
    );
  }

  Widget buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
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
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }

  Widget buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget buildTransactionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String count,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            count,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  void showComingSoon(BuildContext context, String featureName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$featureName belum dibuat'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
