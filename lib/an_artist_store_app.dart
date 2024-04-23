import 'package:anartiststore/backdrop/backdrop.dart';
import 'package:anartiststore/bloc/products_bloc.dart';
import 'package:anartiststore/cart/expanding_bottom_sheet.dart';
import 'package:anartiststore/data/remote/models/logging_interceptor.dart';
import 'package:anartiststore/data/remote/retrofit_client/retrofit_rest_client.dart';
import 'package:anartiststore/data/repositories/products_repository_impl.dart';
import 'package:anartiststore/enums/group.dart';
import 'package:anartiststore/group/group_menu_page.dart';
import 'package:anartiststore/home_page.dart';
import 'package:anartiststore/login.dart';
import 'package:anartiststore/model/app_state_model.dart';
import 'package:anartiststore/model/products_repository.dart';
import 'package:anartiststore/page_status.dart';
import 'package:anartiststore/res/resources.dart';
import 'package:anartiststore/router/app_route.dart';
import 'package:anartiststore/scrim.dart';
import 'package:anartiststore/supplemental/layout_cache.dart';
import 'package:anartiststore/supplemental/mobile_asymmetric_view.dart';
import 'package:anartiststore/theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return ScopedModel<AppStateModel>(
      model: _model.value,
      child: PopScope(
        onPopInvoked: _onWillPop,
        child: MaterialApp(
          title: Resources.of(context).strings.title,
          initialRoute: AppRoute.home.path,
          routes: <String, WidgetBuilder>{
            AppRoute.login.path: (BuildContext context) => const LoginPage(),
            AppRoute.home.path: (_) => BlocProvider<ProductsBloc>(
                  create: (_) => ProductsBloc(_productRepository)
                    ..add(const LoadProductsEvent()),
                  child: BlocBuilder<ProductsBloc, ProductsState>(
                    builder: (BuildContext context, ProductsState state) {
                      Backdrop backdrop = Backdrop(
                        currentCategory: state.group,
                        frontLayer: state is FilteredProductsState
                            ? MobileAsymmetricView(
                                products: state.filteredProducts,
                              )
                            : state is LoadedProductsState
                                ? MobileAsymmetricView(products: state.products)
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                        backLayer: GroupMenuPage(
                          currentCategory: state.group,
                          onCategoryTap: (Group group) => context
                              .read<ProductsBloc>()
                              .add(ShowGroupEvent(group)),
                        ),
                        frontTitle: Text(Resources.of(context).strings.title),
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
                ),
          },
          theme: kAnArtistStoreTheme,
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
  Future<bool> _onWillPop(bool value) async {
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

class _RestorableAppStateModel extends RestorableListenable<AppStateModel> {
  @override
  AppStateModel createDefaultValue() =>
      AppStateModel(_productRepository)..loadProducts();

  @override
  AppStateModel fromPrimitives(Object? data) {
    final AppStateModel appState = AppStateModel(_productRepository)
      ..loadProducts();
    final Map<String, dynamic> appData =
        Map<String, dynamic>.from(data as Map<String, dynamic>);

    // Reset selected category.
    final int categoryIndex = appData['category_index'] as int;
    appState.setCategory(Group.values[categoryIndex]);

    // Reset cart items.
    final Map<dynamic, dynamic> cartItems =
        appData['cart_data'] as Map<dynamic, dynamic>;
    cartItems.forEach((dynamic id, dynamic quantity) {
      appState.addMultipleProductsToCart(id as String, quantity as int);
    });

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
