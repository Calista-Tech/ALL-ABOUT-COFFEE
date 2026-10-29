class Coffee {
  final int? id;
  final String name;
  final String shortDesc;
  final String tag;
  final double price;
  final double rating;
  final int reviews;
  final String image; // asset path OR https:// url
  final String info;
  final String category; // 'espresso' | 'cold_brew' | '' (local seed data)
  bool favorite;

  String savedSize;
  String savedSugar;
  String savedTemp;

  Coffee({
    this.id,
    required this.name,
    required this.shortDesc,
    required this.tag,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.image,
    this.info = '',
    this.category = '',
    this.favorite = false,
    this.savedSize = 'Standard Cup',
    this.savedSugar = '50% Sugar',
    this.savedTemp = 'Hot',
  });

  /// Builds a Coffee from a row of the Supabase `products` table.
  factory Coffee.fromMap(Map<String, dynamic> m) {
    final category = (m['category'] as String?) ?? 'espresso';
    return Coffee(
      id: (m['id'] as num?)?.toInt(),
      name: (m['name'] as String?) ?? '',
      shortDesc: (m['short_desc'] as String?) ?? '',
      tag: (m['tag'] as String?) ?? 'NEW',
      price: (m['price'] as num?)?.toDouble() ?? 0,
      rating: (m['rating'] as num?)?.toDouble() ?? 5.0,
      reviews: (m['reviews'] as num?)?.toInt() ?? 0,
      image: (m['image_url'] as String?) ?? '',
      info: (m['info'] as String?) ?? '',
      category: category,
      savedTemp: category == 'cold_brew' ? 'Iced' : 'Hot',
    );
  }

  bool get isColdBrew =>
      category.isNotEmpty ? category == 'cold_brew' : tag == 'COLD BREW';

  String get recipeString => '$savedSugar • $savedTemp • $savedSize';
}

class CartItem {
  final Coffee coffee;
  final String options;
  int qty;
  CartItem({required this.coffee, required this.options, this.qty = 1});

  double get total => coffee.price * qty;
}