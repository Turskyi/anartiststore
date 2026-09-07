import 'dart:async';

import 'package:anartiststore/enums/group.dart';
import 'package:anartiststore/model/favourites_repository.dart';
import 'package:anartiststore/model/product.dart';
import 'package:anartiststore/model/products_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc(this._productsRepository, this._favouritesRepository)
    : super(const ProductsInitial()) {
    on<LoadProductsEvent>(_loadProducts);
    on<ShowGroupEvent>(_showGroup);
    on<SearchEvent>(_search);
    on<ClearEvent>(_clearSearch);
    on<ToggleFavouriteEvent>(_toggleFavourite);
    on<LoadFavouritesEvent>(_loadFavourites);
  }

  FutureOr<void> _clearSearch(ClearEvent event, Emitter<ProductsState> emit) {
    List<Product> filteredProducts;
    if (state.group.isFavourites) {
      filteredProducts = state.products
          .where((Product product) => state.favouriteIds.contains(product.id))
          .toList();
    } else if (state.group.isAll) {
      filteredProducts = state.products;
    } else {
      filteredProducts = state.products
          .where((Product product) => product.group == state.group)
          .toList();
    }

    emit(
      FilteredProductsState(
        products: state.products,
        group: state.group,
        favouriteIds: state.favouriteIds,
        filteredProducts: filteredProducts,
      ),
    );
  }

  FutureOr<void> _search(SearchEvent event, Emitter<ProductsState> emit) {
    if (event.query.isEmpty) {
      emit(
        LoadedProductsState(
          products: state.products,
          group: state.group,
          favouriteIds: state.favouriteIds,
        ),
      );
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
          favouriteIds: state.favouriteIds,
          filteredProducts: filteredProducts,
        ),
      );
    }
  }

  FutureOr<void> _showGroup(ShowGroupEvent event, Emitter<ProductsState> emit) {
    if (event.group.isAll) {
      emit(
        LoadedProductsState(
          products: state.products,
          group: event.group,
          favouriteIds: state.favouriteIds,
        ),
      );
    } else if (event.group.isFavourites) {
      final List<Product> favourites = state.products
          .where((Product product) => state.favouriteIds.contains(product.id))
          .toList();
      emit(
        FilteredProductsState(
          products: state.products,
          group: event.group,
          favouriteIds: state.favouriteIds,
          filteredProducts: favourites,
        ),
      );
    } else {
      final List<Product> productGroup = state.products
          .where((Product product) => product.group == event.group)
          .toList();
      emit(
        FilteredProductsState(
          products: state.products,
          group: event.group,
          favouriteIds: state.favouriteIds,
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
      emit(
        LoadedProductsState(
          products: products,
          group: state.group,
          favouriteIds: state.favouriteIds,
        ),
      );
    } catch (e) {
      emit(
        ErrorState(
          errorMessage: e.toString(),
          products: state.products,
          group: state.group,
          favouriteIds: state.favouriteIds,
        ),
      );
    }
  }

  FutureOr<void> _loadFavourites(
    LoadFavouritesEvent event,
    Emitter<ProductsState> emit,
  ) async {
    final Set<String> favouriteIds = await _favouritesRepository
        .getFavouriteIds();
    emit(state.copyWith(favouriteIds: favouriteIds));
  }

  FutureOr<void> _toggleFavourite(
    ToggleFavouriteEvent event,
    Emitter<ProductsState> emit,
  ) async {
    final Set<String> currentFavourites = Set<String>.from(state.favouriteIds);
    if (currentFavourites.contains(event.productId)) {
      currentFavourites.remove(event.productId);
      await _favouritesRepository.removeFavourite(event.productId);
    } else {
      currentFavourites.add(event.productId);
      await _favouritesRepository.addFavourite(event.productId);
    }

    final ProductsState newState = state.copyWith(
      favouriteIds: currentFavourites,
    );
    emit(newState);

    // If we are currently in the favourites view, we need to refresh the
    // filtered list.
    if (state.group.isFavourites) {
      add(ShowGroupEvent(state.group));
    }
  }

  final ProductsRepository _productsRepository;
  final FavouritesRepository _favouritesRepository;
}
