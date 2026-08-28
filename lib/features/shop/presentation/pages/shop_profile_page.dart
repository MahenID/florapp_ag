import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShopProfilePage extends StatefulWidget {
  const ShopProfilePage({super.key});

  @override
  State<ShopProfilePage> createState() => _ShopProfilePageState();
}

class _ShopProfilePageState extends State<ShopProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser;

  final storeNameController = TextEditingController();
  final storeDescriptionController = TextEditingController();
  final storePhotoController = TextEditingController();
  final storePhoneController = TextEditingController();
  final storeCityController = TextEditingController();
  final storeAddressController = TextEditingController();

  bool isLoading = false;
  bool isOpen = true;

  @override
  void initState() {
    super.initState();
    loadStoreProfile();

    storePhotoController.addListener(() {
      setState(() {});
    });
  }

  Future<void> loadStoreProfile() async {
    if (currentUser == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get();

    final data = doc.data();

    if (data == null) return;

    storeNameController.text =
        data['storeName'] ?? data['name'] ?? 'Toko Florapp Saya';

    storeDescriptionController.text =
        data['storeDescription'] ?? 'Penjual tanaman Florapp';

    storePhotoController.text = data['storePhoto'] ?? data['photoUrl'] ?? '';

    storePhoneController.text = data['storePhone'] ?? '';
    storeCityController.text = data['storeCity'] ?? '';
    storeAddressController.text = data['storeAddress'] ?? '';

    isOpen = data['storeIsOpen'] ?? true;

    setState(() {});
  }

  Future<void> saveStoreProfile() async {
    final storeName = storeNameController.text.trim();
    final storeDescription = storeDescriptionController.text.trim();
    final storePhoto = storePhotoController.text.trim();
    final storePhone = storePhoneController.text.trim();
    final storeCity = storeCityController.text.trim();
    final storeAddress = storeAddressController.text.trim();

    if (storeName.isEmpty ||
        storeDescription.isEmpty ||
        storeCity.isEmpty ||
        storeAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama toko, deskripsi, kota, dan alamat wajib diisi'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .set({
            'storeName': storeName,
            'storeDescription': storeDescription,
            'storePhoto': storePhoto,
            'storePhone': storePhone,
            'storeCity': storeCity,
            'storeAddress': storeAddress,
            'storeIsOpen': isOpen,
            'isSeller': true,
            'storeUpdatedAt': Timestamp.now(),
          }, SetOptions(merge: true));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile toko berhasil disimpan'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan profile toko: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    storeNameController.dispose();
    storeDescriptionController.dispose();
    storePhotoController.dispose();
    storePhoneController.dispose();
    storeCityController.dispose();
    storeAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storePhoto = storePhotoController.text.trim();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: currentUser == null
            ? const Center(child: Text('User belum login'))
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= HEADER =================
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
                                  color: Colors.white.withValues(alpha: 0.18),
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
                                  'Profile Toko',
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
                            'Atur identitas toko yang akan dilihat pembeli',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ================= STORE PREVIEW CARD =================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 14,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 56,
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
                                      size: 56,
                                    )
                                  : null,
                            ),

                            const SizedBox(height: 16),

                            Text(
                              storeNameController.text.trim().isNotEmpty
                                  ? storeNameController.text.trim()
                                  : 'Nama Toko',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              storeDescriptionController.text.trim().isNotEmpty
                                  ? storeDescriptionController.text.trim()
                                  : 'Deskripsi toko akan tampil di sini',
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),

                            const SizedBox(height: 16),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isOpen
                                    ? Colors.green.withValues(alpha: 0.12)
                                    : Colors.red.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                isOpen ? 'Toko Buka' : 'Toko Tutup',
                                style: TextStyle(
                                  color: isOpen ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ================= FORM CARD =================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
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
                            buildInputField(
                              controller: storeNameController,
                              label: 'Nama Toko',
                              icon: Icons.storefront,
                              onChanged: (_) => setState(() {}),
                            ),

                            const SizedBox(height: 18),

                            buildInputField(
                              controller: storeDescriptionController,
                              label: 'Deskripsi Toko',
                              icon: Icons.description,
                              maxLines: 4,
                              onChanged: (_) => setState(() {}),
                            ),

                            const SizedBox(height: 18),

                            buildInputField(
                              controller: storePhotoController,
                              label: 'URL Foto / Logo Toko',
                              icon: Icons.image,
                              keyboardType: TextInputType.url,
                            ),

                            const SizedBox(height: 18),

                            buildInputField(
                              controller: storePhoneController,
                              label: 'Nomor Toko',
                              icon: Icons.phone,
                              keyboardType: TextInputType.phone,
                            ),

                            const SizedBox(height: 18),

                            buildInputField(
                              controller: storeCityController,
                              label: 'Kota Toko',
                              icon: Icons.location_city,
                            ),

                            const SizedBox(height: 18),

                            buildInputField(
                              controller: storeAddressController,
                              label: 'Alamat Toko',
                              icon: Icons.location_on,
                              maxLines: 3,
                            ),

                            const SizedBox(height: 18),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withValues(
                                        alpha: 0.12,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(
                                      Icons.store,
                                      color: Colors.green,
                                    ),
                                  ),

                                  const SizedBox(width: 14),

                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Status Toko',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          'Aktifkan jika toko sedang menerima pesanan',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Switch(
                                    value: isOpen,
                                    activeThumbColor: Colors.green,
                                    onChanged: (value) {
                                      setState(() {
                                        isOpen = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ================= SAVE BUTTON =================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton.icon(
                          onPressed: isLoading ? null : saveStoreProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          icon: isLoading
                              ? const SizedBox()
                              : const Icon(Icons.save, color: Colors.white),
                          label: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Simpan Profile Toko',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
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

  Widget buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.green, width: 1.5),
        ),
      ),
    );
  }
}
