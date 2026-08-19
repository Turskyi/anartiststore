part of 'products_bloc.dart';

@immutable
sealed class ProductsState {
  const ProductsState({
    this.group = Group.all,
    this.products = const <Product>[],
    this.favouriteIds = const <String>{},
    this.isLoading = false,
  });

  final Group group;
  final List<Product> products;
  final Set<String> favouriteIds;
  final bool isLoading;

  ProductsState copyWith({
    Group? group,
    List<Product>? products,
    Set<String>? favouriteIds,
    bool? isLoading,
  });
}

final class ProductsInitial extends ProductsState {
  const ProductsInitial() : super(isLoading: true);

  @override
  ProductsState copyWith({
    Group? group,
    List<Product>? products,
    Set<String>? favouriteIds,
    bool? isLoading,
  }) {
    return LoadedProductsState(
      products: products ?? this.products,
      group: group ?? this.group,
      favouriteIds: favouriteIds ?? this.favouriteIds,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final class LoadedProductsState extends ProductsState {
  const LoadedProductsState({
    required super.products,
    required super.group,
    super.favouriteIds,
    super.isLoading,
  });

  @override
  ProductsState copyWith({
    Group? group,
    List<Product>? products,
    Set<String>? favouriteIds,
    bool? isLoading,
  }) {
    return LoadedProductsState(
      products: products ?? this.products,
      group: group ?? this.group,
      favouriteIds: favouriteIds ?? this.favouriteIds,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final class FilteredProductsState extends LoadedProductsState {
  const FilteredProductsState({
    required super.products,
    required super.group,
    super.favouriteIds,
    super.isLoading,
    this.filteredProducts = const <Product>[],
  });

  final List<Product> filteredProducts;

  @override
  ProductsState copyWith({
    Group? group,
    List<Product>? products,
    Set<String>? favouriteIds,
    bool? isLoading,
    List<Product>? filteredProducts,
  }) {
    return FilteredProductsState(
      products: products ?? this.products,
      group: group ?? this.group,
      favouriteIds: favouriteIds ?? this.favouriteIds,
      isLoading: isLoading ?? this.isLoading,
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
    super.isLoading,
  });

  final String errorMessage;

  @override
  ProductsState copyWith({
    Group? group,
    List<Product>? products,
    Set<String>? favouriteIds,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ErrorState(
      errorMessage: errorMessage ?? this.errorMessage,
      products: products ?? this.products,
      group: group ?? this.group,
      favouriteIds: favouriteIds ?? this.favouriteIds,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
