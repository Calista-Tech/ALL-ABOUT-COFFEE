import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/coffee.dart';
import 'app_image.dart';

class CoffeeCard extends StatelessWidget {
  final Coffee coffee;
  final VoidCallback onTap;
  final VoidCallback onAdd;
  final VoidCallback onFavorite;

  const CoffeeCard({
    super.key,
    required this.coffee,
    required this.onTap,
    required this.onAdd,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.fromLTRB(10, 16, 10, 10),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppImage(coffee.image,
                    width: double.infinity, height: 110, radius: 14),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text('${coffee.rating} (${coffee.reviews})',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: 36,
                  child: Center(
                    child: Text(
                      coffee.name.toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                SizedBox(
                  height: 26,
                  child: Center(
                    child: Text(
                      coffee.shortDesc.toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6B5A55),
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                      color: AppColors.tan,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '₱${coffee.price.toInt()}',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w800),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: onAdd,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: const BoxDecoration(
                              color: AppColors.pinkBtn, shape: BoxShape.circle),
                          child: const Icon(Icons.add,
                              color: Colors.white, size: 18),
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: onFavorite,
                        child: Icon(
                          coffee.favorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: coffee.favorite
                              ? AppColors.heart
                              : AppColors.text,
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                decoration: BoxDecoration(
                    color: AppColors.brown,
                    borderRadius: BorderRadius.circular(12)),
                child: Text(coffee.tag,
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w900)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
