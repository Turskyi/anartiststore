part of 'products_bloc.dart';

@immutable
sealed class ProductsEvent {
  const ProductsEvent();
}

class LoadProductsEvent extends ProductsEvent {
  const LoadProductsEvent();
}

class ShowGroupEvent extends ProductsEvent {
  const ShowGroupEvent(this.group);

  final Group group;
}

class SearchEvent extends ProductsEvent {
  const SearchEvent(this.query);

  final String query;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is SearchEvent &&
          runtimeType == other.runtimeType &&
          query == other.query;

  @override
  int get hashCode => super.hashCode ^ query.hashCode;
}
