import 'package:flutter/material.dart';
import '../models/app_notification.dart';

final List<AppNotification> notifications = [
  AppNotification(
    title: 'Order is ready for pickup! ☕',
    body: 'Your Caramel Macchiato is ready at Downtown Bar. Enjoy your bean!',
    time: '2 mins ago',
    icon: Icons.storefront,
    color: const Color(0xFF2E9E4F),
  ),
  AppNotification(
    title: 'Order confirmed',
    body: 'We received your order and our baristas are now brewing it.',
    time: '10 mins ago',
    icon: Icons.receipt_long,
    color: const Color(0xFF8B4A2B),
  ),
  AppNotification(
    title: '🔥 Promo: Cold Brew Week',
    body: 'Get ₱20 off on all Iced & Cold Brew drinks until Sunday.',
    time: '1 hr ago',
    icon: Icons.local_offer,
    color: const Color(0xFFFF6B2C),
  ),
  AppNotification(
    title: 'New drink alert',
    body: 'Pumpkin Cream Cold Brew is now available. Give it a try!',
    time: '3 hrs ago',
    icon: Icons.new_releases,
    color: const Color(0xFFE8857A),
  ),
  AppNotification(
    title: 'Good morning! ☀️',
    body: 'Ready for your daily brew? Reorder your saved drinks in one tap.',
    time: 'Today, 7:00 AM',
    icon: Icons.favorite,
    color: const Color(0xFFA62B2B),
    read: true,
  ),
  AppNotification(
    title: 'Guest perk applied',
    body: 'Free Oat Milk Upgrade is auto-applied on your next order.',
    time: 'Yesterday',
    icon: Icons.auto_awesome,
    color: const Color(0xFFC4561A),
    read: true,
  ),
];

int _countUnread() => notifications.where((n) => !n.read).length;

final ValueNotifier<int> unreadCount = ValueNotifier<int>(_countUnread());

void refreshUnread() => unreadCount.value = _countUnread();
