part of 'products_bloc.dart';

@immutable
sealed class ProductsState {
  const ProductsState({
    this.group = Group.all,
    this.products = const <Product>[],
    this.favouriteIds = const <String>{},
  });

  final Group group;
  final List<Product> products;
  final Set<String> favouriteIds;

  ProductsState copyWith({
    Group? group,
    List<Product>? products,
    Set<String>? favouriteIds,
  });
}

final class ProductsInitial extends ProductsState {
  const ProductsInitial();

  @override
  ProductsState copyWith({
    Group? group,
    List<Product>? products,
    Set<String>? favouriteIds,
  }) {
    return LoadedProductsState(
      products: products ?? this.products,
      group: group ?? this.group,
      favouriteIds: favouriteIds ?? this.favouriteIds,
    );
  }
}

final class LoadedProductsState extends ProductsState {
  const LoadedProductsState({
    required super.products,
    required super.group,
    super.favouriteIds,
  });

  @override
  ProductsState copyWith({
    Group? group,
    List<Product>? products,
    Set<String>? favouriteIds,
  }) {
    return LoadedProductsState(
      products: products ?? this.products,
      group: group ?? this.group,
      favouriteIds: favouriteIds ?? this.favouriteIds,
    );
  }
}

final class FilteredProductsState extends LoadedProductsState {
  const FilteredProductsState({
    required super.products,
    required super.group,
    super.favouriteIds,
    this.filteredProducts = const <Product>[],
  });

  final List<Product> filteredProducts;

  @override
  ProductsState copyWith({
    Group? group,
    List<Product>? products,
    Set<String>? favouriteIds,
    List<Product>? filteredProducts,
  }) {
    return FilteredProductsState(
      products: products ?? this.products,
      group: group ?? this.group,
      favouriteIds: favouriteIds ?? this.favouriteIds,
      filteredProducts: filteredProducts ?? this.filteredProducts,
    );
  }
}

final class ErrorState extends ProductsState {
  const ErrorState({
    this.errorMessage = 'Something went wrong',
    super.products,
    super.group,
    super.favouriteIds,
  });

  final String errorMessage;

  @override
  ProductsState copyWith({
    Group? group,
    List<Product>? products,
    Set<String>? favouriteIds,
    String? errorMessage,
  }) {
    return ErrorState(
      errorMessage: errorMessage ?? this.errorMessage,
      products: products ?? this.products,
      group: group ?? this.group,
      favouriteIds: favouriteIds ?? this.favouriteIds,
    );
  }
}
