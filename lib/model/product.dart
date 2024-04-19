import 'package:anartiststore/enums/group.dart';

class Product {
  const Product({
    required this.category,
    required this.id,
    required this.isFeatured,
    required this.name,
    required this.price,
  });

  final Group category;
  final int id;
  final bool isFeatured;
  final String name;
  final int price;

  String get assetName => 'assets/images/opengraph-image.png';

  String get assetPackage => 'assets/images';

  @override
  String toString() => '$name (id=$id)';
}
