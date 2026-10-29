
import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../data/coffee_data.dart';
import '../models/coffee.dart';
import '../widgets/app_header.dart';
import '../widgets/app_image.dart';
import 'cart_screen.dart';

class SavedBrewsScreen extends StatefulWidget {
  final void Function(Coffee, String, int) onAddToCart;
  final List<CartItem> cartItems;
  final VoidCallback onOrderDone;

  const SavedBrewsScreen({
    super.key,
    required this.onAddToCart,
    required this.cartItems,
    required this.onOrderDone,
  });

  @override
  State<SavedBrewsScreen> createState() => _SavedBrewsScreenState();
}

class _SavedBrewsScreenState extends State<SavedBrewsScreen> {
  String _favFilter = 'All';

  List<Coffee> get _savedCoffees {
    final all = <Coffee>[
      ...homeCoffees,
      ...espressoCoffees,
      ...coldBrewCoffees,
    ];

    final unique = <Coffee>[];
    final seen = <String>{};

    for (final coffee in all) {
      if (seen.add(coffee.name)) {
        unique.add(coffee);
      }
    }

    if (_favFilter == 'All') {
      return unique.where((coffee) => coffee.favorite).toList();
    }

    return unique
        .where(
          (coffee) =>
              coffee.favorite &&
              coffee.tag.toLowerCase() == _favFilter.toLowerCase(),
        )
        .toList();
  }

  void _addCoffeeToCart(Coffee coffee) {
    widget.onAddToCart(coffee, coffee.recipeString, 1);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${coffee.name} added to your cart!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _buyNow(Coffee coffee) {
    widget.onAddToCart(coffee, coffee.recipeString, 1);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CartScreen(
          items: widget.cartItems,
          onChanged: () {
            if (mounted) {
              setState(() {});
            }
          },
          onOrderDone: widget.onOrderDone,
        ),
      ),
    );
  }

  void _showEditRecipeModal(Coffee coffee) {
    String selectedSugar = coffee.savedSugar;
    String selectedSize = coffee.savedSize;
    String selectedTemp = coffee.savedTemp;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Widget optionSelector({
              required String title,
              required List<String> options,
              required String selected,
              required ValueChanged<String> onSelected,
            }) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.darkBrown,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: options.map((option) {
                      final isSelected = option == selected;

                      return ChoiceChip(
                        label: Text(option),
                        selected: isSelected,
                        selectedColor: AppColors.tan,
                        backgroundColor: AppColors.savedCard,
                        labelStyle: TextStyle(
                          color: AppColors.darkBrown,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        onSelected: (_) => onSelected(option),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  22,
                  20,
                  20 + MediaQuery.of(context).viewInsets.bottom,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Container(
                          width: 42,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.tan,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Customize Your Brew',
                        style: TextStyle(
                          color: AppColors.darkBrown,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        coffee.name,
                        style: TextStyle(
                          color: AppColors.brown,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 24),
                      optionSelector(
                        title: 'Sugar Level',
                        options: const [
                          'No Sugar',
                          '25% Sugar',
                          '50% Sugar',
                          '75% Sugar',
                          '100% Sugar',
                        ],
                        selected: selectedSugar,
                        onSelected: (value) {
                          setModalState(() => selectedSugar = value);
                        },
                      ),
                      optionSelector(
                        title: 'Cup Size',
                        options: const [
                          'Small Cup',
                          'Standard Cup',
                          'Large Cup',
                        ],
                        selected: selectedSize,
                        onSelected: (value) {
                          setModalState(() => selectedSize = value);
                        },
                      ),
                      optionSelector(
                        title: 'Temperature',
                        options: const ['Hot', 'Iced'],
                        selected: selectedTemp,
                        onSelected: (value) {
                          setModalState(() => selectedTemp = value);
                        },
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              coffee.savedSugar = selectedSugar;
                              coffee.savedSize = selectedSize;
                              coffee.savedTemp = selectedTemp;
                            });

                            Navigator.pop(sheetContext);

                            ScaffoldMessenger.of(this.context).showSnackBar(
                              const SnackBar(
                                content: Text('Your brew recipe was updated!'),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkBrown,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'SAVE RECIPE',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _filterChip(String label) {
    final selected = _favFilter == label;

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      selectedColor: AppColors.darkBrown,
      backgroundColor: AppColors.savedCard,
      labelStyle: TextStyle(
        color: selected ? Colors.white : AppColors.darkBrown,
        fontWeight: FontWeight.w600,
      ),
      onSelected: (_) {
        setState(() => _favFilter = label);
      },
    );
  }

  Widget _savedCard(Coffee coffee) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.savedCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AppImage(
                  coffee.image,
                  width: 100,
                  height: 115,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            coffee.name,
                            style: TextStyle(
                              color: AppColors.darkBrown,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Remove from favorites',
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            coffee.favorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: AppColors.heart,
                          ),
                          onPressed: () {
                            setState(() {
                              coffee.favorite = !coffee.favorite;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      coffee.shortDesc,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.brown,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: AppColors.orange,
                          size: 15,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${coffee.rating} (${coffee.reviews})',
                          style: TextStyle(
                            color: AppColors.brown,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${coffee.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: AppColors.darkBrown,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.tune,
                  color: AppColors.brown,
                  size: 17,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    coffee.recipeString,
                    style: TextStyle(
                      color: AppColors.brown,
                      fontSize: 12,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _showEditRecipeModal(coffee),
                  child: Text(
                    'EDIT',
                    style: TextStyle(
                      color: AppColors.darkBrown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Price remains on the left; both action buttons are on the right.
          Row(
            children: [
              Expanded(
                child: Text(
                  'Ready to enjoy?',
                  style: TextStyle(
                    color: AppColors.brown,
                    fontSize: 12,
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () => _buyNow(coffee),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.darkBrown,
                  side: BorderSide(color: AppColors.darkBrown),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  minimumSize: const Size(0, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'BUY',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _addCoffeeToCart(coffee),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.coral,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  minimumSize: const Size(0, 40),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'ADD CART',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final coffees = _savedCoffees;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
                children: [
                  Text(
                    'Saved Brews',
                    style: TextStyle(
                      color: AppColors.darkBrown,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Your favorite coffees, saved just the way you like them.',
                    style: TextStyle(
                      color: AppColors.brown,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _filterChip('All'),
                      _filterChip('Espresso'),
                      _filterChip('Cold Brew'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (coffees.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Column(
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 64,
                            color: AppColors.tan,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No saved brews yet',
                            style: TextStyle(
                              color: AppColors.darkBrown,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the heart on a coffee to save it here.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.brown,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...coffees.map(_savedCard),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
