import 'dart:convert';

import 'package:anartiststore/model/cart_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesCartRepository implements CartRepository {
  static const String _kCartKey = 'shopping_cart_data';

  @override
  Future<Map<String, int>> getCart() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? cartJson = prefs.getString(_kCartKey);
    if (cartJson == null) {
      return <String, int>{};
    }

    try {
      final Object? decoded = json.decode(cartJson);
      if (decoded is Map<Object?, Object?>) {
        final Map<String, int> cart = <String, int>{};
        decoded.forEach((Object? key, Object? value) {
          if (key is String && value is int) {
            cart[key] = value;
          }
        });
        return cart;
      }
      return <String, int>{};
    } catch (e) {
      // In case of corruption or format change, return empty cart
      return <String, int>{};
    }
  }

  @override
  Future<void> saveCart(Map<String, int> cart) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String cartJson = json.encode(cart);
    await prefs.setString(_kCartKey, cartJson);
  }

  @override
  Future<void> clearCart() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kCartKey);
  }
}
