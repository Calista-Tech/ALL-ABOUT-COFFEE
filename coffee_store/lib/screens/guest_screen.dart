import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../data/coffee_data.dart';
import '../models/coffee.dart';
import '../widgets/app_header.dart';
import '../widgets/app_image.dart';
import 'brew_details_screen.dart';

class GuestScreen extends StatefulWidget {
  final void Function(Coffee, String, int) onAddToCart;
  final VoidCallback onOpenCart;
  final VoidCallback onNavigateToHome;
  const GuestScreen({
    super.key,
    required this.onAddToCart,
    required this.onOpenCart,
    required this.onNavigateToHome,
  });

  @override
  State<GuestScreen> createState() => _GuestScreenState();
}

class _GuestScreenState extends State<GuestScreen> {
  void _openDetails(Coffee c) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BrewDetailsScreen(
          coffee: c,
          onAddToCart: widget.onAddToCart,
          onNavigateToCart: widget.onOpenCart,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppHeader(),
        Expanded(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 110),
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  color: const Color(0xFFE8CDBB),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          AppLogo(size: 44),
                          SizedBox(width: 6),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Hello, Guest Shopper! ☕',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800)),
                                Text('Direct checkout • No account needed',
                                    style: TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                            color: const Color(0xFFD9B494),
                            borderRadius: BorderRadius.circular(30)),
                        child: const Row(
                          children: [
                            Text('✨ ', style: TextStyle(fontSize: 20)),
                            Expanded(
                              child: Text(
                                  'Guest Perks: Free Oat Milk Upgrade Auto-Applied',
                                  style: TextStyle(
                                      color: AppColors.rust,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 16, 20),
                  color: const Color(0xFF654D3C),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('FAST-TRACK LANE',
                                style: TextStyle(
                                    color: Color(0xFFE6C8B0),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                            Text('Order Now As Guest',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700)),
                            Text('Downtown Bar • Ready in 10 mins',
                                style: TextStyle(
                                    color: Color(0xFFC9AE97), fontSize: 12)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: widget.onNavigateToHome,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                              color: const Color(0xFFB02421),
                              borderRadius: BorderRadius.circular(40)),
                          child: const Row(
                            children: [
                              Text('Order',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700)),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_right_alt,
                                  color: Colors.white, size: 22),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('FAST-TRACK LANE',
                          style: TextStyle(
                              color: Color(0xFFB02421),
                              fontSize: 18,
                              fontWeight: FontWeight.w800)),
                      SizedBox(height: 2),
                      Text('Tap to grab & GO',
                          style: TextStyle(
                              fontSize: 13, color: Color(0xFF6B5A55))),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _miniCard(caramelMacchiato)),
                    const SizedBox(width: 14),
                    Expanded(child: _miniCard(caffeMocha)),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                        child: _infoTile(Icons.inventory_2_outlined,
                            'Track Order', 'Receipt / Phone')),
                    const SizedBox(width: 14),
                    Expanded(
                        child: _infoTile(Icons.add_shopping_cart,
                            'Express Cart', '3 items ready')),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                        child: _infoTile(Icons.qr_code_scanner, '1-Tap Pay',
                            'GCash • Maya • COD')),
                    const SizedBox(width: 14),
                    Expanded(
                        child: _infoTile(
                            Icons.storefront, '1-Tap Pay', 'Open until 10 PM')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _miniCard(Coffee c) => GestureDetector(
        onTap: () => _openDetails(c),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.fromLTRB(10, 14, 10, 10),
              decoration: BoxDecoration(
                  color: const Color(0xFFE6D2CB),
                  borderRadius: BorderRadius.circular(14)),
              child: Column(
                children: [
                  AppImage(c.image, height: 130, width: double.infinity, radius: 10),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        Text(' ${c.rating}  (${c.reviews} reviews)',
                            style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 38,
                    child: Center(
                      child: Text(c.name.toUpperCase(),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 14,
                              height: 1.1,
                              fontWeight: FontWeight.w800)),
                    ),
                  ),
                  const SizedBox(height: 2),
                  SizedBox(
                    height: 32,
                    child: Text(c.shortDesc.toUpperCase(),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF6B5A55))),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        color: AppColors.tan,
                        borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      children: [
                        Text('₱ ${c.price.toInt()}',
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w800)),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            widget.onAddToCart(c, c.recipeString, 1);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('${c.name} added to bag')));
                          },
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: const BoxDecoration(
                                color: AppColors.pinkBtn,
                                shape: BoxShape.circle),
                            child: const Icon(Icons.add,
                                color: Colors.white, size: 18),
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => setState(() => c.favorite = !c.favorite),
                          child: Icon(
                            c.favorite ? Icons.favorite : Icons.favorite_border,
                            color: AppColors.heart,
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
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
                  decoration: BoxDecoration(
                      color: AppColors.brown,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(c.tag,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w900)),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _infoTile(IconData i, String t, String s) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: const Color(0xFFE6D2CB),
            borderRadius: BorderRadius.circular(22)),
        child: Row(
          children: [
            Icon(i, size: 26),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14)),
                  Text(s,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF6B5A55))),
                ],
              ),
            ),
          ],
        ),
      );
}