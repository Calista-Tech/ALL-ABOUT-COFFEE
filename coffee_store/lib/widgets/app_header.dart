import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../data/notification_data.dart';
import '../screens/notifications_screen.dart';
import 'app_image.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, MediaQuery.of(context).padding.top + 6, 16, 8),
      decoration: const BoxDecoration(
        color: AppColors.header,
        border: Border(bottom: BorderSide(color: Colors.black54, width: 2)),
      ),
      child: Row(
        children: [
          const AppLogo(size: 62),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ENJOY YOUR BEAN!',
                    style: TextStyle(
                        color: Color(0xFFFF2D3A),
                        fontWeight: FontWeight.w800,
                        fontSize: 16)),
                Text('ALL ABOUT COFFEE',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 20)),
              ],
            ),
          ),
          ValueListenableBuilder<int>(
            valueListenable: unreadCount,
            builder: (context, count, _) => GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const NotificationsScreen()),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.notifications_none, size: 34),
                    if (count > 0)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          constraints: const BoxConstraints(
                              minWidth: 16, minHeight: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: const BoxDecoration(
                              color: AppColors.rust, shape: BoxShape.circle),
                          child: Center(
                            child: Text('$count',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
