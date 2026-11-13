import 'dart:convert';

import 'package:anartiststore/data/remote/models/product_catalog_response/product_catalog_response/product_catalog_response.dart';
import 'package:anartiststore/data/remote/models/product_catalog_response/product_catalog_response/product_response.dart';
import 'package:anartiststore/data/remote/retrofit_client/retrofit_rest_client.dart';
import 'package:anartiststore/enums/group.dart';
import 'package:anartiststore/enums/product_availability.dart';
import 'package:anartiststore/model/product.dart';
import 'package:anartiststore/model/products_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  const ProductsRepositoryImpl(this._restClient);

  static const String _catalogCacheKey = 'product_catalog_cache_v1';

  final RetrofitRestClient _restClient;

  @override
  Future<List<Product>> loadProducts([Group group = Group.all]) async {
    late final List<Product> products;
    try {
      final ProductCatalogResponse response = await _restClient
          .getProductCatalog();
      products = response.products.map(_toProduct).toList(growable: false);
    } catch (error, stackTrace) {
      final List<Product>? cachedProducts = await _readCachedProducts();
      if (cachedProducts != null && cachedProducts.isNotEmpty) {
        debugPrint(
          'Product catalog refresh failed; using saved catalog: $error',
        );
        debugPrintStack(stackTrace: stackTrace);
        return cachedProducts;
      } else {
        Error.throwWithStackTrace(error, stackTrace);
      }
    }

    await _saveCachedProducts(products);
    return products;
  }

  Future<void> _saveCachedProducts(List<Product> products) async {
    if (products.isNotEmpty) {
      try {
        final SharedPreferences preferences =
            await SharedPreferences.getInstance();
        final String encodedProducts = json.encode(<String, Object>{
          'version': 1,
          'products': products.map(_toJson).toList(growable: false),
        });
        final bool saved = await preferences.setString(
          _catalogCacheKey,
          encodedProducts,
        );
        if (!saved) {
          debugPrint('The product catalog could not be saved for offline use.');
        }
      } on Exception catch (error, stackTrace) {
        debugPrint('The product catalog could not be saved: $error');
        debugPrintStack(stackTrace: stackTrace);
      }
    }
  }

  Future<List<Product>?> _readCachedProducts() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? encodedProducts = preferences.getString(_catalogCacheKey);
    if (encodedProducts == null) {
      return null;
    }

    try {
      final Object? decoded = json.decode(encodedProducts);
      if (decoded is Map<Object?, Object?> && decoded['version'] == 1) {
        final Object? rawData = decoded['products'];
        if (rawData is! List<Object?>) {
          debugPrint('The saved product catalog has an unsupported format.');
          return null;
        }
        final List<Product> products = <Product>[];
        for (final Object? rawProduct in rawData) {
          final Product? product = _fromJson(rawProduct);
          if (product == null) {
            debugPrint('The saved product catalog contains invalid data.');
            return null;
          } else {
            products.add(product);
          }
        }
        return products;
      } else {
        debugPrint('The saved product catalog has an unsupported format.');
        return null;
      }
    } on FormatException catch (error, stackTrace) {
      debugPrint('The saved product catalog is unreadable: $error');
      debugPrintStack(stackTrace: stackTrace);
      return null;
    }
  }

  Product _toProduct(ProductResponse productResponse) {
    return Product(
      group: productResponse.group,
      id: productResponse.id,
      name: productResponse.name,
      description: productResponse.description,
      priceInCents: productResponse.price,
      imageUrl: productResponse.imageUrl,
      availability: ProductAvailability.fromString(
        productResponse.availability,
      ),
    );
  }

  Map<String, Object> _toJson(Product product) {
    return <String, Object>{
      'group': product.group.name,
      'id': product.id,
      'name': product.name,
      'description': product.description,
      'priceInCents': product.priceInCents,
      'imageUrl': product.imageUrl,
      'isFeatured': product.isFeatured,
      'availability': product.availability.name,
    };
  }

  Product? _fromJson(Object? value) {
    if (value is Map<Object?, Object?>) {
      final Object? groupName = value['group'];
      final Object? id = value['id'];
      final Object? name = value['name'];
      final Object? description = value['description'];
      final Object? priceInCents = value['priceInCents'];
      final Object? imageUrl = value['imageUrl'];
      final Object? isFeatured = value['isFeatured'];
      final Object? availabilityName = value['availability'];
      if (groupName is String &&
          id is String &&
          name is String &&
          description is String &&
          priceInCents is int &&
          imageUrl is String &&
          isFeatured is bool &&
          availabilityName is String) {
        Group? group;
        for (final Group item in Group.values) {
          if (item.name == groupName) {
            group = item;
          }
        }
        ProductAvailability? availability;
        for (final ProductAvailability item in ProductAvailability.values) {
          if (item.name == availabilityName) {
            availability = item;
          }
        }
        if (group != null && availability != null) {
          return Product(
            group: group,
            id: id,
            name: name,
            description: description,
            priceInCents: priceInCents,
            imageUrl: imageUrl,
            isFeatured: isFeatured,
            availability: availability,
          );
        }
      }
    }
    return null;
  }
}
