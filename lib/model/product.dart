import 'package:anartiststore/enums/group.dart';

class Product {
  const Product({
    required this.group,
    required this.id,
    this.isFeatured = false,
    required this.name,
    required this.description,
    required this.priceInCents,
    required this.imageUrl,
  });

  final Group group;
  final String id;
  final bool isFeatured;
  final String name;
  final String description;
  final int priceInCents;
  final String imageUrl;

  double get price => priceInCents / 100;
}

Group groupAll = Group.all;
