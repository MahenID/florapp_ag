import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../shared/services/order_service.dart';
import '../../../../shared/utils/currency_formatter.dart';
import '../../../../shared/widgets/app_network_image.dart';
import '../../../orders/domain/order_model.dart';
import '../../../shop/presentation/pages/sell_page.dart';
import '../../../shop/presentation/pages/my_products_page.dart';
import '../../../shop/presentation/pages/seller_orders_page.dart';
import '../../../shop/presentation/pages/shop_profile_page.dart';
import '../../../shop/presentation/pages/shop_tools_page.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final orderService = OrderService();

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('User belum login')),
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
            String storeName = 'Toko Florapp Saya';
            String storeDescription = 'Penjual tanaman hias Florapp';
            String storePhoto = '';
            String storeCity = 'Indonesia';
            bool storeIsOpen = true;

            if (userSnapshot.hasData && userSnapshot.data!.exists) {
              final data = userSnapshot.data!.data() as Map<String, dynamic>;
              storeName = data['storeName'] ?? data['name'] ?? 'Toko Florapp Saya';
              storeDescription =
                  data['storeDescription'] ?? 'Penjual tanaman hias Florapp';
              storePhoto = data['storePhoto'] ?? data['photoUrl'] ?? '';
              storeCity = data['storeCity'] ?? 'Indonesia';
              storeIsOpen = data['storeIsOpen'] ?? true;
            }

            return StreamBuilder<List<OrderModel>>(
              stream: orderService.getSellerOrders(),
              builder: (context, ordersSnapshot) {
                final orders = ordersSnapshot.data ?? [];
                final totalOrdersCount = orders.length;
                final pendingOrdersCount =
                    orders.where((o) => o.status == 'diproses').length;
                final shippedOrdersCount =
                    orders.where((o) => o.status == 'dikirim').length;
                final completedOrdersCount =
                    orders.where((o) => o.status == 'selesai').length;

                // Financial calculations
                double completedSalesBalance = 0;
                double totalSalesVolume = 0;
                double pendingEscrowBalance = 0;
                int totalPlantsSold = 0;

                for (final order in orders) {
                  totalSalesVolume += order.itemsTotal;
                  if (order.status == 'selesai') {
                    completedSalesBalance += order.itemsTotal;
                    totalPlantsSold +=
                        order.items.fold<int>(0, (acc, i) => acc + i.quantity);
                  } else if (order.status == 'diproses' ||
                      order.status == 'dikirim') {
                    pendingEscrowBalance += order.itemsTotal;
                  }
                }

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Column(
                    children: [
                      // ================= STORE HEADER =================
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
                            // TOP BAR ACTIONS
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
                                      Icon(Icons.verified,
                                          color: Colors.white, size: 14),
                                      SizedBox(width: 4),
                                      Text(
                                        'Seller Center',
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
                                                const ShopProfilePage(),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.storefront_outlined,
                                          color: Colors.white),
                                      tooltip: 'Profil Toko',
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const ShopToolsPage(),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.settings_outlined,
                                          color: Colors.white),
                                      tooltip: 'Pengaturan Toko',
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // STORE INFO
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
                                      imageUrl: storePhoto,
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
                                        storeName,
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
                                        storeDescription,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: storeIsOpen
                                                  ? Colors.greenAccent
                                                  : Colors.redAccent,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            storeIsOpen ? 'Toko Buka' : 'Tutup Sementara',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Text('•',
                                              style: TextStyle(
                                                  color: Colors.white60)),
                                          const SizedBox(width: 8),
                                          Icon(Icons.location_on,
                                              color: Colors.white70, size: 12),
                                          const SizedBox(width: 2),
                                          Expanded(
                                            child: Text(
                                              storeCity,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // ================= WALLET & REVENUE FLOATING BAR =================
                      Transform.translate(
                        offset: const Offset(0, -18),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.account_balance_wallet,
                                              color: Colors.green,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              'Saldo Siap Ditarik',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          formatRupiah(completedSalesBalance),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1E293B),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        _showWithdrawDialog(
                                          context,
                                          completedSalesBalance,
                                        );
                                      },
                                      icon: const Icon(Icons.arrow_upward,
                                          size: 14, color: Colors.white),
                                      label: const Text(
                                        'Tarik Dana',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildRevenueSubMetric(
                                      label: 'Total Penjualan',
                                      value: formatRupiah(totalSalesVolume),
                                      color: Colors.blue,
                                    ),
                                    _buildRevenueSubMetric(
                                      label: 'Dana Diproses (Escrow)',
                                      value: formatRupiah(pendingEscrowBalance),
                                      color: Colors.orange,
                                    ),
                                  ],
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
                            // ================= PENDING ORDER ALERT BANNER (IF ANY) =================
                            if (pendingOrdersCount > 0) ...[
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SellerOrdersPage(
                                        initialTabIndex: 0,
                                      ),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(18),
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color:
                                          Colors.orange.withValues(alpha: 0.35),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.orange
                                              .withValues(alpha: 0.15),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.notifications_active,
                                          color: Colors.orange,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '$pendingOrdersCount Pesanan Baru Perlu Diproses!',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                color: Colors.orange,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            const Text(
                                              'Ketuk untuk input nomor resi pengiriman',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.chevron_right,
                                          color: Colors.orange),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],

                            // ================= SELLER ORDER STATUS (4 TILES) =================
                            _buildSectionHeader(
                              title: 'Status Pesanan Masuk',
                              actionText: 'Lihat Semua (${orders.length})',
                              onActionTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SellerOrdersPage(
                                      initialTabIndex: 3,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 8),
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
                                  _buildSellerStatusItem(
                                    icon: Icons.inbox_outlined,
                                    label: 'Perlu Diproses',
                                    color: Colors.orange,
                                    badgeCount: pendingOrdersCount,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const SellerOrdersPage(
                                            initialTabIndex: 0,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  _buildSellerStatusItem(
                                    icon: Icons.local_shipping_outlined,
                                    label: 'Dikirim',
                                    color: Colors.blue,
                                    badgeCount: shippedOrdersCount,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const SellerOrdersPage(
                                            initialTabIndex: 1,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  _buildSellerStatusItem(
                                    icon: Icons.check_circle_outline,
                                    label: 'Selesai',
                                    color: Colors.green,
                                    badgeCount: completedOrdersCount,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const SellerOrdersPage(
                                            initialTabIndex: 2,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  _buildSellerStatusItem(
                                    icon: Icons.receipt_long_outlined,
                                    label: 'Semua Pesanan',
                                    color: Colors.purple,
                                    badgeCount: totalOrdersCount,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const SellerOrdersPage(
                                            initialTabIndex: 3,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // ================= PRODUCT & INVENTORY MANAGEMENT =================
                            const Text(
                              'Katalog Tanaman Toko',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildInventoryCard(context, currentUser.uid),

                            const SizedBox(height: 24),

                            // ================= SHOP PERFORMANCE METRICS =================
                            const Text(
                              'Performa Toko',
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
                                  _buildMetricTile(
                                    icon: Icons.star_rate_rounded,
                                    iconColor: Colors.amber.shade700,
                                    title: 'Rating Toko',
                                    value: '5.0',
                                  ),
                                  Container(
                                      width: 1,
                                      height: 36,
                                      color: Colors.grey.shade200),
                                  _buildMetricTile(
                                    icon: Icons.shopping_bag_outlined,
                                    iconColor: Colors.blue,
                                    title: 'Tanaman Terjual',
                                    value: '$totalPlantsSold Unit',
                                  ),
                                  Container(
                                      width: 1,
                                      height: 36,
                                      color: Colors.grey.shade200),
                                  _buildMetricTile(
                                    icon: Icons.bolt,
                                    iconColor: Colors.orange,
                                    title: 'Kecepatan Proses',
                                    value: '< 24 Jam',
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // ================= SHOP TOOLS & GROWTH =================
                            const Text(
                              'Fitur & Alat Penjual',
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
                                  _buildToolMenuTile(
                                    icon: Icons.storefront_outlined,
                                    iconColor: Colors.green,
                                    title: 'Profil & Jadwal Toko',
                                    subtitle:
                                        'Ubah nama, deskripsi, alamat, dan status buka toko',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const ShopProfilePage(),
                                        ),
                                      );
                                    },
                                  ),
                                  const Divider(height: 1, indent: 60),
                                  _buildToolMenuTile(
                                    icon: Icons.local_offer_outlined,
                                    iconColor: Colors.orange,
                                    title: 'Voucher Diskon Toko',
                                    subtitle:
                                        'Buat promo dan diskon khusus tokomu',
                                    onTap: () => _showShopPromoDialog(context),
                                  ),
                                  const Divider(height: 1, indent: 60),
                                  _buildToolMenuTile(
                                    icon: Icons.local_shipping_outlined,
                                    iconColor: Colors.blue,
                                    title: 'Pengaturan Kurir & Pengiriman',
                                    subtitle: 'Kelola kurir JNE, J&T, SiCepat, & Instant',
                                    onTap: () => _showCourierInfoDialog(context),
                                  ),
                                  const Divider(height: 1, indent: 60),
                                  _buildToolMenuTile(
                                    icon: Icons.menu_book_outlined,
                                    iconColor: Colors.teal,
                                    title: 'Panduan Packing Tanaman Hidup',
                                    subtitle:
                                        'Tips aman mengemas akar & daun tanaman agar tidak layu',
                                    onTap: () =>
                                        _showPlantCareGuideDialog(context),
                                  ),
                                ],
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

  Widget _buildRevenueSubMetric({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
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
        InkWell(
          onTap: onActionTap,
          child: Text(
            actionText,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSellerStatusItem({
    required IconData icon,
    required String label,
    required Color color,
    int badgeCount = 0,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
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
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryCard(BuildContext context, String userId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where('userId', isEqualTo: userId)
          .snapshots(),
      builder: (context, snapshot) {
        final productCount = snapshot.data?.docs.length ?? 0;

        return Container(
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
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.inventory_2_outlined,
                        color: Colors.green, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$productCount Tanaman Aktif',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Kelola stok, harga, dan foto tanaman yang kamu jual',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
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
                            builder: (_) => const MyProductsPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.list_alt,
                          size: 16, color: Colors.green),
                      label: const Text(
                        'Kelola Produk',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.green),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SellPage(),
                          ),
                        );
                        if (result == true && context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MyProductsPage(),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.add,
                          size: 16, color: Colors.white),
                      label: const Text(
                        'Tambah Tanaman',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 16),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _buildToolMenuTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
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
      trailing: const Icon(
        Icons.chevron_right,
        size: 20,
        color: Colors.grey,
      ),
    );
  }

  void _showWithdrawDialog(BuildContext context, double balance) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Tarik Saldo Penjualan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Saldo Penjualan Siap Ditarik:',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              formatRupiah(balance),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              balance > 0
                  ? 'Permintaan penarikan dana akan ditransfer ke rekening bank terdaftar Anda dalam 1x24 jam kerja.'
                  : 'Belum ada saldo penjualan selesai yang dapat ditarik.',
              style: TextStyle(
                  fontSize: 13, color: Colors.grey.shade700, height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
          if (balance > 0)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Pengajuan penarikan dana berhasil dikirim!'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Ajukan Penarikan',
                  style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
    );
  }

  void _showShopPromoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Voucher Diskon Toko'),
        content: const Text(
          'Fitur pembuatan voucher promo toko memungkinkan Anda menarik lebih banyak pembeli dengan memberikan potongan harga khusus untuk tanaman di tokomu.',
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

  void _showCourierInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Kurir & Pengiriman Toko'),
        content: const Text(
          'FlorApp mendukung layanan pengiriman tanaman melalui JNE Reguler, J&T Express, SiCepat, dan Kurir Instan Lokal. Pastikan menggunakan layanan tercepat untuk menjaga kesegaran tanaman hidup.',
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

  void _showPlantCareGuideDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Panduan Packing Tanaman'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('1. Kurangi kadar air media tanam sebelum dikirim.'),
            SizedBox(height: 6),
            Text('2. Bungkus perakaran dengan plastik & tisu lembap.'),
            SizedBox(height: 6),
            Text('3. Gunakan kardus tebal / rangka kayu untuk tanaman bertangkai tinggi.'),
            SizedBox(height: 6),
            Text('4. Beri lubang sirkulasi udara kecil pada kardus kemasan.'),
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
}
