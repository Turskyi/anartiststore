import 'package:anartiststore/data/remote/currency_service.dart';
import 'package:anartiststore/enums/currency.dart';
import 'package:anartiststore/enums/group.dart';
import 'package:anartiststore/model/app_state_model.dart';
import 'package:anartiststore/model/cart.dart';
import 'package:anartiststore/model/cart_repository.dart';
import 'package:anartiststore/model/contact_info.dart';
import 'package:anartiststore/model/contact_repository.dart';
import 'package:anartiststore/model/currency_repository.dart';
import 'package:anartiststore/model/email_repository.dart';
import 'package:anartiststore/model/product.dart';
import 'package:anartiststore/model/products_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class MockProductsRepository implements ProductsRepository {
  @override
  Future<List<Product>> loadProducts([Group group = Group.all]) async =>
      <Product>[];
}

class MockEmailRepository implements EmailRepository {
  @override
  Future<void> sendOrderEmail({
    required Cart cart,
    required ContactInfo contactInfo,
    required String currencyCode,
  }) async {}
}

class MockContactRepository implements ContactRepository {
  @override
  Future<void> sendContactMessage({
    required String name,
    required String email,
    required String message,
    required String currencyCode,
  }) async {}
}

class MockCurrencyRepository implements CurrencyRepository {
  @override
  Future<Currency> getSelectedCurrency() async => Currency.eur;

  @override
  Future<void> saveSelectedCurrency(Currency currency) async {}
}

class MockCurrencyService implements CurrencyService {
  @override
  Future<Map<Currency, double>> fetchExchangeRates() async =>
      <Currency, double>{Currency.eur: 1.0};
}

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

void main() {
  group('AppStateModel Persistence', () {
    late AppStateModel model;
    late MockCartRepository cartRepository;

    setUp(() {
      cartRepository = MockCartRepository();
      model = AppStateModel(
        MockProductsRepository(),
        MockEmailRepository(),
        MockContactRepository(),
        MockCurrencyRepository(),
        MockCurrencyService(),
        cartRepository,
      );
    });

    test('addProductToCart triggers saveCart', () async {
      model.addProductToCart('p1');
      expect(cartRepository.savedCart['p1'], 1);

      model.addProductToCart('p1');
      expect(cartRepository.savedCart['p1'], 2);
    });

    test('addMultipleProductsToCart triggers saveCart', () async {
      model.addMultipleProductsToCart('p1', 5);
      expect(cartRepository.savedCart['p1'], 5);
    });

    test('removeItemFromCart triggers saveCart', () async {
      model.addMultipleProductsToCart('p1', 2);
      model.removeItemFromCart('p1');
      expect(cartRepository.savedCart['p1'], 1);

      model.removeItemFromCart('p1');
      expect(cartRepository.savedCart['p1'], isNull);
    });

    test('clearCart triggers clearCart on repository', () async {
      model.addProductToCart('p1');
      model.clearCart();
      expect(cartRepository.clearCalled, isTrue);
      expect(cartRepository.savedCart, isEmpty);
    });

    test('loadCart restores persisted data', () async {
      cartRepository.savedCart = <String, int>{'p2': 3};

      await model.loadCart();

      expect(model.productsInCart['p2'], 3);
    });
  });
}
