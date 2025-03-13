import 'dart:async';

import 'package:anartiststore/enums/group.dart';
import 'package:anartiststore/model/product.dart';
import 'package:anartiststore/model/products_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc(this._productsRepository) : super(const ProductsInitial()) {
    on<LoadProductsEvent>(_loadProducts);
    on<ShowGroupEvent>(_showGroup);
    on<SearchEvent>(_search);
    on<ClearEvent>(_clearSearch);
  }

  FutureOr<void> _clearSearch(ClearEvent event, Emitter<ProductsState> emit) {
    final List<Product> productGroup = state.products
        .where((Product product) => product.group == state.group)
        .toList();
    emit(
      FilteredProductsState(
        products: state.products,
        group: state.group,
        filteredProducts: productGroup,
      ),
    );
  }

  FutureOr<void> _search(SearchEvent event, Emitter<ProductsState> emit) {
    if (event.query.isEmpty) {
      emit(LoadedProductsState(products: state.products, group: state.group));
    } else {
      final List<Product> filteredProducts = state.products
          .where(
            (Product product) =>
                product.name.toLowerCase().contains(
                      event.query.toLowerCase(),
                    ) ||
                product.description.toLowerCase().contains(
                      event.query.toLowerCase(),
                    ),
          )
          .toList();
      emit(
        FilteredProductsState(
          products: state.products,
          group: state.group,
          filteredProducts: filteredProducts,
        ),
      );
    }
  }

  FutureOr<void> _showGroup(ShowGroupEvent event, Emitter<ProductsState> emit) {
    if (event.group == Group.all) {
      emit(LoadedProductsState(products: state.products, group: event.group));
    } else {
      final List<Product> productGroup = state.products
          .where((Product product) => product.group == event.group)
          .toList();
      emit(
        FilteredProductsState(
          products: state.products,
          group: event.group,
          filteredProducts: productGroup,
        ),
      );
    }
  }

  FutureOr<void> _loadProducts(
    LoadProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    try {
      final List<Product> products = await _productsRepository.loadProducts(
        state.group,
      );
      emit(LoadedProductsState(products: products, group: state.group));
    } catch (e) {
      emit(ErrorState(errorMessage: e.toString()));
    }
  }

  final ProductsRepository _productsRepository;
}
