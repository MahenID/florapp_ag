import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_network_image.dart';
import 'my_products_page.dart';
import 'seller_orders_page.dart';
import 'sell_page.dart';
import 'shop_profile_page.dart';

class ShopToolsPage extends StatelessWidget {
  const ShopToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
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
                  String storeDescription = 'Penjual tanaman hias Florapp';
                  String storePhoto = '';
                  bool storeIsOpen = true;

                  if (snapshot.hasData && snapshot.data!.exists) {
                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    storeName = data['storeName'] ??
                        data['name'] ??
                        'Toko Florapp Saya';
                    storeDescription = data['storeDescription'] ??
                        'Penjual tanaman hias Florapp';
                    storePhoto =
                        data['storePhoto'] ?? data['photoUrl'] ?? '';
                    storeIsOpen = data['storeIsOpen'] ?? true;
                  }

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // HEADER
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(32),
                              bottomRight: Radius.circular(32),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Alat & Pengaturan Toko',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              const Padding(
                                padding: EdgeInsets.only(left: 12),
                                child: Text(
                                  'Konfigurasi fitur operasional dan promosi seller',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // STORE PROFILE CARD
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            padding: const EdgeInsets.all(18),
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
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.green, width: 1.5),
                                  ),
                                  child: CircleAvatar(
                                    radius: 28,
                                    backgroundColor: Colors.green.shade50,
                                    child: ClipOval(
                                      child: AppNetworkImage(
                                        imageUrl: storePhoto,
                                        width: 56,
                                        height: 56,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
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
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1E293B),
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        storeDescription,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: storeIsOpen
                                              ? Colors.green
                                                  .withValues(alpha: 0.12)
                                              : Colors.red
                                                  .withValues(alpha: 0.12),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          storeIsOpen
                                              ? '● Toko Aktif / Buka'
                                              : '● Toko Tutup Sementara',
                                          style: TextStyle(
                                            color: storeIsOpen
                                                ? Colors.green.shade800
                                                : Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
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

                        const SizedBox(height: 24),

                        buildSectionTitle('Manajemen Operasional'),
                        buildMenuTile(
                          context,
                          icon: Icons.storefront_outlined,
                          title: 'Profil Toko',
                          subtitle:
                              'Atur nama toko, logo, deskripsi, alamat, dan jam buka',
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
                          icon: Icons.receipt_long_outlined,
                          title: 'Pesanan Masuk Toko',
                          subtitle: 'Pantau pesanan diproses, dikirim, dan selesai',
                          color: Colors.blue,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SellerOrdersPage(),
                              ),
                            );
                          },
                        ),
                        buildMenuTile(
                          context,
                          icon: Icons.inventory_2_outlined,
                          title: 'Katalog Tanaman Saya',
                          subtitle: 'Lihat daftar tanaman yang sedang kamu jual',
                          color: Colors.teal,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MyProductsPage(),
                              ),
                            );
                          },
                        ),
                        buildMenuTile(
                          context,
                          icon: Icons.add_circle_outline,
                          title: 'Tambah Tanaman Baru',
                          subtitle: 'Upload foto tanaman, deskripsi, dan harga jual',
                          color: Colors.orange,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SellPage(),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 20),

                        buildSectionTitle('Pusat Bantuan & Panduan'),
                        buildMenuTile(
                          context,
                          icon: Icons.local_shipping_outlined,
                          title: 'Panduan Ekspedisi & Resi',
                          subtitle: 'Cara input nomor resi dan pengiriman kilat',
                          color: Colors.indigo,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                title: const Text('Panduan Ekspedisi'),
                                content: const Text(
                                  'Gunakan layanan pengiriman kilat (JNE YES / SiCepat BEST / Instant) terutama untuk tanaman langka atau berdaun tipis agar tiba dalam keadaan segar.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text('Tutup'),
                                  ),
                                ],
                              ),
                            );
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E293B),
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          onTap: onTap,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF1E293B),
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            size: 20,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
