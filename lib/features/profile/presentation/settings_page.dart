import 'shipping_address_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../auth/presentation/login_page.dart';
import '../../auth/services/auth_service.dart';
import 'edit_profile_page.dart';

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
      backgroundColor: Colors.grey.shade100,

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.only(bottom: 30),

          child: Column(
            children: [
              // =========================
              // HEADER
              // =========================
              Container(
                width: double.infinity,

                padding: const EdgeInsets.only(
                  top: 24,
                  left: 24,
                  right: 24,
                  bottom: 40,
                ),

                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF81C784)],

                    begin: Alignment.topLeft,

                    end: Alignment.bottomRight,
                  ),

                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),

                    bottomRight: Radius.circular(40),
                  ),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // TITLE
                    const Text(
                      'Settings',

                      style: TextStyle(
                        color: Colors.white,

                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // EMAIL
                    Text(
                      currentUser?.email ?? '',

                      style: const TextStyle(
                        color: Colors.white70,

                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // =========================
              // CONTENT
              // =========================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                child: Column(
                  children: [
                    // ACCOUNT SECTION
                    buildSectionTitle('Account'),

                    buildMenuTile(
                      Icons.person,
                      'Edit Profile',
                      'Update your profile',

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
                      Icons.location_on,
                      'Shipping Address',
                      'Manage your address',

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
                      Icons.lock,
                      'Change Password',
                      'Update your password',
                    ),

                    const SizedBox(height: 20),

                    // MARKETPLACE SECTION
                    buildSectionTitle('Marketplace'),

                    buildMenuTile(
                      Icons.favorite,
                      'Wishlist',
                      'Your favorite plants',
                    ),

                    buildMenuTile(
                      Icons.store,
                      'Seller Dashboard',
                      'Manage your products',
                    ),

                    buildMenuTile(
                      Icons.shopping_bag,
                      'My Orders',
                      'View your orders',
                    ),

                    const SizedBox(height: 20),

                    // PREFERENCES SECTION
                    buildSectionTitle('Preferences'),

                    buildSwitchTile(
                      Icons.notifications,
                      'Notifications',
                      notificationEnabled,

                      (value) {
                        setState(() {
                          notificationEnabled = value;
                        });
                      },
                    ),

                    buildSwitchTile(
                      Icons.dark_mode,
                      'Dark Mode',
                      darkModeEnabled,

                      (value) {
                        setState(() {
                          darkModeEnabled = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    // SUPPORT SECTION
                    buildSectionTitle('Support'),

                    buildMenuTile(Icons.help, 'Help Center', 'Get support'),

                    buildMenuTile(
                      Icons.info,
                      'About Florapp',
                      'Marketplace flora modern',
                    ),

                    buildMenuTile(
                      Icons.privacy_tip,
                      'Privacy Policy',
                      'Your privacy matters',
                    ),

                    const SizedBox(height: 30),

                    // LOGOUT BUTTON
                    SizedBox(
                      width: double.infinity,

                      height: 58,

                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await authService.logout();

                          if (!mounted) {
                            return;
                          }

                          Navigator.pushAndRemoveUntil(
                            // ignore: use_build_context_synchronously
                            context,

                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),

                            (route) => false,
                          );
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,

                          elevation: 0,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),

                        icon: const Icon(Icons.logout, color: Colors.white),

                        label: const Text(
                          'Logout',

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
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // SECTION TITLE
  // =========================
  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),

      child: Align(
        alignment: Alignment.centerLeft,

        child: Text(
          title,

          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // =========================
  // MENU TILE
  // =========================
  Widget buildMenuTile(
    IconData icon,
    String title,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),

            blurRadius: 10,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),

        leading: Container(
          padding: const EdgeInsets.all(10),

          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.12),

            borderRadius: BorderRadius.circular(14),
          ),

          child: Icon(icon, color: Colors.green),
        ),

        title: Text(
          title,

          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),

        subtitle: Text(subtitle),

        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),

        onTap: onTap ?? () {},
      ),
    );
  }

  // =========================
  // SWITCH TILE
  // =========================
  Widget buildSwitchTile(
    IconData icon,
    String title,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

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
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.12),

              borderRadius: BorderRadius.circular(14),
            ),

            child: Icon(icon, color: Colors.green),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              title,

              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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

