import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import 'email_id.dart';

part 'email_response.g.dart';

@JsonSerializable()
class EmailResponse {
  const EmailResponse({this.emailId, this.error});

  factory EmailResponse.fromJson(Map<String, dynamic> json) {
    return _$EmailResponseFromJson(json);
  }

  @JsonKey(name: 'data')
  final EmailId? emailId;
  final dynamic error;

  @override
  String toString() => 'EmailResponse(emailId: $emailId, error: $error)';

  Map<String, dynamic> toJson() => _$EmailResponseToJson(this);

  EmailResponse copyWith({
    EmailId? emailId,
    dynamic error,
  }) {
    return EmailResponse(
      emailId: emailId ?? this.emailId,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! EmailResponse) return false;
    final bool Function(Object? e1, Object? e2) mapEquals =
        const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => emailId.hashCode ^ error.hashCode;
}
