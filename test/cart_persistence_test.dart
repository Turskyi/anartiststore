import 'dart:convert';

import 'package:anartiststore/data/repositories/shared_preferences_cart_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SharedPreferencesCartRepository', () {
    late SharedPreferencesCartRepository repository;

    setUp(() {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      repository = SharedPreferencesCartRepository();
    });

    test('getCart returns empty map when nothing is saved', () async {
      final Map<String, int> cart = await repository.getCart();
      expect(cart, isEmpty);
    });

    test('saveCart and getCart persist and retrieve data', () async {
      final Map<String, int> initialCart = <String, int>{
        'product_1': 2,
        'product_2': 1,
      };

      await repository.saveCart(initialCart);
      final Map<String, int> savedCart = await repository.getCart();

      expect(savedCart, initialCart);
    });

    test('clearCart removes saved data', () async {
      final Map<String, int> initialCart = <String, int>{'product_1': 1};
      await repository.saveCart(initialCart);

      await repository.clearCart();
      final Map<String, int> savedCart = await repository.getCart();

      expect(savedCart, isEmpty);
    });

    test('getCart handles invalid JSON gracefully', () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('shopping_cart_data', 'invalid json');

      final Map<String, int> cart = await repository.getCart();
      expect(cart, isEmpty);
    });

    test('getCart handles wrong data type in JSON gracefully', () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'shopping_cart_data',
        json.encode(<String, String>{'p1': 'not an int'}),
      );

      final Map<String, int> cart = await repository.getCart();
      expect(cart, isEmpty);
    });
  });
}
