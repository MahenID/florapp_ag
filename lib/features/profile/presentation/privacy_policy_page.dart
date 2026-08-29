import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: const Text(
          'Kebijakan Privasi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Kebijakan Privasi Pengguna FlorApp',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Terakhir diperbarui: 29 Agustus 2026',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              const Divider(height: 24),
              _buildSection(
                '1. Pengumpulan Informasi',
                'Kami mengumpulkan informasi yang Anda berikan saat mendaftar akun, seperti nama lengkap, alamat email, nomor telepon, foto profil, dan alamat pengiriman pesanan.',
              ),
              _buildSection(
                '2. Penggunaan Data',
                'Informasi yang dikumpulkan digunakan untuk memproses transaksi pembelian tanaman, pengiriman paket oleh kurir, pengelolaan saldo penjualan toko, serta memberikan notifikasi terkait status pesanan.',
              ),
              _buildSection(
                '3. Keamanan Data',
                'FlorApp menggunakan teknologi enkripsi dan standar keamanan Cloud Firebase untuk melindungi data pribadi dan kata sandi Anda dari akses tanpa izin.',
              ),
              _buildSection(
                '4. Hak Pengguna',
                'Anda memiliki hak penuh untuk memperbarui profil, mengubah alamat pengiriman, mengganti kata sandi, atau menghapus akun Anda kapan saja melalui menu Pengaturan Profil.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
