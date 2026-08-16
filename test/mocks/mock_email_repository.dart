import 'package:anartiststore/model/cart.dart';
import 'package:anartiststore/model/contact_info.dart';
import 'package:anartiststore/model/email_repository.dart';

class MockEmailRepository implements EmailRepository {
  @override
  Future<void> sendOrderEmail({
    required Cart cart,
    required ContactInfo contactInfo,
    required String currencyCode,
  }) async {}
}
