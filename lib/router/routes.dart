import 'package:anartiststore/backdrop/backdrop.dart';
import 'package:anartiststore/bloc/products_bloc.dart';
import 'package:anartiststore/data/remote/models/logging_interceptor.dart';
import 'package:anartiststore/data/remote/retrofit_client/retrofit_rest_client.dart';
import 'package:anartiststore/data/repositories/products_repository_impl.dart';
import 'package:anartiststore/enums/group.dart';
import 'package:anartiststore/group/group_menu_page.dart';
import 'package:anartiststore/login.dart';
import 'package:anartiststore/res/resources.dart';
import 'package:anartiststore/router/app_route.dart';
import 'package:anartiststore/supplemental/asymmetric_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

Map<String, WidgetBuilder> routeWidgetBuilderMap = <String, WidgetBuilder>{
  AppRoute.login.path: (BuildContext context) => const LoginPage(),
  AppRoute.home.path: (_) => BlocProvider<ProductsBloc>(
        create: (_) {
          return ProductsBloc(ProductsRepositoryImpl(_restClient))
            ..add(const LoadProductsEvent());
        },
        child: BlocBuilder<ProductsBloc, ProductsState>(
          builder: (BuildContext context, ProductsState state) {
            return Backdrop(
              currentCategory: state.group,
              frontLayer: state is FilteredProductsState
                  ? AsymmetricView(products: state.filteredProducts)
                  : state is LoadedProductsState
                      ? AsymmetricView(products: state.products)
                      : const Center(child: CircularProgressIndicator()),
              backLayer: GroupMenuPage(
                currentCategory: state.group,
                onCategoryTap: (Group group) =>
                    context.read<ProductsBloc>().add(ShowGroupEvent(group)),
              ),
              frontTitle: Text(Resources.of(context).strings.title),
              backTitle: Text(translate('menu')),
              products: state is FilteredProductsState
                  ? state.filteredProducts
                  : state.products,
            );
          },
        ),
      ),
};

RetrofitRestClient get _restClient =>
    RetrofitRestClient(Dio()..interceptors.add(const LoggingInterceptor()));
