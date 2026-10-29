import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../data/notification_data.dart';
import '../models/app_notification.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  void _markAllRead() {
    for (final n in notifications) {
      n.read = true;
    }
    refreshUnread();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                          color: Color(0xFF574848), shape: BoxShape.circle),
                      child: const Icon(Icons.keyboard_return,
                          color: Colors.white, size: 28),
                    ),
                  ),
                  const Expanded(
                    child: Column(
                      children: [
                        Text('NOTIFICATIONS',
                            style: TextStyle(
                                fontSize: 22, color: Color(0xFF7A4A38))),
                        Text('ALL ABOUT COFFEE',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 52),
                ],
              ),
            ),
            if (notifications.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${unreadCount.value} UNREAD',
                        style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF8B4A3B))),
                    GestureDetector(
                      onTap: _markAllRead,
                      child: const Text('Mark all as read',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFF0485F))),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: notifications.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.notifications_off_outlined,
                              size: 70, color: AppColors.brown),
                          SizedBox(height: 12),
                          Text('No notifications yet',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                  : ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                        itemCount: notifications.length,
                        itemBuilder: (_, i) => _tile(notifications[i]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(AppNotification n) {
    return Dismissible(
      key: ObjectKey(n),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.only(right: 24),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
            color: const Color(0xFFF0485F),
            borderRadius: BorderRadius.circular(22)),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 30),
      ),
      onDismissed: (_) {
        notifications.remove(n);
        refreshUnread();
        setState(() {});
      },
      child: GestureDetector(
        onTap: () {
          n.read = true;
          refreshUnread();
          setState(() {});
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: n.read ? const Color(0xFFEBD5C8) : AppColors.savedCard,
            borderRadius: BorderRadius.circular(22),
            border: n.read
                ? null
                : Border.all(color: AppColors.rust.withOpacity(0.6), width: 1.5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration:
                    BoxDecoration(color: n.color, shape: BoxShape.circle),
                child: Icon(n.icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(n.title,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: n.read
                                      ? FontWeight.w600
                                      : FontWeight.w800)),
                        ),
                        if (!n.read)
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                                color: AppColors.rust, shape: BoxShape.circle),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(n.body,
                        style: const TextStyle(
                            fontSize: 13, color: Color(0xFF6B5A55))),
                    const SizedBox(height: 6),
                    Text(n.time,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF8B4A3B))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
