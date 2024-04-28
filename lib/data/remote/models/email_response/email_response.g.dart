// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmailResponse _$EmailResponseFromJson(Map<String, dynamic> json) =>
    EmailResponse(
      emailId: json['data'] == null
          ? null
          : EmailId.fromJson(json['data'] as Map<String, dynamic>),
      error: json['error'],
    );

Map<String, dynamic> _$EmailResponseToJson(EmailResponse instance) =>
    <String, dynamic>{
      'data': instance.emailId,
      'error': instance.error,
    };
