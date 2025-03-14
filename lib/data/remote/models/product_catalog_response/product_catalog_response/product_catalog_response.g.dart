// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_catalog_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductCatalogResponse _$ProductCatalogResponseFromJson(
        Map<String, dynamic> json) =>
    ProductCatalogResponse(
      products: (json['products'] as List<dynamic>)
          .map((e) => ProductResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductCatalogResponseToJson(
        ProductCatalogResponse instance) =>
    <String, dynamic>{
      'products': instance.products,
      'totalPages': instance.totalPages,
    };
