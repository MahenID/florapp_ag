import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser;

  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final phoneController = TextEditingController();

  final photoController = TextEditingController();

  bool isLoading = false;

  File? selectedImage;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get();

    final data = doc.data() as Map<String, dynamic>;

    nameController.text = data['name'] ?? '';

    emailController.text = data['email'] ?? '';

    phoneController.text = data['phone'] ?? '';

    photoController.text = data['photoUrl'] ?? '';

    setState(() {});
  }

  Future<void> pickAndCropImage() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,

      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),

      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Foto',
          toolbarColor: Colors.green,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: true,
        ),

        IOSUiSettings(title: 'Crop Foto'),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        selectedImage = File(croppedFile.path);
      });
    }
  }

  Future<void> updateProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update({
            'name': nameController.text.trim(),

            'phone': phoneController.text.trim(),

            'photoUrl': photoController.text.trim(),
          });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile berhasil diupdate')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: SingleChildScrollView(
        child: Column(
          children: [
            // TOP HEADER
            Container(
              height: 220,
              width: double.infinity,

              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                ),

                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),

                  bottomRight: Radius.circular(40),
                ),
              ),

              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },

                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),

                      const Text(
                        'Edit Profile',

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 40),
                    ],
                  ),
                ),
              ),
            ),

            Transform.translate(
              offset: const Offset(0, -60),

              child: Column(
                children: [
                  // PROFILE IMAGE
                  GestureDetector(
                    onTap: pickAndCropImage,

                    child: CircleAvatar(
                      radius: 65,
                      backgroundColor: Colors.white,

                      child: CircleAvatar(
                        radius: 60,

                        backgroundImage: selectedImage != null
                            ? FileImage(selectedImage!)
                            : photoController.text.isNotEmpty
                            ? NetworkImage(photoController.text)
                            : null as ImageProvider?,

                        child:
                            selectedImage == null &&
                                photoController.text.isEmpty
                            ? const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.grey,
                              )
                            : null,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Icon(Icons.camera_alt, color: Colors.grey, size: 18),

                      SizedBox(width: 6),

                      Text(
                        'Ubah Foto Profile',

                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),

              child: Column(
                children: [
                  // NAME
                  buildInputField(
                    controller: nameController,

                    label: 'Username',

                    icon: Icons.person,
                  ),

                  const SizedBox(height: 20),

                  // EMAIL
                  buildInputField(
                    controller: emailController,

                    label: 'Email',

                    icon: Icons.email,

                    enabled: false,
                  ),

                  const SizedBox(height: 20),

                  // PHONE
                  buildInputField(
                    controller: phoneController,

                    label: 'Phone Number',

                    icon: Icons.phone,
                  ),

                  const SizedBox(height: 20),

                  // PHOTO URL
                  buildInputField(
                    controller: photoController,

                    label: 'Photo URL',

                    icon: Icons.image,
                  ),

                  const SizedBox(height: 40),

                  // UPDATE BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton(
                      onPressed: isLoading ? null : updateProfile,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),

                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Update Profile',

                              style: TextStyle(
                                color: Colors.white,

                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputField({
    required TextEditingController controller,

    required String label,

    required IconData icon,

    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,

      decoration: InputDecoration(
        labelText: label,

        prefixIcon: Icon(icon, color: Colors.green),

        filled: true,
        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),

          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
