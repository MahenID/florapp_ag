import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../auth/presentation/login_page.dart';
import '../../auth/services/auth_service.dart';
import '../../navigation/presentation/pages/shop_page.dart';
import '../../navigation/presentation/pages/transaction_page.dart';
import 'about_app_page.dart';
import 'change_password_page.dart';
import 'edit_profile_page.dart';
import 'help_center_page.dart';
import 'privacy_policy_page.dart';
import 'shipping_address_page.dart';
import 'wishlist_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationEnabled = true;
  bool darkModeEnabled = false;
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            children: [
              // ================= HEADER =================
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
                          icon: const Icon(Icons.arrow_back,
                              color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Pengaturan Akun',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                        currentUser?.email ?? 'Kelola preferensi dan privasi akunmu',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // ACCOUNT SECTION
                    buildSectionTitle('Akun & Keamanan'),
                    buildMenuTile(
                      Icons.person_outline,
                      'Ubah Profil',
                      'Nama lengkap, nomor telepon, dan foto profil',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditProfilePage(),
                          ),
                        );
                      },
                    ),
                    buildMenuTile(
                      Icons.location_on_outlined,
                      'Alamat Pengiriman',
                      'Kelola alamat tujuan kirim tanaman',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ShippingAddressPage(),
                          ),
                        );
                      },
                    ),
                    buildMenuTile(
                      Icons.lock_outline,
                      'Ubah Kata Sandi',
                      'Perbarui kata sandi akun FlorApp',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ChangePasswordPage(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 18),

                    // MARKETPLACE SECTION
                    buildSectionTitle('Aktivitas Marketplace'),
                    buildMenuTile(
                      Icons.favorite_outline,
                      'Wishlist Tanaman',
                      'Daftar tanaman impian yang disimpan',
                      color: Colors.red,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const WishlistPage(),
                          ),
                        );
                      },
                    ),
                    buildMenuTile(
                      Icons.storefront_outlined,
                      'Pusat Toko Penjual',
                      'Kelola katalog tanaman & pesanan toko',
                      color: Colors.green,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ShopPage(),
                          ),
                        );
                      },
                    ),
                    buildMenuTile(
                      Icons.receipt_long_outlined,
                      'Pesanan Saya',
                      'Pantau pesanan diproses, dikirim, dan selesai',
                      color: Colors.blue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TransactionPage(
                              initialTabIndex: 1,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 18),

                    // PREFERENCES SECTION
                    buildSectionTitle('Preferensi Aplikasi'),
                    buildSwitchTile(
                      Icons.notifications_outlined,
                      'Notifikasi Transaksi & Promo',
                      notificationEnabled,
                      (value) {
                        setState(() => notificationEnabled = value);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(value
                                ? 'Notifikasi diaktifkan'
                                : 'Notifikasi dinonaktifkan'),
                            duration: const Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                    buildSwitchTile(
                      Icons.dark_mode_outlined,
                      'Mode Gelap (Dark Mode)',
                      darkModeEnabled,
                      (value) {
                        setState(() => darkModeEnabled = value);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Mode gelap akan hadir pada rilis berikutnya'),
                            duration: Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 18),

                    // SUPPORT SECTION
                    buildSectionTitle('Bantuan & Informasi'),
                    buildMenuTile(
                      Icons.help_outline,
                      'Pusat Bantuan & FAQ',
                      'Pertanyaan sering diajukan & panduan belanja',
                      color: Colors.teal,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HelpCenterPage(),
                          ),
                        );
                      },
                    ),
                    buildMenuTile(
                      Icons.info_outline,
                      'Tentang FlorApp',
                      'Informasi versi aplikasi v1.0.0',
                      color: Colors.indigo,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AboutAppPage(),
                          ),
                        );
                      },
                    ),
                    buildMenuTile(
                      Icons.privacy_tip_outlined,
                      'Kebijakan Privasi',
                      'Perlindungan data dan privasi pengguna',
                      color: Colors.deepOrange,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PrivacyPolicyPage(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 28),

                    // LOGOUT BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: () => _confirmLogout(),
                        icon: const Icon(Icons.logout, color: Colors.red),
                        label: const Text(
                          'Keluar dari Akun',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
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

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmLogout() {
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
              if (!mounted) return;
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

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
      ),
    );
  }

  Widget buildMenuTile(
    IconData icon,
    String title,
    String subtitle, {
    Color color = Colors.green,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
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
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          size: 20,
          color: Colors.grey,
        ),
        onTap: onTap ?? () {},
      ),
    );
  }

  Widget buildSwitchTile(
    IconData icon,
    String title,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.green, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: Colors.green,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
