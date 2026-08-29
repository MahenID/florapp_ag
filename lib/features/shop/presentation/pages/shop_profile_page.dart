import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/widgets/app_network_image.dart';

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
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    loadStoreProfile();
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

  Future<void> loadStoreProfile() async {
    if (currentUser == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      final data = doc.data();
      if (data == null) return;

      storeNameController.text =
          data['storeName'] ?? data['name'] ?? 'Toko Florapp Saya';
      storeDescriptionController.text =
          data['storeDescription'] ?? 'Penjual tanaman hias Florapp';
      storePhotoController.text =
          data['storePhoto'] ?? data['photoUrl'] ?? '';
      storePhoneController.text = data['storePhone'] ?? data['phone'] ?? '';
      storeCityController.text = data['storeCity'] ?? '';
      storeAddressController.text =
          data['storeAddress'] ?? data['shippingAddress'] ?? '';
      isOpen = data['storeIsOpen'] ?? true;

      if (mounted) setState(() {});
    } catch (_) {}
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 75,
    );

    if (pickedFile == null) return;

    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Potong Foto Toko',
            toolbarColor: Colors.green,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true,
          ),
          IOSUiSettings(title: 'Potong Foto Toko'),
        ],
      );

      final imageFile =
          croppedFile != null ? File(croppedFile.path) : File(pickedFile.path);
      final bytes = await imageFile.readAsBytes();
      final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';

      setState(() {
        selectedImage = imageFile;
        storePhotoController.text = base64Image;
      });
    } catch (e) {
      final bytes = await File(pickedFile.path).readAsBytes();
      final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';
      setState(() {
        selectedImage = File(pickedFile.path);
        storePhotoController.text = base64Image;
      });
    }
  }

  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pilih Sumber Foto Toko',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.green),
                ),
                title: const Text('Kamera',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(ctx);
                  pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.photo_library, color: Colors.blue),
                ),
                title: const Text('Galeri HP',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(ctx);
                  pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveStoreProfile() async {
    final storeName = storeNameController.text.trim();
    final storeDescription = storeDescriptionController.text.trim();
    final storePhoto = storePhotoController.text.trim();
    final storePhone = storePhoneController.text.trim();
    final storeCity = storeCityController.text.trim();
    final storeAddress = storeAddressController.text.trim();

    if (storeName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama toko wajib diisi'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

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
          content: Text('Profil toko berhasil disimpan!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan profil toko: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: const Text(
          'Profil & Pengaturan Toko',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // STORE PHOTO
            Center(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 54,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: selectedImage != null
                            ? Image.file(
                                selectedImage!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            : AppNetworkImage(
                                imageUrl: storePhotoController.text,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _showImageSourcePicker,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            TextButton(
              onPressed: _showImageSourcePicker,
              child: const Text(
                'Ganti Foto Toko',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 18),

            // FORM CONTAINER
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
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
                  // STORE STATUS TOGGLE
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isOpen
                          ? Colors.green.withValues(alpha: 0.08)
                          : Colors.red.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isOpen
                            ? Colors.green.withValues(alpha: 0.25)
                            : Colors.red.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isOpen ? Icons.store : Icons.store_mall_directory_outlined,
                              color: isOpen ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isOpen ? 'Status Toko: Buka' : 'Status Toko: Tutup Sementara',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: isOpen ? Colors.green.shade800 : Colors.red,
                                  ),
                                ),
                                Text(
                                  isOpen ? 'Menerima pesanan tanaman baru' : 'Tidak menerima pesanan',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Switch(
                          value: isOpen,
                          activeColor: Colors.green, // ignore: deprecated_member_use
                          onChanged: (val) {
                            setState(() => isOpen = val);
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  buildInputField(
                    controller: storeNameController,
                    label: 'Nama Toko Tanaman',
                    icon: Icons.storefront,
                    hintText: 'Misal: Kebun Flora Lestari',
                  ),

                  const SizedBox(height: 16),

                  buildInputField(
                    controller: storeDescriptionController,
                    label: 'Deskripsi / Slogan Toko',
                    icon: Icons.description_outlined,
                    hintText: 'Misal: Spesialis Monstera, Calathea, & Anggrek Bulan',
                    maxLines: 2,
                  ),

                  const SizedBox(height: 16),

                  buildInputField(
                    controller: storeCityController,
                    label: 'Kota / Lokasi Asal Pengiriman',
                    icon: Icons.location_city,
                    hintText: 'Misal: Kota Bandung, Jawa Barat',
                  ),

                  const SizedBox(height: 16),

                  buildInputField(
                    controller: storePhoneController,
                    label: 'Nomor WhatsApp Toko',
                    icon: Icons.phone_outlined,
                    hintText: 'Misal: 081234567890',
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 16),

                  buildInputField(
                    controller: storeAddressController,
                    label: 'Alamat Lengkap Toko / GreenHouse',
                    icon: Icons.home_outlined,
                    hintText: 'Jalan, nomor rumah/kebun, kecamatan...',
                    maxLines: 3,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isLoading ? null : saveStoreProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        'Simpan Profil Toko',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            prefixIcon: Icon(icon, color: Colors.green),
            filled: true,
            fillColor: const Color(0xFFF8FAF9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.green, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
