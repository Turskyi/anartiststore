import 'package:json_annotation/json_annotation.dart';

part 'email.g.dart';

/// Request example:
/// {
///  "email": "example@something.something",
///  "subject": "Example",
///  "message": "Example"
/// }
@JsonSerializable(createFactory: false)
class Email {
  const Email({
    required this.email,
    required this.subject,
    required this.message,
  });

  final String email;
  final String subject;
  final String message;

  Map<String, Object?> toJson() => _$EmailToJson(this);

  @override
  String toString() {
    return 'Email{email: $email, subject: $subject, message: $message}';
  }
}
