import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'email_id.g.dart';

@JsonSerializable()
class EmailId {
  const EmailId({this.id});

  factory EmailId.fromJson(Map<String, dynamic> json) =>
      _$EmailIdFromJson(json);
  final String? id;

  @override
  String toString() => 'EmailId(id: $id)';

  Map<String, dynamic> toJson() => _$EmailIdToJson(this);

  EmailId copyWith({
    String? id,
  }) =>
      EmailId(
        id: id ?? this.id,
      );

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! EmailId) return false;
    final bool Function(Object? e1, Object? e2) mapEquals =
        const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => id.hashCode;
}
