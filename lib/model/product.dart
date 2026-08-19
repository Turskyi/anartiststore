import 'package:anartiststore/enums/group.dart';
import 'package:anartiststore/enums/product_availability.dart';

class Product {
  const Product({
    required this.group,
    required this.id,
    required this.name,
    required this.description,
    required this.priceInCents,
    required this.imageUrl,
    this.isFeatured = false,
    this.availability = ProductAvailability.available,
  });

  final Group group;
  final String id;
  final bool isFeatured;
  final String name;
  final String description;
  final int priceInCents;
  final String imageUrl;
  final ProductAvailability availability;

  double get price => priceInCents / 100;
}

Group groupAll = Group.all;
