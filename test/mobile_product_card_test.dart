import 'package:anartiststore/bloc/products_bloc.dart';
import 'package:anartiststore/enums/group.dart';
import 'package:anartiststore/enums/language.dart';
import 'package:anartiststore/model/app_state_model.dart';
import 'package:anartiststore/model/product.dart';
import 'package:anartiststore/supplemental/mobile_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:scoped_model/scoped_model.dart';

import 'mocks/mock_cart_repository.dart';
import 'mocks/mock_contact_repository.dart';
import 'mocks/mock_currency_repository.dart';
import 'mocks/mock_currency_service.dart';
import 'mocks/mock_email_repository.dart';
import 'mocks/mock_favourites_repository.dart';
import 'mocks/mock_products_repository.dart';

void main() {
  testWidgets('MobileProductCard does not overflow when scaled down to zero', (
    WidgetTester tester,
  ) async {
    final LocalizationDelegate delegate = await LocalizationDelegate.create(
      fallbackLocale: Language.en.isoLanguageCode,
      supportedLocales: Language.values
          .map((Language language) => language.isoLanguageCode)
          .toList(),
    );

    final AppStateModel model = AppStateModel(
      MockProductsRepository(),
      MockEmailRepository(),
      MockContactRepository(),
      MockCurrencyRepository(),
      MockCurrencyService(),
      MockCartRepository(),
    );

    final ProductsBloc productsBloc = ProductsBloc(
      MockProductsRepository(),
      MockFavouritesRepository(),
    );

    const Product product = Product(
      group: Group.all,
      id: '1',
      name: 'Very Long Product Name that might overflow',
      description: 'Description',
      priceInCents: 1000,
      imageUrl: 'https://example.com/image.png',
    );

    // We test multiple small sizes to simulate an animation collapsing to 0.
    final List<Size> testSizes = <Size>[
      const Size(300, 300),
      const Size(150, 150),
      const Size(50, 50),
      const Size(10, 10),
      const Size(1, 1),
    ];

    for (final Size size in testSizes) {
      await tester.pumpWidget(
        LocalizedApp(
          delegate,
          MaterialApp(
            home: ScopedModel<AppStateModel>(
              model: model,
              child: BlocProvider<ProductsBloc>(
                create: (_) => productsBloc,
                child: Scaffold(
                  body: Center(
                    child: SizedBox(
                      width: size.width,
                      height: size.height,
                      child: const MobileProductCard(product: product),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Verify no overflow was detected.
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('MobileProductCard does not overflow with extreme text scaling', (
    WidgetTester tester,
  ) async {
    final LocalizationDelegate delegate = await LocalizationDelegate.create(
      fallbackLocale: Language.en.isoLanguageCode,
      supportedLocales: Language.values
          .map((Language language) => language.isoLanguageCode)
          .toList(),
    );

    final AppStateModel model = AppStateModel(
      MockProductsRepository(),
      MockEmailRepository(),
      MockContactRepository(),
      MockCurrencyRepository(),
      MockCurrencyService(),
      MockCartRepository(),
    );

    final ProductsBloc productsBloc = ProductsBloc(
      MockProductsRepository(),
      MockFavouritesRepository(),
    );

    const Product product = Product(
      group: Group.all,
      id: '1',
      name: 'Extremely Long Name That Will Definitely Overflow Standard Space',
      description: 'Description',
      priceInCents: 1000000,
      imageUrl: 'https://example.com/image.png',
    );

    await tester.pumpWidget(
      LocalizedApp(
        delegate,
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(5.0)),
            child: ScopedModel<AppStateModel>(
              model: model,
              child: BlocProvider<ProductsBloc>(
                create: (_) => productsBloc,
                child: const Scaffold(
                  body: Center(
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: MobileProductCard(product: product),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // Verify no overflow was detected even with 5x text scaling.
    expect(tester.takeException(), isNull);
  });
}
