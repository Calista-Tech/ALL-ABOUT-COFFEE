import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/coffee.dart';
import '../widgets/app_image.dart';

class BrewDetailsScreen extends StatefulWidget {
  final Coffee coffee;
  final void Function(Coffee, String, int) onAddToCart;
  final VoidCallback onNavigateToCart;
  const BrewDetailsScreen({
    super.key,
    required this.coffee,
    required this.onAddToCart,
    required this.onNavigateToCart,
  });

  @override
  State<BrewDetailsScreen> createState() => _BrewDetailsScreenState();
}

class _BrewDetailsScreenState extends State<BrewDetailsScreen> {
  int _size = 0;
  int _sugar = 2;
  int _qty = 2;

  static const _sizes = ['S', 'M', 'L'];
  static const _oz = ['8 oz', '12 oz', '16 oz'];
  static const _sizeName = ['Small (8 oz)', 'Medium (12 oz)', 'Large (16 oz)'];
  static const _sugars = ['0%', '25%', '50%', '75%', '100%'];

  String get _options =>
      '${_sizeName[_size].split(' ').first} • Hot • ${_sugars[_sugar]} Sugar';

  @override
  Widget build(BuildContext context) {
    final c = widget.coffee;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  children: [
                    Row(
                      children: [
                        _circleBtn(Icons.keyboard_return,
                            () => Navigator.pop(context)),
                        const Expanded(
                          child: Column(
                            children: [
                              Text('BREW DETAILS',
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Color(0xFF7A4A38))),
                              Text('ALL ABOUT COFFEE',
                                  style: TextStyle(
                                      fontSize: 22, fontWeight: FontWeight.w900)),
                            ],
                          ),
                        ),
                        _circleBtn(
                            c.favorite ? Icons.favorite : Icons.favorite_border,
                            () {
                          setState(() => c.favorite = !c.favorite);
                        }),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: AppColors.tan,
                          borderRadius: BorderRadius.circular(50)),
                      child: AppImage(c.image,
                          height: 260, width: double.infinity, radius: 24),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c.name,
                                  style: const TextStyle(
                                      fontSize: 28, fontWeight: FontWeight.w800)),
                              Text(c.shortDesc.toUpperCase(),
                                  style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Price', style: TextStyle(fontSize: 18)),
                            Text('₱ ${c.price.toInt()}',
                                style: const TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 16),
                              Text(' ${c.rating}  (${c.reviews} reviews)',
                                  style: const TextStyle(fontSize: 11)),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 3),
                          decoration: BoxDecoration(
                              color: const Color(0xFFBFFF7A),
                              borderRadius: BorderRadius.circular(12)),
                          child: const Text('•  In Stock',
                              style: TextStyle(
                                  color: Color(0xFF16A34A), fontSize: 13)),
                        ),
                      ],
                    ),
                    const Divider(
                        color: Color(0xFF8B4A3B), thickness: 2, height: 28),
                    const Text('PRODUCT INFO',
                        style: TextStyle(
                            color: Color(0xFF8B4A3B),
                            fontWeight: FontWeight.w600,
                            fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(c.info,
                        style: const TextStyle(fontSize: 20, height: 1.35)),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _label('CUP SIZE'),
                        Text(_sizeName[_size],
                            style: const TextStyle(
                                color: AppColors.rust, fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: List.generate(3, (i) {
                        final sel = _size == i;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _size = i),
                            child: Container(
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.tan,
                                borderRadius: BorderRadius.circular(26),
                                border: sel
                                    ? Border.all(width: 2.5)
                                    : Border.all(
                                        color: Colors.transparent, width: 2.5),
                              ),
                              child: Column(
                                children: [
                                  const Icon(Icons.local_cafe,
                                      color: AppColors.brown, size: 30),
                                  Text('${_sizes[i]}  ${_oz[i]}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _label('SUGAR LEVEL'),
                        Text('${_sugars[_sugar]} Regular',
                            style: const TextStyle(
                                color: AppColors.rust, fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(5, (i) {
                        final sel = _sugar == i;
                        return GestureDetector(
                          onTap: () => setState(() => _sugar = i),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: sel
                                  ? const Color(0xFFDD7A74)
                                  : AppColors.tan,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(_sugars[i],
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _label('QUANTITY'),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                              color: AppColors.tan,
                              borderRadius: BorderRadius.circular(30)),
                          child: Row(
                            children: [
                              _qtyBtn(Icons.remove, () {
                                if (_qty > 1) setState(() => _qty--);
                              }),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 22),
                                child: Text('$_qty',
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700)),
                              ),
                              _qtyBtn(Icons.add, () => setState(() => _qty++)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            widget.onAddToCart(c, _options, _qty);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Added to bag')));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                                color: const Color(0xFF2E9E4F),
                                borderRadius: BorderRadius.circular(20)),
                            child: const Row(
                              children: [
                                Icon(Icons.shopping_cart_outlined,
                                    size: 18, color: Colors.white),
                                SizedBox(width: 6),
                                Text('ADD TO CART',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            widget.onAddToCart(c, _options, _qty);
                            Navigator.pop(context);
                            widget.onNavigateToCart();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                                color: const Color(0xFFFF2D2D),
                                borderRadius: BorderRadius.circular(20)),
                            child: const Row(
                              children: [
                                Icon(Icons.shopping_cart,
                                    color: Colors.white, size: 18),
                                SizedBox(width: 6),
                                Text('BUY NOW',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String t) => Text(t,
      style: const TextStyle(
          color: Color(0xFF8B4A3B), fontWeight: FontWeight.w700, fontSize: 16));

  Widget _circleBtn(IconData i, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
              color: Color(0xFF574848), shape: BoxShape.circle),
          child: Icon(i, color: Colors.white, size: 28),
        ),
      );

  Widget _qtyBtn(IconData i, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
              color: AppColors.orange, shape: BoxShape.circle),
          child: Icon(i, color: Colors.white, size: 16),
        ),
      );
}
