import 'package:anartiststore/enums/group.dart';
import 'package:anartiststore/model/product.dart';

abstract interface class ProductsRepository {
  const ProductsRepository();

  Future<List<Product>> loadProducts([Group group = Group.all]);
}
