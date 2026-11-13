import 'package:anartiststore/data/remote/models/email_response/email_response.dart';
import 'package:anartiststore/data/remote/models/product_catalog_response/product_catalog_response/product_catalog_response.dart';
import 'package:anartiststore/data/remote/models/product_catalog_response/product_catalog_response/product_response.dart';
import 'package:anartiststore/data/remote/retrofit_client/retrofit_rest_client.dart';
import 'package:anartiststore/data/repositories/products_repository_impl.dart';
import 'package:anartiststore/model/email/email.dart';
import 'package:anartiststore/model/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('uses the saved catalog when refreshing while offline', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final _FakeRetrofitRestClient client = _FakeRetrofitRestClient();
    final ProductsRepositoryImpl repository = ProductsRepositoryImpl(client);

    final List<Product> productsOnline = await repository.loadProducts();
    client.isOffline = true;
    final List<Product> productsOffline = await repository.loadProducts();

    expect(productsOffline, hasLength(1));
    expect(productsOffline.single.id, productsOnline.single.id);
    expect(productsOffline.single.name, productsOnline.single.name);
    expect(productsOffline.single.imageUrl, productsOnline.single.imageUrl);
    expect(
      productsOffline.single.priceInCents,
      productsOnline.single.priceInCents,
    );
  });
}

class _FakeRetrofitRestClient implements RetrofitRestClient {
  bool isOffline = false;

  @override
  Future<ProductCatalogResponse> getProductCatalog({String? page}) async {
    if (isOffline) {
      throw Exception('offline');
    }
    return ProductCatalogResponse(
      products: <ProductResponse>[
        ProductResponse(
          id: 'product-1',
          description: 'A handmade product',
          imageUrl: 'https://example.com/product-1.png',
          name: 'Product 1',
          price: 2500,
          createdAt: DateTime.utc(2025),
          updatedAt: DateTime.utc(2025),
        ),
      ],
    );
  }

  @override
  Future<EmailResponse> email(Email email) async {
    throw UnimplementedError();
  }

  @override
  Future<EmailResponse> order(Email email) async {
    throw UnimplementedError();
  }

  @override
  Future<EmailResponse> send(Email email) async {
    throw UnimplementedError();
  }
}
