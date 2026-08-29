import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../shared/services/favorite_service.dart';
import '../../../../shared/services/order_service.dart';
import '../../../../shared/widgets/app_network_image.dart';
import '../../../auth/presentation/login_page.dart';
import '../../../auth/services/auth_service.dart';
import '../../../orders/domain/order_model.dart';
import '../../../profile/presentation/edit_profile_page.dart';
import '../../../profile/presentation/settings_page.dart';
import '../../../profile/presentation/shipping_address_page.dart';
import '../../../profile/presentation/wishlist_page.dart';
import '../../../shop/presentation/pages/sell_page.dart';
import 'shop_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final orderService = OrderService();
    final favoriteService = FavoriteService();
    final authService = AuthService();

    if (currentUser == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Anda belum login'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                },
                child: const Text('Ke Halaman Login'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .snapshots(),
          builder: (context, userSnapshot) {
            Map<String, dynamic> userData = {};
            if (userSnapshot.hasData && userSnapshot.data!.exists) {
              userData = userSnapshot.data!.data() as Map<String, dynamic>;
            }

            final name = userData['name'] ?? 'Pengguna FlorApp';
            final email = userData['email'] ?? currentUser.email ?? '';
            final phone = userData['phone'] ?? '';
            final photoUrl = userData['photoUrl'] ?? '';
            final storeName = userData['storeName'] ?? 'Toko FlorApp Saya';
            final storePhoto = userData['storePhoto'] ?? photoUrl;

            return StreamBuilder<List<OrderModel>>(
              stream: orderService.getBuyerOrders(),
              builder: (context, ordersSnapshot) {
                final orders = ordersSnapshot.data ?? [];
                final pendingOrders =
                    orders.where((o) => o.status == 'diproses').length;
                final shippingOrders =
                    orders.where((o) => o.status == 'dikirim').length;
                final completedOrders =
                    orders.where((o) => o.status == 'selesai').length;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Column(
                    children: [
                      // ================= HEADER PROFILE =================
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
                          children: [
                            // TOP ACTIONS
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.eco,
                                          color: Colors.white, size: 14),
                                      SizedBox(width: 4),
                                      Text(
                                        'Flora Member',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const EditProfilePage(),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.edit_outlined,
                                          color: Colors.white),
                                      tooltip: 'Ubah Profil',
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const SettingsPage(),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.settings_outlined,
                                          color: Colors.white),
                                      tooltip: 'Pengaturan',
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // USER DETAILS
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipOval(
                                    child: AppNetworkImage(
                                      imageUrl: photoUrl,
                                      width: 68,
                                      height: 68,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        email,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      if (phone.isNotEmpty) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          phone,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white60,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // ================= WALLET & REWARDS FLOATING BAR =================
                      Transform.translate(
                        offset: const Offset(0, -18),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildWalletItem(
                                  context,
                                  icon: Icons.account_balance_wallet_outlined,
                                  title: 'Saldo FlorApp',
                                  value: 'Rp 0',
                                  color: Colors.green,
                                  onTap: () => _showWalletInfoDialog(context),
                                ),
                                Container(
                                    width: 1,
                                    height: 36,
                                    color: Colors.grey.shade200),
                                _buildWalletItem(
                                  context,
                                  icon: Icons.monetization_on_outlined,
                                  title: 'FlorPoin',
                                  value: '2.500',
                                  color: Colors.amber.shade700,
                                  onTap: () => _showPointsDialog(context),
                                ),
                                Container(
                                    width: 1,
                                    height: 36,
                                    color: Colors.grey.shade200),
                                _buildWalletItem(
                                  context,
                                  icon: Icons.confirmation_number_outlined,
                                  title: 'Voucher Saya',
                                  value: '3 Voucher',
                                  color: Colors.blue,
                                  onTap: () => _showVoucherDialog(context),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ================= PESANAN SAYA (BUYER ORDERS) =================
                            _buildSectionHeader(
                              title: 'Pesanan Saya',
                              actionText: 'Lihat Riwayat Transaksi',
                              onActionTap: () {},
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 12),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildOrderStatusIcon(
                                    icon: Icons.account_balance_wallet_outlined,
                                    label: 'Belum Bayar',
                                    color: Colors.orange,
                                    badgeCount: 0,
                                  ),
                                  _buildOrderStatusIcon(
                                    icon: Icons.inventory_2_outlined,
                                    label: 'Diproses',
                                    color: Colors.orange,
                                    badgeCount: pendingOrders,
                                  ),
                                  _buildOrderStatusIcon(
                                    icon: Icons.local_shipping_outlined,
                                    label: 'Dikirim',
                                    color: Colors.blue,
                                    badgeCount: shippingOrders,
                                  ),
                                  _buildOrderStatusIcon(
                                    icon: Icons.rate_review_outlined,
                                    label: 'Beri Ulasan',
                                    color: Colors.green,
                                    badgeCount: completedOrders,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // ================= BUYER FAVORITE & ACTIVITY =================
                            const Text(
                              'Aktivitas Saya',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 12),
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              stream: favoriteService.getFavorites(),
                              builder: (context, favSnapshot) {
                                final favCount =
                                    favSnapshot.data?.docs.length ?? 0;

                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(22),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.04),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      _buildMenuTile(
                                        icon: Icons.favorite_outline,
                                        iconColor: Colors.red,
                                        title: 'Wishlist Tanaman',
                                        subtitle:
                                            '$favCount tanaman disimpan',
                                        badgeText: favCount > 0
                                            ? '$favCount Item'
                                            : null,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const WishlistPage(),
                                            ),
                                          );
                                        },
                                      ),
                                      const Divider(height: 1, indent: 60),
                                      _buildMenuTile(
                                        icon: Icons.star_border,
                                        iconColor: Colors.amber.shade700,
                                        title: 'Ulasan & Penilaian Saya',
                                        subtitle: 'Lihat ulasan yang kamu berikan',
                                        onTap: () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Membuka ulasan tanaman kamu'),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 24),

                            // ================= SELLER CENTER SHORTCUT =================
                            const Text(
                              'Pusat Penjual (Toko Saya)',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: Colors.green.withValues(alpha: 0.25),
                                  width: 1.5,
                                ),
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
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.green, width: 1.5),
                                        ),
                                        child: CircleAvatar(
                                          radius: 24,
                                          backgroundColor:
                                              Colors.green.shade50,
                                          child: ClipOval(
                                            child: AppNetworkImage(
                                              imageUrl: storePhoto,
                                              width: 48,
                                              height: 48,
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
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF1E293B),
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            const Text(
                                              'Kelola penjualan & tanaman di tokomu',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const SellPage(),
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.add,
                                              size: 16, color: Colors.green),
                                          label: const Text(
                                            'Jual Tanaman',
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(
                                                color: Colors.green),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const ShopPage(),
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.storefront,
                                              size: 16, color: Colors.white),
                                          label: const Text(
                                            'Shop Center',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // ================= ACCOUNT & SERVICES =================
                            const Text(
                              'Pengaturan Akun & Layanan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
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
                                  _buildMenuTile(
                                    icon: Icons.location_on_outlined,
                                    iconColor: Colors.teal,
                                    title: 'Daftar Alamat Pengiriman',
                                    subtitle: 'Atur alamat kirim pesananmu',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const ShippingAddressPage(),
                                        ),
                                      );
                                    },
                                  ),
                                  const Divider(height: 1, indent: 60),
                                  _buildMenuTile(
                                    icon: Icons.help_outline,
                                    iconColor: Colors.blue,
                                    title: 'Pusat Bantuan & Layanan FlorApp',
                                    subtitle: 'FAQ transaksi & panduan tanaman',
                                    onTap: () => _showHelpDialog(context),
                                  ),
                                  const Divider(height: 1, indent: 60),
                                  _buildMenuTile(
                                    icon: Icons.security_outlined,
                                    iconColor: Colors.indigo,
                                    title: 'Keamanan Akun & Sandi',
                                    subtitle: 'Kata sandi & verifikasi',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const SettingsPage(),
                                        ),
                                      );
                                    },
                                  ),
                                  const Divider(height: 1, indent: 60),
                                  _buildMenuTile(
                                    icon: Icons.info_outline,
                                    iconColor: Colors.grey.shade700,
                                    title: 'Tentang FlorApp',
                                    subtitle: 'Versi 1.0.0 (Marketplace Tanaman)',
                                    onTap: () => _showAboutDialog(context),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 28),

                            // ================= LOGOUT BUTTON =================
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: OutlinedButton.icon(
                                onPressed: () =>
                                    _confirmLogout(context, authService),
                                icon: const Icon(Icons.logout,
                                    color: Colors.red, size: 20),
                                label: const Text(
                                  'Keluar dari Akun',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.red.shade200),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildWalletItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 16),
                const SizedBox(width: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String actionText,
    required VoidCallback onActionTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        Text(
          actionText,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderStatusIcon({
    required IconData icon,
    required String label,
    required Color color,
    int badgeCount = 0,
  }) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            if (badgeCount > 0)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    badgeCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    String? badgeText,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: iconColor, size: 22),
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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badgeText != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badgeText,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(width: 6),
          ],
          const Icon(
            Icons.chevron_right,
            size: 20,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  void _showWalletInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Saldo FlorApp'),
        content: const Text(
          'Saldo FlorApp dapat digunakan untuk pembayaran instan tanaman, ongkos kirim, dan cashback pesanan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showPointsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('FlorPoin Reward'),
        content: const Text(
          'Kumpulkan FlorPoin setiap menyelesaikan pembelian tanaman untuk ditukar dengan voucher potongan harga dan gratis ongkir!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showVoucherDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Voucher Saya'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🎁 Diskon Ongkir Rp 10.000 (Min. Belanja Rp 50.000)'),
            SizedBox(height: 8),
            Text('🌿 Potongan 15% Bibit Anggrek (Weekend Flora)'),
            SizedBox(height: 8),
            Text('🚚 Gratis Ongkir Khusus Tanaman Indoor'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Pusat Bantuan FlorApp'),
        content: const Text(
          'Butuh bantuan mengenai pesanan atau ingin berkonsultasi mengenai perawatan tanaman? Hubungi Customer Service FlorApp melalui WhatsApp atau email support@florapp.id.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Tentang FlorApp'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('FlorApp Marketplace v1.0.0'),
            SizedBox(height: 6),
            Text(
              'Aplikasi marketplace tanaman mobile berbasis Flutter & Firebase. Memberdayakan pecinta tanaman untuk bertransaksi dengan aman dan mudah.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context, AuthService authService) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Keluar dari Akun'),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari akun FlorApp?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await authService.logout();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child:
                const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
