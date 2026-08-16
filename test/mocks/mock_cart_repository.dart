import 'package:anartiststore/model/cart_repository.dart';

class MockCartRepository implements CartRepository {
  Map<String, int> savedCart = <String, int>{};
  bool clearCalled = false;

  @override
  Future<Map<String, int>> getCart() async => savedCart;

  @override
  Future<void> saveCart(Map<String, int> cart) async {
    savedCart = Map<String, int>.from(cart);
  }

  @override
  Future<void> clearCart() async {
    clearCalled = true;
    savedCart.clear();
  }
}
