import 'package:anartiststore/data/remote/retrofit_client/retrofit_rest_client.dart';
import 'package:anartiststore/model/contact_repository.dart';
import 'package:anartiststore/model/email/email.dart';

class ContactRepositoryImpl implements ContactRepository {
  const ContactRepositoryImpl(this._restClient);

  final RetrofitRestClient _restClient;

  @override
  Future<void> sendContactMessage({
    required String name,
    required String email,
    required String message,
    required String currencyCode,
  }) async {
    final String formattedMessage =
        'New contact message received:\n\n'
        'Name: $name\n'
        'Email: $email\n\n'
        'Message: $message';

    await _restClient.send(
      Email(
        email: email,
        subject: 'Contact Message from $name',
        message: formattedMessage,
        currency: currencyCode,
      ),
    );
  }
}
