import 'package:anartiststore/model/app_state_model.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mocks/mock_cart_repository.dart';
import 'mocks/mock_contact_repository.dart';
import 'mocks/mock_currency_repository.dart';
import 'mocks/mock_currency_service.dart';
import 'mocks/mock_email_repository.dart';
import 'mocks/mock_products_repository.dart';

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
