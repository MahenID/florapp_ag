import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/services/cart_service.dart';
import '../../../../shared/services/order_service.dart';
import '../../../../shared/utils/currency_formatter.dart';
import '../../../../shared/widgets/app_network_image.dart';
import '../../../checkout/presentation/checkout_page.dart';
import '../../../orders/domain/order_model.dart';
import '../../../reviews/presentation/add_review_dialog.dart';

class TransactionPage extends StatefulWidget {
  final int initialTabIndex;

  const TransactionPage({super.key, this.initialTabIndex = 0});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CartService _cartService = CartService();
  final OrderService _orderService = OrderService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int getQuantity(Map<String, dynamic> data) {
    final quantity = data['quantity'];
    if (quantity is int) return quantity;
    if (quantity is num) return quantity.toInt();
    return 1;
  }

  double getPrice(Map<String, dynamic> data) {
    final price = data['price'];
    if (price is int) return price.toDouble();
    if (price is double) return price;
    if (price is num) return price.toDouble();
    return 0;
  }

  double calculateTotal(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    double total = 0;
    for (final doc in docs) {
      final data = doc.data();
      final price = getPrice(data);
      final quantity = getQuantity(data);
      total += price * quantity;
    }
    return total;
  }

  int calculateTotalItem(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    int total = 0;
    for (final doc in docs) {
      total += getQuantity(doc.data());
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('User belum login')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _cartService.getCartItems(),
          builder: (context, cartSnapshot) {
            final cartDocs = cartSnapshot.data?.docs ?? [];
            final cartCount = cartDocs.length;

            return StreamBuilder<List<OrderModel>>(
              stream: _orderService.getBuyerOrders(),
              builder: (context, ordersSnapshot) {
                final allOrders = ordersSnapshot.data ?? [];
                final diprosesCount =
                    allOrders.where((o) => o.status == 'diproses').length;
                final dikirimCount =
                    allOrders.where((o) => o.status == 'dikirim').length;
                final selesaiCount =
                    allOrders.where((o) => o.status == 'selesai').length;

                return Column(
                  children: [
                    // ================= HEADER =================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Transaksi & Pesanan',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Pantau keranjang belanja & status pesanan tanaman',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.receipt_long,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ================= MODERN TAB BAR WITH BADGES =================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey.shade600,
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          tabs: [
                            _buildTabItem('Keranjang', cartCount),
                            _buildTabItem('Diproses', diprosesCount),
                            _buildTabItem('Dikirim', dikirimCount),
                            _buildTabItem('Selesai', selesaiCount),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ================= TAB CONTENT =================
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildCartTab(context, cartDocs),
                          _buildOrdersListTab(
                            context,
                            orders: allOrders
                                .where((o) => o.status == 'diproses')
                                .toList(),
                            emptyIcon: Icons.inventory_2_outlined,
                            emptyTitle: 'Belum Ada Pesanan Diproses',
                            emptySubtitle:
                                'Pesanan yang sedang dikemas & disiapkan oleh penjual akan tampil di sini.',
                            statusColor: Colors.orange,
                          ),
                          _buildOrdersListTab(
                            context,
                            orders: allOrders
                                .where((o) => o.status == 'dikirim')
                                .toList(),
                            emptyIcon: Icons.local_shipping_outlined,
                            emptyTitle: 'Belum Ada Pesanan Dikirim',
                            emptySubtitle:
                                'Pesanan yang sedang dalam perjalanan oleh pihak ekspedisi akan tampil di sini.',
                            statusColor: Colors.blue,
                          ),
                          _buildOrdersListTab(
                            context,
                            orders: allOrders
                                .where((o) => o.status == 'selesai')
                                .toList(),
                            emptyIcon: Icons.check_circle_outline,
                            emptyTitle: 'Belum Ada Riwayat Selesai',
                            emptySubtitle:
                                'Riwayat pesanan tanaman yang telah Anda terima dengan sukses akan tampil di sini.',
                            statusColor: Colors.green,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Tab _buildTabItem(String title, int count) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title),
          if (count > 0) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ================= CART TAB =================
  Widget _buildCartTab(
    BuildContext context,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> cartItems,
  ) {
    final totalPrice = calculateTotal(cartItems);
    final totalItem = calculateTotalItem(cartItems);

    if (cartItems.isEmpty) {
      return _buildEmptyState(
        icon: Icons.shopping_cart_outlined,
        title: 'Keranjang Belanja Kosong',
        subtitle:
            'Jelajahi berbagai pilihan tanaman hias, bibit bunga, dan pupuk berkualitas untuk dimasukkan ke keranjang.',
        buttonText: 'Cari Tanaman Sekarang',
        color: Colors.green,
        onButtonPressed: () {
          // Switch to home or pop
        },
      );
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CART SUMMARY CARD
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.shopping_bag_outlined,
                              color: Colors.green, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Total $totalItem Tanaman Dipilih',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        formatRupiah(totalPrice),
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // CART ITEM LIST
                ...cartItems.map((doc) {
                  final data = doc.data();
                  final productId = (data['productId'] ?? doc.id).toString();
                  final name = (data['name'] ?? 'Tanaman Hias').toString();
                  final image = (data['image'] ?? '').toString();
                  final price = getPrice(data);
                  final quantity = getQuantity(data);

                  return _buildCartItemCard(
                    productId: productId,
                    name: name,
                    image: image,
                    price: price,
                    quantity: quantity,
                  );
                }),
              ],
            ),
          ),
        ),

        // ================= BOTTOM STICKY CHECKOUT BAR =================
        Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Pembayaran',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        formatRupiah(totalPrice),
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                ElevatedButton.icon(
                  onPressed: cartItems.isEmpty
                      ? null
                      : () {
                          final orderItems = cartItems.map((doc) {
                            final data = doc.data();
                            return OrderItem.fromMap({
                              'productId': data['productId'] ?? doc.id,
                              'name': data['name'] ?? '',
                              'image': data['image'] ?? '',
                              'price': getPrice(data),
                              'quantity': getQuantity(data),
                              'sellerId': data['sellerId'] ?? '',
                            });
                          }).toList();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CheckoutPage(items: orderItems),
                            ),
                          );
                        },
                  icon: const Icon(Icons.shopping_cart_checkout,
                      color: Colors.white, size: 18),
                  label: Text(
                    'Checkout ($totalItem)',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    disabledBackgroundColor: Colors.grey.shade300,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCartItemCard({
    required String productId,
    required String name,
    required String image,
    required double price,
    required int quantity,
  }) {
    final subtotal = price * quantity;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AppNetworkImage(
              imageUrl: image,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  formatRupiah(price),
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Subtotal: ${formatRupiah(subtotal)}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildStepperBtn(
                      icon: Icons.remove,
                      onTap: () {
                        _cartService.updateQuantity(
                          productId: productId,
                          quantity: quantity - 1,
                        );
                      },
                    ),
                    Container(
                      width: 36,
                      alignment: Alignment.center,
                      child: Text(
                        quantity.toString(),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildStepperBtn(
                      icon: Icons.add,
                      onTap: () {
                        _cartService.updateQuantity(
                          productId: productId,
                          quantity: quantity + 1,
                        );
                      },
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        _cartService.removeFromCart(productId: productId);
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                        size: 22,
                      ),
                      tooltip: 'Hapus Item',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepperBtn({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.green, size: 16),
      ),
    );
  }

  // ================= ORDERS LIST TAB =================
  Widget _buildOrdersListTab(
    BuildContext context, {
    required List<OrderModel> orders,
    required IconData emptyIcon,
    required String emptyTitle,
    required String emptySubtitle,
    required Color statusColor,
  }) {
    if (orders.isEmpty) {
      return _buildEmptyState(
        icon: emptyIcon,
        title: emptyTitle,
        subtitle: emptySubtitle,
        color: statusColor,
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildBuyerOrderCard(context, order);
      },
    );
  }

  Widget _buildBuyerOrderCard(BuildContext context, OrderModel order) {
    Color statusBadgeColor = Colors.orange;
    String statusText = 'Diproses Penjual';
    IconData statusIcon = Icons.inventory_2_outlined;

    if (order.status == 'dikirim') {
      statusBadgeColor = Colors.blue;
      statusText = 'Dalam Pengiriman';
      statusIcon = Icons.local_shipping_outlined;
    } else if (order.status == 'selesai') {
      statusBadgeColor = Colors.green;
      statusText = 'Selesai';
      statusIcon = Icons.check_circle_outline;
    } else if (order.status == 'dibatalkan') {
      statusBadgeColor = Colors.red;
      statusText = 'Dibatalkan';
      statusIcon = Icons.cancel_outlined;
    }

    final firstItem = order.items.isNotEmpty ? order.items.first : null;
    final totalItemsCount =
        order.items.fold<int>(0, (acc, i) => acc + i.quantity);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.orderNumber,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year} • ${order.courier}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusBadgeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(statusIcon, color: statusBadgeColor, size: 13),
                      const SizedBox(width: 4),
                      Text(
                        statusText,
                        style: TextStyle(
                          color: statusBadgeColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Divider(height: 20),

            // ITEM PREVIEW
            if (firstItem != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: AppNetworkImage(
                      imageUrl: firstItem.image,
                      width: 62,
                      height: 62,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          firstItem.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${firstItem.quantity} x ${formatRupiah(firstItem.price)}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        if (order.items.length > 1) ...[
                          const SizedBox(height: 4),
                          Text(
                            '+ ${order.items.length - 1} tanaman lainnya',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),

            // TRACKING NUMBER BANNER
            if (order.status == 'dikirim' &&
                order.trackingNumber != null &&
                order.trackingNumber!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_shipping,
                        color: Colors.blue, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'No. Resi: ${order.trackingNumber}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(text: order.trackingNumber!),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Nomor resi berhasil disalin!'),
                            duration: Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          'Salin',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const Divider(height: 20),

            // FOOTER TOTAL & ACTIONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Belanja ($totalItemsCount item)',
                      style:
                          TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatRupiah(order.totalPrice),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () => _showOrderDetailModal(context, order),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green,
                        side: const BorderSide(color: Colors.green),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Rincian',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (order.status == 'dikirim') ...[
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _confirmReceiveOrder(order),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Terima Barang',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    if (order.status == 'selesai' && order.items.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () =>
                            _showReviewPlantSelection(context, order),
                        icon: const Icon(Icons.star,
                            size: 14, color: Colors.white),
                        label: const Text(
                          'Ulas',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade700,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showReviewPlantSelection(BuildContext context, OrderModel order) {
    if (order.items.length == 1) {
      showDialog(
        context: context,
        builder: (_) => AddReviewDialog(order: order, item: order.items.first),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Tanaman untuk Diulas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            ...order.items.map(
              (item) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AppNetworkImage(
                    imageUrl: item.image,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(item.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text(formatRupiah(item.price),
                    style:
                        const TextStyle(color: Colors.green, fontSize: 12)),
                trailing: const Icon(Icons.rate_review_outlined,
                    color: Colors.amber),
                onTap: () {
                  Navigator.pop(ctx);
                  showDialog(
                    context: context,
                    builder: (_) => AddReviewDialog(order: order, item: item),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmReceiveOrder(OrderModel order) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Konfirmasi Terima Pesanan'),
        content: Text(
          'Apakah Anda sudah menerima seluruh tanaman pada pesanan ${order.orderNumber} dengan kondisi baik?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Belum'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Ya, Sudah Terima',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _orderService.confirmOrderReceived(orderId: order.id);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Pesanan telah selesai. Terima kasih telah berbelanja di FlorApp!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyelesaikan pesanan: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showOrderDetailModal(BuildContext context, OrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        expand: false,
        builder: (_, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Detail Pesanan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    order.orderNumber,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),

              // TIMELINE STATUS
              _buildTimelineStatus(order.status),

              const Divider(height: 24),

              // ALAMAT PENGIRIMAN
              const Text(
                'Alamat Pengiriman',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              Text(
                '${order.shippingAddress['fullName']} (${order.shippingAddress['phone']})',
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              Text(
                '${order.shippingAddress['address']}, ${order.shippingAddress['city']}, ${order.shippingAddress['province']} ${order.shippingAddress['postalCode']}',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
              ),

              const Divider(height: 24),

              // DAFTAR ITEM
              const Text(
                'Daftar Tanaman',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 10),
              ...order.items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: AppNetworkImage(
                          imageUrl: item.image,
                          width: 46,
                          height: 46,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Text(
                              '${item.quantity} x ${formatRupiah(item.price)}',
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        formatRupiah(item.price * item.quantity),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),

              const Divider(height: 24),

              // INFO PEMBAYARAN & PENGIRIMAN
              _buildDetailRow('Kurir Pengiriman', order.courier),
              const SizedBox(height: 6),
              if (order.trackingNumber != null) ...[
                _buildDetailRow('No. Resi', order.trackingNumber!),
                const SizedBox(height: 6),
              ],
              _buildDetailRow('Metode Pembayaran', order.paymentMethod),
              const SizedBox(height: 6),
              _buildDetailRow('Total Harga Tanaman', formatRupiah(order.itemsTotal)),
              const SizedBox(height: 6),
              _buildDetailRow('Ongkos Kirim', formatRupiah(order.shippingFee)),
              const SizedBox(height: 6),
              _buildDetailRow('Biaya Layanan', formatRupiah(order.serviceFee)),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Tagihan',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    formatRupiah(order.totalPrice),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineStatus(String status) {
    int currentStep = 1;
    if (status == 'dikirim') currentStep = 2;
    if (status == 'selesai') currentStep = 3;

    return Row(
      children: [
        _buildTimelineStep(1, 'Diproses', currentStep >= 1),
        _buildTimelineLine(currentStep >= 2),
        _buildTimelineStep(2, 'Dikirim', currentStep >= 2),
        _buildTimelineLine(currentStep >= 3),
        _buildTimelineStep(3, 'Selesai', currentStep >= 3),
      ],
    );
  }

  Widget _buildTimelineStep(int step, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isActive ? Colors.green : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? Colors.green : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 3,
        color: isActive ? Colors.green : Colors.grey.shade300,
        margin: const EdgeInsets.only(bottom: 16),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
      ],
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    String? buttonText,
    VoidCallback? onButtonPressed,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 48),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 22, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
