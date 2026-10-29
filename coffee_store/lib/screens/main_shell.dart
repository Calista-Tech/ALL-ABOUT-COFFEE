
import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../models/coffee.dart';
import '../widgets/bottom_nav.dart';
import 'cart_screen.dart' as cart;
import 'guest_screen.dart';
import 'home_screen.dart';
import 'saved_brews_screen.dart' as saved;

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _tab = 0;

  final List<CartItem> _cart = [];

  void _add(Coffee coffee, String options, int quantity) {
    final existing = _cart.where(
      (item) => item.coffee == coffee && item.options == options,
    ).toList();

    if (existing.isNotEmpty) {
      existing.first.qty += quantity;
    } else {
      _cart.add(
        CartItem(
          coffee: coffee,
          options: options,
          qty: quantity,
        ),
      );
    }

    setState(() {});
  }

  void _navigateToCart() {
    setState(() => _tab = 2);
  }

  void _navigateToHome() {
    setState(() => _tab = 0);
  }

  void _onOrderDone() {
    setState(() {
      _cart.clear();
      _tab = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        onAddToCart: _add,
        onNavigateToCart: _navigateToCart,
      ),

      saved.SavedBrewsScreen(
        onAddToCart: _add,
        cartItems: _cart,
        onOrderDone: _onOrderDone,
      ),

      cart.CartScreen(
        items: _cart,
        onChanged: () => setState(() {}),
        onOrderDone: _onOrderDone,
      ),

      GuestScreen(
        onAddToCart: _add,
        onOpenCart: _navigateToCart,
        onNavigateToHome: _navigateToHome,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.bg,
      extendBody: true,
      body: IndexedStack(
        index: _tab,
        children: pages,
      ),
      bottomNavigationBar: BottomNav(
        index: _tab,
        onTap: (index) => setState(() => _tab = index),
      ),
    );
  }
}
