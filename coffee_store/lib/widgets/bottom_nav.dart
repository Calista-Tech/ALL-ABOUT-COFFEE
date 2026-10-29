import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class BottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  const BottomNav({super.key, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const items = [
      [Icons.home_filled, 'HOME'],
      [Icons.favorite_border, 'FAVORITES'],
      [Icons.add_shopping_cart, 'CART'],
      [Icons.account_circle_outlined, 'PROFILE'],
    ];
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.brown,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final selected = i == index;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onTap(i),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFF4E4343) : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(items[i][0] as IconData,
                      size: 30,
                      color: selected ? const Color(0xFFE5C7C0) : AppColors.text),
                ),
                Text(items[i][1] as String,
                    style: const TextStyle(fontSize: 13, color: Colors.black)),
              ],
            ),
          );
        }),
      ),
    );
  }
}
