
import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../models/coffee.dart';
import '../widgets/app_header.dart';
import '../widgets/app_image.dart';
import '../services/checkout_flow.dart';
import 'order_success_screen.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> items;
  final VoidCallback onChanged;
  final VoidCallback onOrderDone;

  const CartScreen({
    super.key,
    required this.items,
    required this.onChanged,
    required this.onOrderDone,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _pickup = true;

  double get _subtotal =>
      widget.items.fold(0.0, (sum, item) => sum + item.total);

  int get _cups =>
      widget.items.fold(0, (sum, item) => sum + item.qty);

  double get _deliveryFee => _pickup ? 0 : 50;

  double get _ecoLid => widget.items.isEmpty ? 0 : 15;

  double get _total =>
      widget.items.isEmpty ? 0 : _subtotal + _ecoLid + _deliveryFee;

  String get _estimatedTime => _pickup ? '10-15 MINS' : '25-35 MINS';

  String _money(double value) {
    final parts = value.toStringAsFixed(2).split('.');
    final whole = parts[0].replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
    return '$whole.${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;

    return DefaultTextStyle.merge(
      style: const TextStyle(
        decoration: TextDecoration.none,
        decorationColor: Colors.transparent,
      ),
      child: Column(
        children: [
          const AppHeader(),
          Expanded(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context)
                  .copyWith(scrollbars: false),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'My Brew Bag',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6A59E),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${items.length} ${items.length == 1 ? 'ITEM' : 'ITEMS'}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            items.clear();
                          });
                          widget.onChanged();
                        },
                        child: const Text(
                          'clear',
                          style: TextStyle(
                            color: Color(0xFFF0485F),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Pickup and delivery selection
                  Container(
                    padding: const EdgeInsets.all(18),
                    color: const Color(0xFFEBD5C8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _orderTypeButton(
                                label: 'Pickup',
                                icon: Icons.storefront,
                                selected: _pickup,
                                onTap: () =>
                                    setState(() => _pickup = true),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _orderTypeButton(
                                label: 'Delivery',
                                icon: Icons.delivery_dining,
                                selected: !_pickup,
                                onTap: () =>
                                    setState(() => _pickup = false),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const SizedBox(width: 4),
                            Icon(
                              _pickup ? Icons.store : Icons.location_on,
                              size: 34,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _pickup
                                    ? 'Downtown Bar • Malabon'
                                    : 'Caloocan City (Delivery)',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF4E4343),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6A59E),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                _estimatedTime,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Cart items
                  for (final item in items) _cartRow(item),

                  const SizedBox(height: 6),

                  // Price breakdown
                  Container(
                    color: const Color(0xFFEFD3B2),
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                    child: Column(
                      children: [
                        _priceRow('Subtotal ($_cups cups)', _subtotal),
                        const SizedBox(height: 10),
                        _priceRow('Eco Sip Lid', _ecoLid),
                        if (!_pickup) ...[
                          const SizedBox(height: 10),
                          _priceRow('Delivery Fee', _deliveryFee),
                        ],
                      ],
                    ),
                  ),

                  Container(
                    color: const Color(0xFFEBD5C8),
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                    child: _priceRow(
                      'Total Amount',
                      _total,
                      bold: true,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Checkout button
                  Container(
                    color: const Color(0xFFEBD5C8),
                    padding: const EdgeInsets.all(16),
                    child: GestureDetector(
                      onTap: () {
                        if (items.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Your brew bag is empty.'),
                            ),
                          );
                          return;
                        }

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CheckoutFormScreen(
                              total: _total,
                              pickup: _pickup,
                              itemCount: _cups,
                              items: List<CartItem>.from(items),
                              onOrderDone: widget.onOrderDone,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.orange,
                          borderRadius: BorderRadius.circular(34),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                'Checkout • ₱ ${_money(_total)}',
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFFFFE3D2),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_right_alt,
                              size: 36,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderTypeButton({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected ? Colors.white : Colors.black,
              size: 24,
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(
    String label,
    double value, {
    bool bold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '₱ ${_money(value)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _cartRow(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      color: const Color(0xFFF2D9C6),
      child: Row(
        children: [
          ClipOval(
            child: AppImage(
              item.coffee.image,
              width: 64,
              height: 64,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.coffee.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.options,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B5A55),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₱ ${item.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE2D0B9),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _qtyBtn(Icons.remove, () {
                  if (item.qty > 1) {
                    setState(() => item.qty--);
                    widget.onChanged();
                  }
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '${item.qty}',
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                _qtyBtn(Icons.add, () {
                  setState(() => item.qty++);
                  widget.onChanged();
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          color: AppColors.orange,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 14,
        ),
      ),
    );
  }
}

// ============================================================
// CHECKOUT FORM SCREEN
// ============================================================

class CheckoutFormScreen extends StatefulWidget {
  final double total;
  final bool pickup;
  final int itemCount;
  final List<CartItem> items;
  final VoidCallback onOrderDone;

  const CheckoutFormScreen({
    super.key,
    required this.total,
    required this.pickup,
    required this.itemCount,
    required this.items,
    required this.onOrderDone,
  });

  @override
  State<CheckoutFormScreen> createState() =>
      _CheckoutFormScreenState();
}

class _CheckoutFormScreenState extends State<CheckoutFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  late final String _timestamp;

  bool _paying = false;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    final date =
        '${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)}';

    final time =
        '${_twoDigits(now.hour)}:${_twoDigits(now.minute)}';

    _timestamp = '$date  $time';
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  String _money(double value) {
    final parts = value.toStringAsFixed(2).split('.');
    final whole = parts[0].replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
    return '$whole.${parts[1]}';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (_paying) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _paying = true);

    try {
      final names = widget.items
          .map((item) => '${item.coffee.name} x${item.qty}')
          .join(', ');

      final paid = await startCheckout(
        context,
        productName: names,
        amount: widget.total,
        customerName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        orderType: widget.pickup ? 'Pickup' : 'Delivery',
        items: widget.items.map((item) {
          return <String, dynamic>{
            'name': item.coffee.name,
            'qty': item.qty,
            'options': item.options,
            'price': item.total,
          };
        }).toList(),
      );

      if (!mounted) return;

      if (paid) {
        setState(() => _paying = false);

        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => OrderSuccessScreen(
              onContinue: widget.onOrderDone,
            ),
          ),
        );
      } else {
        setState(() => _paying = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Checkout was cancelled or not completed.',
            ),
          ),
        );
      }
    } catch (error, stackTrace) {
      debugPrint('CHECKOUT ERROR: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() => _paying = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Checkout failed. Please try again.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: const TextStyle(
        decoration: TextDecoration.none,
        decorationColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          backgroundColor: AppColors.header,
          foregroundColor: AppColors.darkBrown,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Back to Cart',
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Checkout',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBD5C8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.pickup
                            ? 'Pickup order'
                            : 'Delivery order',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${widget.itemCount} cups  •  ₱ ${_money(widget.total)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Customer details',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                _field(
                  label: 'Full name',
                  hint: 'Enter your name',
                  icon: Icons.person_outline,
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name.';
                    }
                    return null;
                  },
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 14),
                _field(
                  label: 'Address',
                  hint: 'House no., street, barangay, city',
                  icon: Icons.location_on_outlined,
                  controller: _addressController,
                  validator: (value) {
                    if (!widget.pickup &&
                        (value == null || value.trim().isEmpty)) {
                      return 'Please enter your delivery address.';
                    }
                    return null;
                  },
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 2,
                ),
                const SizedBox(height: 14),
                _field(
                  label: 'Phone number',
                  hint: '09XX XXX XXXX',
                  icon: Icons.phone_outlined,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    final digits =
                        (value ?? '').replaceAll(RegExp(r'\D'), '');
                    if (digits.length < 10 || digits.length > 13) {
                      return 'Please enter a valid phone number.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                InputDecorator(
                  decoration: _decoration(
                    'Order timestamp',
                    Icons.schedule,
                  ),
                  child: Text(
                    _timestamp,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Place order
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _paying ? null : _placeOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          AppColors.orange.withValues(alpha: 0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _paying
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Processing...',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            'Place order • ₱ ${_money(widget.total)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 12),

                // Back to cart
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: const Text('Back to Cart'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.darkBrown,
                    side: const BorderSide(
                      color: Color(0xFF4E342E),
                    ),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),

                const SizedBox(height: 8),

                // Return to first route (usually home)
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).popUntil(
                      (route) => route.isFirst,
                    );
                  },
                  icon: const Icon(Icons.home_outlined),
                  label: const Text('Go to Home'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.darkBrown,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        icon,
        color: AppColors.darkBrown,
      ),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.75),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFFD7BCAF),
        ),
      ),
    );
  }

  Widget _field({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization =
        TextCapitalization.none,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      maxLines: maxLines,
      validator: validator,
      decoration: _decoration(label, icon).copyWith(
        hintText: hint,
      ),
    );
  }
}
