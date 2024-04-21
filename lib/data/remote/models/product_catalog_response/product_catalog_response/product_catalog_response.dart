import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import 'product_response.dart';

part 'product_catalog_response.g.dart';

@JsonSerializable()
class ProductCatalogResponse {
  const ProductCatalogResponse({
    required this.products,
    this.totalPages,
  });

  factory ProductCatalogResponse.fromJson(Map<String, dynamic> json) {
    return _$ProductCatalogResponseFromJson(json);
  }

  final List<ProductResponse> products;
  final int? totalPages;

  @override
  String toString() =>
      'ProductCatalogResponse(products: $products, totalPages: $totalPages)';

  Map<String, dynamic> toJson() => _$ProductCatalogResponseToJson(this);

  ProductCatalogResponse copyWith({
    List<ProductResponse>? products,
    int? totalPages,
  }) =>
      ProductCatalogResponse(
        products: products ?? this.products,
        totalPages: totalPages ?? this.totalPages,
      );

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! ProductCatalogResponse) return false;
    final bool Function(Object? e1, Object? e2) mapEquals =
        const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => products.hashCode ^ totalPages.hashCode;
}
