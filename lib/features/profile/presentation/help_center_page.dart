import 'package:flutter/material.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  final List<Map<String, dynamic>> faqs = const [
    {
      'question': 'Bagaimana cara membeli tanaman di FlorApp?',
      'answer':
          'Pilih tanaman yang Anda minati di halaman Beranda atau gunakan fitur pencarian. Klik "Tambah ke Keranjang" atau "Beli Sekarang", lalu lanjutkan ke proses Checkout untuk memilih kurir dan metode pembayaran.',
    },
    {
      'question': 'Bagaimana keamanan pengiriman tanaman hidup?',
      'answer':
          'Setiap penjual di FlorApp diwajibkan mengemas tanaman dengan media tanam lembap yang terbungkus rapi serta kardus kokoh berlubang sirkulasi udara untuk memastikan tanaman tiba dalam kondisi segar.',
    },
    {
      'question': 'Bagaimana cara menjadi penjual (buka toko)?',
      'answer':
          'Cukup masuk ke tab "Shop", atur Profil Toko Anda (nama, lokasi, deskripsi), lalu mulai tambahkan tanaman yang ingin dijual melalui menu "Tambah Tanaman".',
    },
    {
      'question': 'Kapan saldo penjualan toko dapat ditarik?',
      'answer':
          'Saldo penjualan akan langsung masuk ke "Saldo Siap Ditarik" di halaman Shop Center segera setelah pembeli mengonfirmasi "Terima Barang" atau pesanan selesai.',
    },
    {
      'question': 'Bagaimana jika tanaman tiba dalam keadaan mati / rusak?',
      'answer':
          'Anda dapat mengajukan bantuan melalui Customer Service FlorApp dengan menyertakan bukti foto dan video unboxing paket dalam 1x24 jam sejak paket diterima.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: const Text(
          'Pusat Bantuan & FAQ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CS CARD
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.headset_mic,
                        color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Butuh Bantuan Langsung?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Customer Service FlorApp siap melayani setiap hari 08:00 - 20:00 WIB',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Pertanyaan yang Sering Diajukan (FAQ)',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),

            const SizedBox(height: 12),

            ...faqs.map((faq) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ExpansionTile(
                    shape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.transparent)),
                    tilePadding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.help_outline,
                          color: Colors.green, size: 20),
                    ),
                    title: Text(
                      faq['question'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                        child: Text(
                          faq['answer'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
