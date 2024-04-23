import 'package:anartiststore/data/remote/models/product_catalog_response/product_catalog_response/product_catalog_response.dart';
import 'package:anartiststore/data/remote/models/product_catalog_response/product_catalog_response/product_response.dart';
import 'package:anartiststore/data/remote/retrofit_client/retrofit_rest_client.dart';
import 'package:anartiststore/enums/group.dart';
import 'package:anartiststore/model/product.dart';
import 'package:anartiststore/model/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  const ProductsRepositoryImpl(this._restClient);

  final RetrofitRestClient _restClient;

  @override
  Future<List<Product>> loadProducts([Group group = Group.all]) async {
    final List<Product> products = <Product>[];
    final ProductCatalogResponse response =
        await _restClient.getProductCatalog();
    for (ProductResponse productResponse in response.products) {
      products.add(
        Product(
          group: productResponse.group,
          id: productResponse.id,
          name: productResponse.name,
          description: productResponse.description,
          priceInCents: productResponse.price,
          imageUrl: productResponse.imageUrl,
        ),
      );
    }
    return products;
  }
}
