import 'package:anartiststore/enums/group.dart';

class Product {
  const Product({
    required this.group,
    required this.id,
    this.isFeatured = false,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  final Group group;
  final String id;
  final bool isFeatured;
  final String name;
  final String description;
  final int price;
  final String imageUrl;

  String get assetName => 'assets/images/opengraph-image.png';

  String get assetPackage => 'assets/images';

  @override
  String toString() => '$name (id=$id)';
}
