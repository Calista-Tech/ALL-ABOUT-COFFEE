class Coffee {
  final String name;
  final String shortDesc;
  final String tag;
  final double price;
  final double rating;
  final int reviews;
  final String image;
  final String info;
  bool favorite;
  
  String savedSize;
  String savedSugar;
  String savedTemp;

  Coffee({
    required this.name,
    required this.shortDesc,
    required this.tag,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.image,
    this.info = '',
    this.favorite = false,
    this.savedSize = 'Standard Cup',
    this.savedSugar = '50% Sugar',
    this.savedTemp = 'Hot',
  });

  String get recipeString => '$savedSugar • $savedTemp • $savedSize';
}

class CartItem {
  final Coffee coffee;
  final String options;
  int qty;
  CartItem({required this.coffee, required this.options, this.qty = 1});

  double get total => coffee.price * qty;
}
