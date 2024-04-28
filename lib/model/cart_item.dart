import 'package:anartiststore/model/product.dart';

class CartItem {
  const CartItem({
    required this.id,
    required this.product,
    required this.quantity,
  });

  final String id;
  final Product product;
  final int quantity;
}
