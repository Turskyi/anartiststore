import 'package:anartiststore/enums/group.dart';
import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_response.g.dart';

@JsonSerializable()
class ProductResponse {
  const ProductResponse({
    required this.id,
    required this.description,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return _$ProductResponseFromJson(json);
  }

  final String id;
  final String description;
  final String imageUrl;
  final String name;
  final int price;
  final DateTime createdAt;
  final DateTime updatedAt;

  Group get group => Group.values.firstWhere(
        (Group groupElement) =>
            name.contains(groupElement.name) ||
            description.contains(groupElement.name),
        orElse: () => Group.all,
      );

  @override
  String toString() {
    return 'Product('
        'id: $id, '
        'description: $description, '
        'imageUrl: $imageUrl, '
        'name: $name, '
        'price: $price, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt,'
        ')';
  }

  Map<String, dynamic> toJson() => _$ProductResponseToJson(this);

  ProductResponse copyWith({
    String? id,
    String? description,
    String? imageUrl,
    String? name,
    int? price,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      ProductResponse(
        id: id ?? this.id,
        description: description ?? this.description,
        imageUrl: imageUrl ?? this.imageUrl,
        name: name ?? this.name,
        price: price ?? this.price,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! ProductResponse) return false;
    final bool Function(Object? e1, Object? e2) mapEquals =
        const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      description.hashCode ^
      imageUrl.hashCode ^
      name.hashCode ^
      price.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}
