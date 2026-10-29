import '../models/coffee.dart';

final caramelMacchiato = Coffee(
  name: 'Caramel Macchiato',
  shortDesc: 'with espresso & VANILLA SYRUP.',
  tag: 'BESTSELLER',
  price: 225,
  rating: 4.9,
  reviews: 100,
  image: 'assets/images/caramel_macchiato.jpg',
  info: 'Many people enjoy this coffee drink because it offers a perfect contrast between bitter coffee and sweet confectionery flavors.',
  favorite: false,
);

final flatWhite = Coffee(
  name: 'Flat White',
  shortDesc: 'espresso & STEAMED MILK WITH MICROFOAM.',
  tag: 'CLASSIC',
  price: 300,
  rating: 4.3,
  reviews: 89,
  image: 'assets/images/flat_white.jpg',
  info: 'Espresso topped with silky steamed milk and a thin layer of microfoam.',
  favorite: false,
);

final caffeMocha = Coffee(
  name: 'Mocha',
  shortDesc: 'espresso, steamed milk, and chocolate.',
  tag: 'SWEET',
  price: 245,
  rating: 5.0,
  reviews: 110,
  image: 'assets/images/caffe_mocha.jpg',
  info: 'Rich espresso blended with steamed milk and chocolate.',
  favorite: false,
);

final americano = Coffee(
  name: 'Americano',
  shortDesc: 'espresso & hot water.',
  tag: 'CLASSIC',
  price: 200,
  rating: 3.9,
  reviews: 80,
  image: 'assets/images/americano.jpg',
  info: 'A classic espresso diluted with hot water for a smooth, bold cup.',
  favorite: false,
);

final conPanna = Coffee(
  name: 'Con Panna',
  shortDesc: 'espresso topped with whipped cream.',
  tag: 'CLASSIC',
  price: 230,
  rating: 4.8,
  reviews: 65,
  image: 'assets/images/con_panna.jpg',
  info: 'A shot of espresso topped with a dollop of rich whipped cream.',
  favorite: false,
);

final pumpkinCreamColdBrew = Coffee(
  name: 'Pumpkin Cream Cold Brew',
  shortDesc: 'cold brew with pumpkin cream cold foam.',
  tag: 'COLD BREW',
  price: 260,
  rating: 4.9,
  reviews: 95,
  image: 'assets/images/pumpkin_cream_cold_brew.jpg',
  info: 'Classic cold brew sweetened with vanilla syrup and topped with a pumpkin cream cold foam and a dash of pumpkin spice.',
  favorite: false,
  savedTemp: 'Iced',
);

final chocolateCreamColdBrew = Coffee(
  name: 'Chocolate Cream Cold Brew',
  shortDesc: 'cold brew with chocolate malt cold foam.',
  tag: 'COLD BREW',
  price: 250,
  rating: 4.7,
  reviews: 82,
  image: 'assets/images/chocolate_cream_cold_brew.jpg',
  info: 'Smooth cold brew sweetened with vanilla syrup, topped with a silky chocolate cream cold foam.',
  favorite: false,
  savedTemp: 'Iced',
);

final cinnamonCaramelColdBrew = Coffee(
  name: 'Cinnamon Caramel Cold Brew',
  shortDesc: 'cold brew with cinnamon caramel cold foam.',
  tag: 'COLD BREW',
  price: 270,
  rating: 4.8,
  reviews: 74,
  image: 'assets/images/cinnamon_caramel_cold_brew.jpg',
  info: 'Cold brew infused with caramel flavor and topped with cinnamon caramel cold foam and a cinnamon dolce topping.',
  favorite: false,
  savedTemp: 'Iced',
);

final coconutMilkColdBrew = Coffee(
  name: 'Coconut Milk Cold Brew',
  shortDesc: 'cold brew with coconut milk & vanilla.',
  tag: 'COLD BREW',
  price: 240,
  rating: 4.6,
  reviews: 58,
  image: 'assets/images/coconut_milk_cold_brew.jpg',
  info: 'Signature cold brew with a splash of coconut milk and a hint of vanilla flavor for a tropical, smooth taste.',
  favorite: false,
  savedTemp: 'Iced',
);

final irishCreamColdBrew = Coffee(
  name: 'Irish Cream Cold Brew',
  shortDesc: 'cold brew with irish cream syrup & foam.',
  tag: 'COLD BREW',
  price: 265,
  rating: 4.9,
  reviews: 104,
  image: 'assets/images/irish_cream_cold_brew.jpg',
  info: 'Smooth cold brew sweetened with Irish cream syrup, topped with vanilla sweet cream cold foam and a line of cocoa powder.',
  favorite: false,
  savedTemp: 'Iced',
);

final espressoCoffees = [caramelMacchiato, flatWhite, caffeMocha, americano, conPanna];
final coldBrewCoffees = [pumpkinCreamColdBrew, chocolateCreamColdBrew, cinnamonCaramelColdBrew, coconutMilkColdBrew, irishCreamColdBrew];

final homeCoffees = [...espressoCoffees, ...coldBrewCoffees];
