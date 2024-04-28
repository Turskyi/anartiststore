import 'package:anartiststore/model/cart_item.dart';

class Cart {
  const Cart({
    required this.tax,
    required this.shippingCost,
    required this.subtotalCost,
    required this.totalCost,
    required this.items,
  });

  final double tax;
  final double shippingCost;
  final double subtotalCost;
  final double totalCost;
  final List<CartItem> items;
}
