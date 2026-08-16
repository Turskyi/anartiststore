import 'package:anartiststore/model/contact_repository.dart';

class MockContactRepository implements ContactRepository {
  @override
  Future<void> sendContactMessage({
    required String name,
    required String email,
    required String message,
    required String currencyCode,
  }) async {}
}
