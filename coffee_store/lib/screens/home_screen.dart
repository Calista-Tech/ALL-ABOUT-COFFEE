import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../data/coffee_data.dart';
import '../models/coffee.dart';
import '../widgets/app_header.dart';
import '../widgets/coffee_card.dart';
import 'brew_details_screen.dart';

class HomeScreen extends StatefulWidget {
  final void Function(Coffee, String, int) onAddToCart;
  final VoidCallback onNavigateToCart;
  const HomeScreen({super.key, required this.onAddToCart, required this.onNavigateToCart});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _cat = 0;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final cats = [
      ['☕', 'All Coffee'],
      ['🔥', 'Espresso & Hot'],
      ['🧊', 'Iced & Cold Brew'],
    ];

    List<Coffee> sourceList = homeCoffees;
    if (_cat == 1) {
      sourceList = espressoCoffees;
    } else if (_cat == 2) {
      sourceList = coldBrewCoffees;
    }

    List<Coffee> filteredCoffees = sourceList.where((c) {
      final matchesSearch = c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.shortDesc.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesSearch;
    }).toList();

    return Column(
      children: [
        const AppHeader(),
        Expanded(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 110),
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Text('MORNING ROAST RITUAL •',
                      style: TextStyle(color: AppColors.rust, fontSize: 16)),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('Ready for your daily brew? ☕',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500)),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFAF3),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(width: 2.5),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, size: 32),
                      const SizedBox(width: 14),
                      Expanded(
                        child: TextField(
                          onChanged: (val) {
                            setState(() {
                              _searchQuery = val;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Search your favorite coffee, brew, or blend...',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Text('BROWSE BY ROAST', style: TextStyle(fontSize: 14)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Text('${cats.length} Categories', style: const TextStyle(fontSize: 14)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(cats.length, (i) {
                      return GestureDetector(
                        onTap: () => setState(() => _cat = i),
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 14),
                          decoration: BoxDecoration(
                            color: _cat == i
                                ? const Color(0xFFD2B5A0)
                                : const Color(0xFFDFC8B6),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text('${cats[i][0]}  ${cats[i][1]}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16)),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 10),
                filteredCoffees.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text('No coffee found matching your search.',
                              style: TextStyle(fontSize: 16, color: Colors.grey)),
                        ),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredCoffees.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.61,
                        ),
                        itemBuilder: (context, index) {
                          final c = filteredCoffees[index];
                          return CoffeeCard(
                            coffee: c,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => BrewDetailsScreen(
                                      coffee: c, 
                                      onAddToCart: widget.onAddToCart,
                                      onNavigateToCart: widget.onNavigateToCart)),
                            ).then((_) => setState(() {})),
                            onAdd: () {
                              widget.onAddToCart(c, c.recipeString, 1);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${c.name} added to bag')));
                            },
                            onFavorite: () => setState(() => c.favorite = !c.favorite),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
