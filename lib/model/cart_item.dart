import 'package:anartiststore/model/product.dart';

class CartItem {
  const CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.convertedPrice,
  });

  final String id;
  final Product product;
  final int quantity;
  final double convertedPrice;
}
