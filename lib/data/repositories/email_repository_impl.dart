import 'package:anartiststore/data/remote/retrofit_client/retrofit_rest_client.dart';
import 'package:anartiststore/model/cart.dart';
import 'package:anartiststore/model/cart_item.dart';
import 'package:anartiststore/model/contact_info.dart';
import 'package:anartiststore/model/email/email.dart';
import 'package:anartiststore/model/email_repository.dart';
import 'package:anartiststore/res/values/constants.dart' as constants;
import 'package:intl/intl.dart';

class EmailRepositoryImpl implements EmailRepository {
  const EmailRepositoryImpl(this._restClient);

  final RetrofitRestClient _restClient;

  @override
  Future<void> sendOrderEmail({
    required Cart cart,
    required ContactInfo contactInfo,
  }) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
      decimalDigits: 2,
      locale: 'en_US',
    );
    final String email = contactInfo.email;
    const String subject = 'New Order Received from ${constants.appName}';
    // Format the order details into a message.
    final String message = 'Order:\n\n${cart.items.map((CartItem item) {
      final String productName = item.product.name;
      final int quantity = item.quantity;
      final int priceInCents = item.product.priceInCents;
      return 'Cart Item ID: ${item.id}\n'
          'Product Name: $productName\n'
          'Quantity: $quantity\n'
          'Price: ${_formatPrice(priceInCents)}\n';
    }).join('')}\n'
        'Tax: ${formatter.format(cart.tax)}\n\n'
        'Shipping Cost: ${formatter.format(cart.shippingCost)}\n\n'
        'Subtotal: ${formatter.format(cart.subtotalCost)}\n\n'
        'Total: ${formatter.format(cart.totalCost)}\n\n'
        'User Email: ${contactInfo.email}\n'
        'User Name: ${contactInfo.firstName} ${contactInfo.lastName}\n'
        'User Phone: ${contactInfo.phoneNumber}\n'
        'User Street: ${contactInfo.street}\n'
        'User City: ${contactInfo.city}\n'
        'User Postal code: ${contactInfo.postalCode}\n'
        'User Country: ${contactInfo.country}';
    return _restClient
        .order(Email(email: email, subject: subject, message: message));
  }

  String _formatPrice(int priceInCents) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'en_US');
    return formatter.format(priceInCents / 100);
  }
}
