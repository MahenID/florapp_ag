import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'shop_profile_page.dart';

class ShopToolsPage extends StatelessWidget {
  const ShopToolsPage({super.key});

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
                  String storeDescription = 'Penjual tanaman Florapp';
                  String storePhoto = '';
                  bool storeIsOpen = true;

                  if (snapshot.hasData && snapshot.data!.exists) {
                    final data = snapshot.data!.data() as Map<String, dynamic>;

                    storeName =
                        data['storeName'] ??
                        data['name'] ??
                        'Toko Florapp Saya';
                    storeDescription =
                        data['storeDescription'] ?? 'Penjual tanaman Florapp';
                    storePhoto = data['storePhoto'] ?? data['photoUrl'] ?? '';
                    storeIsOpen = data['storeIsOpen'] ?? true;
                  }

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(20, 22, 20, 34),
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
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.18,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: IconButton(
                                      onPressed: () => Navigator.pop(context),
                                      icon: const Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  const Expanded(
                                    child: Text(
                                      'Fitur Toko',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Kelola pengaturan dan fitur seller Florapp',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
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
                            padding: const EdgeInsets.all(18),
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
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 34,
                                  backgroundColor: Colors.green.withValues(
                                    alpha: 0.12,
                                  ),
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
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        storeDescription,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 13,
                                          height: 1.3,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: storeIsOpen
                                              ? Colors.green.withValues(
                                                  alpha: 0.12,
                                                )
                                              : Colors.red.withValues(
                                                  alpha: 0.12,
                                                ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          storeIsOpen
                                              ? 'Toko Buka'
                                              : 'Toko Tutup',
                                          style: TextStyle(
                                            color: storeIsOpen
                                                ? Colors.green
                                                : Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
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

                        const SizedBox(height: 28),

                        buildSectionTitle('Identitas Toko'),

                        buildMenuTile(
                          context,
                          icon: Icons.store_mall_directory,
                          title: 'Profil Toko',
                          subtitle:
                              'Atur nama toko, logo, deskripsi, dan alamat',
                          color: Colors.green,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ShopProfilePage(),
                              ),
                            );
                          },
                        ),

                        buildMenuTile(
                          context,
                          icon: Icons.verified,
                          title: 'Verifikasi Penjual',
                          subtitle: 'Lengkapi data agar toko lebih dipercaya',
                          color: Colors.blue,
                          onTap: () {
                            showComingSoon(context, 'Verifikasi Penjual');
                          },
                        ),

                        const SizedBox(height: 18),

                        buildSectionTitle('Keuangan Toko'),

                        buildMenuTile(
                          context,
                          icon: Icons.account_balance_wallet,
                          title: 'Riwayat Saldo',
                          subtitle: 'Lihat pemasukan dan penarikan saldo',
                          color: Colors.teal,
                          onTap: () {
                            showComingSoon(context, 'Riwayat Saldo');
                          },
                        ),

                        buildMenuTile(
                          context,
                          icon: Icons.payments,
                          title: 'Rekening Penarikan',
                          subtitle: 'Atur rekening untuk pencairan saldo',
                          color: Colors.orange,
                          onTap: () {
                            showComingSoon(context, 'Rekening Penarikan');
                          },
                        ),

                        const SizedBox(height: 18),

                        buildSectionTitle('Operasional Toko'),

                        buildMenuTile(
                          context,
                          icon: Icons.local_shipping,
                          title: 'Pengaturan Pengiriman',
                          subtitle: 'Kelola jasa kirim dan area pengiriman',
                          color: Colors.purple,
                          onTap: () {
                            showComingSoon(context, 'Pengaturan Pengiriman');
                          },
                        ),

                        buildMenuTile(
                          context,
                          icon: Icons.discount,
                          title: 'Promo Toko',
                          subtitle: 'Buat voucher dan promo untuk pembeli',
                          color: Colors.redAccent,
                          onTap: () {
                            showComingSoon(context, 'Promo Toko');
                          },
                        ),

                        buildMenuTile(
                          context,
                          icon: Icons.analytics,
                          title: 'Analitik Toko',
                          subtitle: 'Lihat performa produk dan penjualan',
                          color: Colors.brown,
                          onTap: () {
                            showComingSoon(context, 'Analitik Toko');
                          },
                        ),

                        const SizedBox(height: 18),

                        buildSectionTitle('Bantuan'),

                        buildMenuTile(
                          context,
                          icon: Icons.support_agent,
                          title: 'Pusat Bantuan Seller',
                          subtitle: 'Bantuan untuk mengelola toko Florapp',
                          color: Colors.indigo,
                          onTap: () {
                            showComingSoon(context, 'Pusat Bantuan Seller');
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Text(
        title,
        style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
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
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 8,
          ),
          leading: Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(subtitle),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
          onTap: onTap,
        ),
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
