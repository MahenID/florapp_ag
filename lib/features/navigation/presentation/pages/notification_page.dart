import 'package:flutter/material.dart';

enum NotificationCategory { all, transaction, promo, shop }

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String time;
  final NotificationCategory category;
  final IconData icon;
  final Color iconColor;
  final String actionLabel;
  final VoidCallback? onAction;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.category,
    required this.icon,
    required this.iconColor,
    required this.actionLabel,
    this.onAction,
    this.isRead = false,
  });
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  NotificationCategory selectedCategory = NotificationCategory.all;

  late List<NotificationItem> notifications;

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  void _initNotifications() {
    notifications = [
      NotificationItem(
        id: '1',
        title: 'Pesanan Tanaman Sedang Dikirim! 🚚',
        message:
            'Paket Monstera Deliciosa & Pupuk Organik Anda sedang dalam perjalanan oleh kurir.',
        time: '10 menit yang lalu',
        category: NotificationCategory.transaction,
        icon: Icons.local_shipping_outlined,
        iconColor: Colors.blue,
        actionLabel: 'Lacak Pengiriman',
        isRead: false,
      ),
      NotificationItem(
        id: '2',
        title: 'Promo Spesial Weekend Flora! 🌿✨',
        message:
            'Diskon hingga 40% untuk semua bibit Anggrek Bulan & Tanaman Hias Indoor. Berlaku s/d Minggu!',
        time: '1 jam yang lalu',
        category: NotificationCategory.promo,
        icon: Icons.discount_outlined,
        iconColor: Colors.orange,
        actionLabel: 'Klaim Voucher',
        isRead: false,
      ),
      NotificationItem(
        id: '3',
        title: 'Produk Tanaman Kamu Terjual! 🎉',
        message:
            'Selamat! Seseorang baru saja membeli Aglonema Suksom Jaipong dari tokomu seharga Rp 185.000.',
        time: '3 jam yang lalu',
        category: NotificationCategory.shop,
        icon: Icons.storefront_outlined,
        iconColor: Colors.green,
        actionLabel: 'Proses Pesanan',
        isRead: false,
      ),
      NotificationItem(
        id: '4',
        title: 'Pembayaran Berhasil Diverifikasi ✅',
        message:
            'Pembayaran pesanan #FLORA-88921 sebesar Rp 145.000 telah diterima. Penjual sedang menyiapkan pesananmu.',
        time: 'Kemarin',
        category: NotificationCategory.transaction,
        icon: Icons.check_circle_outline,
        iconColor: Colors.teal,
        actionLabel: 'Lihat Invoice',
        isRead: true,
      ),
      NotificationItem(
        id: '5',
        title: 'Tips Rawat Monstera Saat Musim Hujan 🌧️',
        message:
            'Simak panduan menyiram dan menjaga kelembaban akar tanaman hias agar tidak busuk akar.',
        time: '2 hari yang lalu',
        category: NotificationCategory.promo,
        icon: Icons.eco_outlined,
        iconColor: Colors.green.shade700,
        actionLabel: 'Baca Tips',
        isRead: true,
      ),
      NotificationItem(
        id: '6',
        title: 'Ulasan Baru Bintang 5 ⭐⭐⭐⭐⭐',
        message:
            'Pembeli "Rina S." memberikan ulasan positif untuk tanaman Calathea Roseopicta Anda.',
        time: '3 hari yang lalu',
        category: NotificationCategory.shop,
        icon: Icons.star_outline,
        iconColor: Colors.amber.shade700,
        actionLabel: 'Lihat Ulasan',
        isRead: true,
      ),
    ];
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  List<NotificationItem> get filteredNotifications {
    if (selectedCategory == NotificationCategory.all) {
      return notifications;
    }
    return notifications
        .where((n) => n.category == selectedCategory)
        .toList();
  }

  void _markAllAsRead() {
    setState(() {
      for (var n in notifications) {
        n.isRead = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Semua notifikasi telah ditandai dibaca'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _toggleRead(NotificationItem item) {
    setState(() {
      item.isRead = !item.isRead;
    });
  }

  void _deleteNotification(NotificationItem item) {
    final index = notifications.indexOf(item);
    setState(() {
      notifications.remove(item);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notifikasi dihapus'),
        action: SnackBarAction(
          label: 'Batal',
          textColor: Colors.amber,
          onPressed: () {
            setState(() {
              notifications.insert(index, item);
            });
          },
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentList = filteredNotifications;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
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
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.notifications_active,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Notifikasi',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Pembaruan tanaman & transaksi',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (unreadCount > 0)
                        TextButton.icon(
                          onPressed: _markAllAsRead,
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white.withValues(alpha: 0.18),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          icon: const Icon(Icons.done_all, size: 16),
                          label: const Text(
                            'Tandai Dibaca',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // CATEGORY FILTER BAR
            SizedBox(
              height: 42,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildFilterChip(
                    label: 'Semua',
                    count: notifications.length,
                    category: NotificationCategory.all,
                  ),
                  _buildFilterChip(
                    label: 'Transaksi',
                    category: NotificationCategory.transaction,
                    icon: Icons.receipt_long,
                  ),
                  _buildFilterChip(
                    label: 'Promo & Tips',
                    category: NotificationCategory.promo,
                    icon: Icons.local_offer_outlined,
                  ),
                  _buildFilterChip(
                    label: 'Toko Saya',
                    category: NotificationCategory.shop,
                    icon: Icons.storefront,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // NOTIFICATION LIST
            Expanded(
              child: RefreshIndicator(
                color: Colors.green,
                onRefresh: () async {
                  await Future.delayed(const Duration(milliseconds: 500));
                  setState(() {
                    _initNotifications();
                  });
                },
                child: currentList.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount: currentList.length,
                        itemBuilder: (context, index) {
                          final item = currentList[index];
                          return _buildNotificationCard(item);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required NotificationCategory category,
    IconData? icon,
    int? count,
  }) {
    final isSelected = selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        showCheckmark: false,
        avatar: icon != null
            ? Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : Colors.green.shade700,
              )
            : null,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            if (count != null) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.25)
                      : Colors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.green.shade800,
                  ),
                ),
              ),
            ],
          ],
        ),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade800,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          fontSize: 13,
        ),
        backgroundColor: Colors.white,
        selectedColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? Colors.green : Colors.grey.shade300,
          ),
        ),
        onSelected: (_) {
          setState(() {
            selectedCategory = category;
          });
        },
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem item) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      onDismissed: (_) => _deleteNotification(item),
      child: GestureDetector(
        onTap: () => _toggleRead(item),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: item.isRead
                ? Colors.white
                : const Color(0xFFF1F8F4), // subtle green background for unread
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: item.isRead
                  ? Colors.grey.shade200
                  : Colors.green.withValues(alpha: 0.4),
              width: item.isRead ? 1 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ICON BADGE
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: item.iconColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, color: item.iconColor, size: 24),
              ),

              const SizedBox(width: 14),

              // DETAILS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight:
                                  item.isRead ? FontWeight.w600 : FontWeight.bold,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                        ),
                        if (!item.isRead) ...[
                          const SizedBox(width: 6),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text(
                      item.message,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 13,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.time,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Membuka: ${item.actionLabel}'),
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  item.actionLabel,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(width: 3),
                                const Icon(
                                  Icons.chevron_right,
                                  size: 15,
                                  color: Colors.green,
                                ),
                              ],
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
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none,
                color: Colors.green,
                size: 54,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Belum Ada Notifikasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Semua update pesanan, promo tanaman, dan transaksi toko akan muncul di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}
