abstract interface class CartRepository {
  Future<Map<String, int>> getCart();

  Future<void> saveCart(Map<String, int> cart);

  Future<void> clearCart();
}
