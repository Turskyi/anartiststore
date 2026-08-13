import 'package:anartiststore/backdrop/backdrop.dart';
import 'package:anartiststore/bloc/products_bloc.dart';
import 'package:anartiststore/cart/expanding_bottom_sheet.dart';
import 'package:anartiststore/data/remote/currency_service.dart';
import 'package:anartiststore/data/remote/models/logging_interceptor.dart';
import 'package:anartiststore/data/remote/retrofit_client/currency_rest_client.dart';
import 'package:anartiststore/data/remote/retrofit_client/retrofit_rest_client.dart';
import 'package:anartiststore/data/repositories/email_repository_impl.dart';
import 'package:anartiststore/data/repositories/products_repository_impl.dart';
import 'package:anartiststore/data/repositories/shared_preferences_currency_repository.dart';
import 'package:anartiststore/data/repositories/shared_preferences_favourites_repository.dart';
import 'package:anartiststore/enums/group.dart';
import 'package:anartiststore/group/group_menu_page.dart';
import 'package:anartiststore/home_page.dart';
import 'package:anartiststore/login.dart';
import 'package:anartiststore/model/app_state_model.dart';
import 'package:anartiststore/model/currency_repository.dart';
import 'package:anartiststore/model/email_repository.dart';
import 'package:anartiststore/model/favourites_repository.dart';
import 'package:anartiststore/model/product.dart';
import 'package:anartiststore/model/products_repository.dart';
import 'package:anartiststore/page_status.dart';
import 'package:anartiststore/product_details_page.dart';
import 'package:anartiststore/res/resources.dart';
import 'package:anartiststore/router/app_route.dart';
import 'package:anartiststore/scrim.dart';
import 'package:anartiststore/supplemental/layout_cache.dart';
import 'package:anartiststore/supplemental/product_grid_view.dart';
import 'package:anartiststore/theme.dart';
import 'package:anartiststore/ui/app_error_widget.dart';
import 'package:anartiststore/ui/empty_favourites.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:scoped_model/scoped_model.dart';

class AnArtistStoreApp extends StatefulWidget {
  const AnArtistStoreApp({super.key});

  @override
  State<AnArtistStoreApp> createState() => _AnArtistStoreAppState();
}

class _AnArtistStoreAppState extends State<AnArtistStoreApp>
    with TickerProviderStateMixin, RestorationMixin {
  final Map<String, List<List<int>>> _layouts = <String, List<List<int>>>{};
  final _RestorableAppStateModel _model = _RestorableAppStateModel();
  final RestorableDouble _expandingTabIndex = RestorableDouble(0);
  final RestorableDouble _tabIndex = RestorableDouble(1);

  /// [AnimationController] to coordinate both the opening/closing of backdrop
  /// and sliding of expanding bottom sheet.
  late AnimationController _controller;

  /// [AnimationController] for expanding/collapsing the cart menu.
  late AnimationController _expandingController;

  @override
  String get restorationId => 'an_artist_store_app_state';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_model, 'app_state_model');
    registerForRestoration(_tabIndex, 'tab_index');
    final RestorableDouble expandingTabIndex = RestorableDouble(0);
    registerForRestoration(
      expandingTabIndex,
      'expanding_tab_index',
    );
    _controller.value = _tabIndex.value;
    _expandingController.value = expandingTabIndex.value;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
      value: 1,
    );
    // Save state restoration animation values only when the cart page
    // fully opens or closes.
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _tabIndex.value = _controller.value;
      }
    });
    _expandingController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    LocalizationProvider.of(context);
    return ScopedModel<AppStateModel>(
      model: _model.value,
      child: BlocProvider<ProductsBloc>(
        create: (BuildContext _) => ProductsBloc(
          _productRepository,
          _favouritesRepository,
        )
          ..add(const LoadProductsEvent())
          ..add(const LoadFavouritesEvent()),
        child: PopScope<Object?>(
          onPopInvokedWithResult: _onWillPop,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: Resources.of(context).strings.title,
            localizationsDelegates: <LocalizationsDelegate<Object?>>[
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              LocalizedApp.of(context).delegate,
            ],
            supportedLocales:
                LocalizedApp.of(context).delegate.supportedLocales,
            locale: LocalizedApp.of(context).delegate.currentLocale,
            initialRoute: AppRoute.home.path,
            routes: <String, WidgetBuilder>{
              AppRoute.login.path: (BuildContext context) => const LoginPage(),
              AppRoute.productDetails.path: (BuildContext context) {
                final ModalRoute<Object?>? route = ModalRoute.of(context);
                if (route != null) {
                  final Object? arguments = route.settings.arguments;
                  if (arguments is Product) {
                    return ProductDetailsPage(product: arguments);
                  }
                }
                return Scaffold(
                  body: Center(
                    child: Text(translate('productNotFound')),
                  ),
                );
              },
              AppRoute.home.path: (BuildContext _) =>
                  BlocBuilder<ProductsBloc, ProductsState>(
                    builder: (BuildContext context, ProductsState state) {
                      Widget frontLayer;
                      if (state is FilteredProductsState) {
                        if (state.group.isFavourites &&
                            state.filteredProducts.isEmpty) {
                          frontLayer = const EmptyFavourites();
                        } else {
                          frontLayer = ProductGridView(
                            products: state.filteredProducts,
                          );
                        }
                      } else if (state is LoadedProductsState) {
                        frontLayer = ProductGridView(products: state.products);
                      } else if (state is ErrorState) {
                        frontLayer = AppErrorWidget(
                          errorMessage: state.errorMessage,
                        );
                      } else {
                        frontLayer = const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final Backdrop backdrop = Backdrop(
                        currentCategory: state.group,
                        frontLayer: frontLayer,
                        backLayer: GroupMenuPage(
                          currentCategory: state.group,
                          onCategoryTap: (Group group) => context
                              .read<ProductsBloc>()
                              .add(ShowGroupEvent(group)),
                        ),
                        frontTitle: Text(
                          Resources.of(context).strings.title,
                          style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.fontSize,
                          ),
                        ),
                        backTitle: Text(translate('menu')),
                        products: state is FilteredProductsState
                            ? state.filteredProducts
                            : state.products,
                      );
                      return LayoutCache(
                        layouts: _layouts,
                        child: PageStatus(
                          menuController: _controller,
                          cartController: _expandingController,
                          child: HomePage(
                            backdrop: backdrop,
                            scrim: Scrim(controller: _expandingController),
                            expandingBottomSheet: ExpandingBottomSheet(
                              hideController: _controller,
                              expandingController: _expandingController,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            },
            theme: kAnArtistStoreTheme,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _expandingController.dispose();
    _tabIndex.dispose();
    _expandingTabIndex.dispose();
    super.dispose();
  }

  /// Closes the bottom sheet if it is open.
  Future<bool> _onWillPop(bool _, Object? __) async {
    final AnimationStatus status = _expandingController.status;
    if (status == AnimationStatus.completed ||
        status == AnimationStatus.forward) {
      await _expandingController.reverse();
      return false;
    }

    return true;
  }
}

ProductsRepository get _productRepository {
  return ProductsRepositoryImpl(
    RetrofitRestClient(Dio()..interceptors.add(const LoggingInterceptor())),
  );
}

FavouritesRepository get _favouritesRepository {
  return SharedPreferencesFavouritesRepository();
}

EmailRepository get _emailRepository {
  return EmailRepositoryImpl(
    RetrofitRestClient(Dio()..interceptors.add(const LoggingInterceptor())),
  );
}

CurrencyRepository get _currencyRepository {
  return SharedPreferencesCurrencyRepository();
}

CurrencyService get _currencyService {
  return CurrencyService(
    CurrencyRestClient(Dio()..interceptors.add(const LoggingInterceptor())),
  );
}

class _RestorableAppStateModel extends RestorableListenable<AppStateModel> {
  @override
  AppStateModel createDefaultValue() => AppStateModel(
        _productRepository,
        _emailRepository,
        _currencyRepository,
        _currencyService,
      )
        ..loadProducts()
        ..loadCurrency();

  @override
  AppStateModel fromPrimitives(Object? data) {
    final AppStateModel appState = AppStateModel(
      _productRepository,
      _emailRepository,
      _currencyRepository,
      _currencyService,
    )
      ..loadProducts()
      ..loadCurrency();

    if (data is Map<dynamic, dynamic>) {
      final Map<String, dynamic> appData = Map<String, dynamic>.from(data);

      // Reset selected category.
      final Object? categoryIndex = appData['category_index'];
      if (categoryIndex is int) {
        if (categoryIndex >= 0 && categoryIndex < Group.values.length) {
          appState.setCategory(Group.values[categoryIndex]);
        }
      }

      // Reset cart items.
      final Object? cartData = appData['cart_data'];
      if (cartData is Map<Object?, Object?>) {
        final Map<Object?, Object?> cartItems = cartData;
        cartItems.forEach((Object? id, Object? quantity) {
          if (id is String && quantity is int) {
            appState.addMultipleProductsToCart(id, quantity);
          }
        });
      }
    }

    return appState;
  }

  @override
  Object toPrimitives() {
    return <String, dynamic>{
      'cart_data': value.productsInCart,
      'category_index': Group.values.indexOf(value.selectedCategory),
    };
  }
}
