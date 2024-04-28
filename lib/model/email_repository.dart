import 'package:anartiststore/model/cart.dart';
import 'package:anartiststore/model/contact_info.dart';

abstract interface class EmailRepository {
  const EmailRepository();

  Future<void> sendOrderEmail({
    required Cart cart,
    required ContactInfo contactInfo,
  });
}
