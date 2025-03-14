part of 'products_bloc.dart';

@immutable
sealed class ProductsState {
  const ProductsState({
    this.group = Group.all,
    this.products = const <Product>[],
  });

  final Group group;
  final List<Product> products;
}

final class ProductsInitial extends ProductsState {
  const ProductsInitial();
}

final class LoadedProductsState extends ProductsState {
  const LoadedProductsState({required super.products, required super.group});
}

final class FilteredProductsState extends LoadedProductsState {
  const FilteredProductsState({
    required super.products,
    required super.group,
    this.filteredProducts = const <Product>[],
  });

  final List<Product> filteredProducts;
}

final class ErrorState extends ProductsState {
  const ErrorState({
    this.errorMessage = 'Something went wrong',
    super.products,
    super.group,
  });

  final String errorMessage;
}
