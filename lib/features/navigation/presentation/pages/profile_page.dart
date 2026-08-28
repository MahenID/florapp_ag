import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../profile/presentation/settings_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser!.uid)
              .snapshots(),

          builder: (context, snapshot) {
            // LOADING
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            // USER DATA
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),

              padding: const EdgeInsets.only(bottom: 30),

              child: Column(
                children: [
                  // =========================
                  // HEADER
                  // =========================
                  Stack(
                    clipBehavior: Clip.none,

                    children: [
                      // BACKGROUND
                      Container(
                        height: 260,
                        width: double.infinity,

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
                      ),

                      // SETTINGS BUTTON
                      Positioned(
                        top: 12,
                        right: 16,

                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),

                            shape: BoxShape.circle,
                          ),

                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder: (_) => const SettingsPage(),
                                ),
                              );
                            },

                            icon: const Icon(
                              Icons.settings,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      // PROFILE CONTENT
                      Positioned(
                        bottom: -70,
                        left: 0,
                        right: 0,

                        child: Column(
                          children: [
                            // PROFILE IMAGE
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,

                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),

                                    blurRadius: 20,

                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),

                              child: CircleAvatar(
                                radius: 65,
                                backgroundColor: Colors.white,

                                child: CircleAvatar(
                                  radius: 60,

                                  backgroundImage:
                                      userData['photoUrl'] != null &&
                                          userData['photoUrl'].isNotEmpty
                                      ? NetworkImage(userData['photoUrl'])
                                      : null,

                                  child:
                                      userData['photoUrl'] == null ||
                                          userData['photoUrl'].isEmpty
                                      ? const Icon(
                                          Icons.person,
                                          size: 60,
                                          color: Colors.grey,
                                        )
                                      : null,
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // NAME
                            Text(
                              userData['name'] ?? 'No Name',

                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            // EMAIL
                            Text(
                              userData['email'] ?? '',

                              style: TextStyle(
                                color: Colors.grey.shade600,

                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 100),

                  // =========================
                  // CONTENT
                  // =========================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        // =========================
                        // MY ORDERS
                        // =========================
                        const Text(
                          'My Orders',

                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Container(
                          padding: const EdgeInsets.all(20),

                          decoration: BoxDecoration(
                            color: Colors.white,

                            borderRadius: BorderRadius.circular(24),

                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),

                                blurRadius: 12,

                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,

                            children: [
                              buildOrderItem(
                                Icons.pending_actions,
                                'Pending',
                                Colors.orange,
                              ),

                              buildOrderItem(
                                Icons.local_shipping,
                                'Shipped',
                                Colors.blue,
                              ),

                              buildOrderItem(
                                Icons.check_circle,
                                'Done',
                                Colors.green,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // =========================
                        // MARKETPLACE
                        // =========================
                        const Text(
                          'Marketplace',

                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        buildMenuTile(Icons.favorite, 'Wishlist'),

                        buildMenuTile(Icons.store, 'Seller Dashboard'),

                        buildMenuTile(Icons.shopping_bag, 'My Products'),

                        buildMenuTile(Icons.history, 'Order History'),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // =========================
  // ORDER ITEM
  // =========================
  Widget buildOrderItem(IconData icon, String title, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),

          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),

            shape: BoxShape.circle,
          ),

          child: Icon(icon, color: color, size: 28),
        ),

        const SizedBox(height: 12),

        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  // =========================
  // MENU TILE
  // =========================
  Widget buildMenuTile(IconData icon, String title, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),

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

            borderRadius: BorderRadius.circular(12),
          ),

          child: Icon(icon, color: Colors.green),
        ),

        title: Text(
          title,

          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),

        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),

        onTap: onTap ?? () {},
      ),
    );
  }
}
