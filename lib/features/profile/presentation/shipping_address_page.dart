import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShippingAddressPage extends StatefulWidget {
  const ShippingAddressPage({super.key});

  @override
  State<ShippingAddressPage> createState() => _ShippingAddressPageState();
}

class _ShippingAddressPageState extends State<ShippingAddressPage> {
  final currentUser = FirebaseAuth.instance.currentUser;

  final fullNameController = TextEditingController();

  final phoneController = TextEditingController();

  final cityController = TextEditingController();

  final provinceController = TextEditingController();

  final postalCodeController = TextEditingController();

  final addressController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadAddress();
  }

  Future<void> loadAddress() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get();

    final data = doc.data();

    if (data == null) return;

    fullNameController.text = data['shippingFullName'] ?? '';

    phoneController.text = data['shippingPhone'] ?? '';

    cityController.text = data['shippingCity'] ?? '';

    provinceController.text = data['shippingProvince'] ?? '';

    postalCodeController.text = data['shippingPostalCode'] ?? '';

    addressController.text = data['shippingAddress'] ?? '';

    setState(() {});
  }

  Future<void> saveAddress() async {
    if (fullNameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        cityController.text.trim().isEmpty ||
        provinceController.text.trim().isEmpty ||
        postalCodeController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Semua field wajib diisi')));

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update({
            'shippingFullName': fullNameController.text.trim(),

            'shippingPhone': phoneController.text.trim(),

            'shippingCity': cityController.text.trim(),

            'shippingProvince': provinceController.text.trim(),

            'shippingPostalCode': postalCodeController.text.trim(),

            'shippingAddress': addressController.text.trim(),
          });

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Alamat berhasil disimpan')));

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

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // HEADER
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },

                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),

                  const SizedBox(width: 16),

                  const Text(
                    'Shipping Address',

                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 35),

              // FULL NAME
              buildInputField(
                controller: fullNameController,

                label: 'Full Name',

                icon: Icons.person,
              ),

              const SizedBox(height: 20),

              // PHONE
              buildInputField(
                controller: phoneController,

                label: 'Phone Number',

                icon: Icons.phone,

                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 20),

              // CITY
              buildInputField(
                controller: cityController,

                label: 'City',

                icon: Icons.location_city,
              ),

              const SizedBox(height: 20),

              // PROVINCE
              buildInputField(
                controller: provinceController,

                label: 'Province',

                icon: Icons.map,
              ),

              const SizedBox(height: 20),

              // POSTAL CODE
              buildInputField(
                controller: postalCodeController,

                label: 'Postal Code',

                icon: Icons.markunread_mailbox,

                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 20),

              // ADDRESS
              buildInputField(
                controller: addressController,

                label: 'Complete Address',

                icon: Icons.home,

                maxLines: 4,
              ),

              const SizedBox(height: 40),

              // SAVE BUTTON
              SizedBox(
                width: double.infinity,
                height: 58,

                child: ElevatedButton(
                  onPressed: isLoading ? null : saveAddress,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,

                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),

                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Save Address',

                          style: TextStyle(
                            color: Colors.white,

                            fontSize: 17,

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 30),
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
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,

      decoration: InputDecoration(
        labelText: label,

        prefixIcon: Icon(icon, color: Colors.green),

        filled: true,
        fillColor: Colors.white,

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
