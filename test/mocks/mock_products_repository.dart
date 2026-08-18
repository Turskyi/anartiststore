import 'package:anartiststore/enums/group.dart';
import 'package:anartiststore/model/product.dart';
import 'package:anartiststore/model/products_repository.dart';

class MockProductsRepository implements ProductsRepository {
  List<Product> products = <Product>[];

  @override
  Future<List<Product>> loadProducts([Group group = Group.all]) async =>
      products;
}
