import 'package:anartiststore/enums/group.dart';
import 'package:anartiststore/enums/product_availability.dart';
import 'package:anartiststore/model/app_state_model.dart';
import 'package:anartiststore/model/product.dart';
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
    late MockProductsRepository productsRepository;

    setUp(() async {
      cartRepository = MockCartRepository();
      productsRepository = MockProductsRepository();
      productsRepository.products = <Product>[
        const Product(
          id: 'p1',
          name: 'Product 1',
          description: 'Description 1',
          priceInCents: 1000,
          imageUrl: 'url1',
          group: Group.all,
          availability: ProductAvailability.available,
        ),
        const Product(
          id: 'p2',
          name: 'Product 2',
          description: 'Description 2',
          priceInCents: 2000,
          imageUrl: 'url2',
          group: Group.all,
          availability: ProductAvailability.available,
        ),
        const Product(
          id: 'p_unavailable',
          name: 'Product Unavailable',
          description: 'Description U',
          priceInCents: 3000,
          imageUrl: 'url3',
          group: Group.all,
          availability: ProductAvailability.reserved,
        ),
      ];
      model = AppStateModel(
        productsRepository,
        MockEmailRepository(),
        MockContactRepository(),
        MockCurrencyRepository(),
        MockCurrencyService(),
        cartRepository,
      );
      await model.loadProducts();
    });

    test('addProductToCart triggers saveCart', () async {
      model.addProductToCart('p1');
      expect(cartRepository.savedCart['p1'], 1);

      model.addProductToCart('p1');
      expect(cartRepository.savedCart['p1'], 1);
    });

    test('addMultipleProductsToCart triggers saveCart', () async {
      model.addMultipleProductsToCart('p1', 5);
      expect(cartRepository.savedCart['p1'], 1);
    });

    test('removeItemFromCart triggers saveCart', () async {
      model.addProductToCart('p1');
      model.removeItemFromCart('p1');
      expect(cartRepository.savedCart['p1'], isNull);
    });

    test('clearCart triggers clearCart on repository', () async {
      model.addProductToCart('p1');
      model.clearCart();
      expect(cartRepository.clearCalled, isTrue);
      expect(cartRepository.savedCart, isEmpty);
    });

    test('loadCart restores persisted data and enforces quantity 1', () async {
      cartRepository.savedCart = <String, int>{'p2': 3};

      await model.loadCart();

      expect(model.productsInCart['p2'], 1);
    });

    test('loadCart removes unavailable products and enforces quantity 1',
        () async {
      cartRepository.savedCart = <String, int>{
        'p2': 3,
        'p_unavailable': 1,
      };

      await model.loadCart();

      expect(model.productsInCart['p2'], 1);
      expect(model.productsInCart['p_unavailable'], isNull);
    });

    test('addProductToCart ignores unavailable product', () async {
      model.addProductToCart('p_unavailable');
      expect(model.productsInCart['p_unavailable'], isNull);
    });
  });
}
