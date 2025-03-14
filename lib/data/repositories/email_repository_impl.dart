import 'package:anartiststore/data/remote/retrofit_client/retrofit_rest_client.dart';
import 'package:anartiststore/model/cart.dart';
import 'package:anartiststore/model/cart_item.dart';
import 'package:anartiststore/model/contact_info.dart';
import 'package:anartiststore/model/email/email.dart';
import 'package:anartiststore/model/email_repository.dart';
import 'package:anartiststore/res/values/constants.dart' as constants;
import 'package:flutter/foundation.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart' as sender;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailRepositoryImpl implements EmailRepository {
  const EmailRepositoryImpl(this._restClient);

  final RetrofitRestClient _restClient;

  @override
  Future<void> sendOrderEmail({
    required Cart cart,
    required ContactInfo contactInfo,
  }) async {
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
    try {
      await _restClient.order(
        Email(email: email, subject: subject, message: message),
      );
    } catch (error, stackTrace) {
      final String errorMessage = 'Error sending order email via API: $error';
      debugPrint('$errorMessage\nStackTrace: $stackTrace');
      if (kIsWeb) {
        final Uri emailLaunchUri = Uri(
          scheme: 'mailto',
          path: constants.adminEmail,
          queryParameters: <String, Object?>{
            'subject': subject,
            'body': message,
          },
        );
        try {
          if (await canLaunchUrl(emailLaunchUri)) {
            await launchUrl(emailLaunchUri);
            debugPrint('Email launched successfully via url_launcher.');
          } else {
            throw 'Could not launch email with url_launcher.';
          }
        } catch (urlLauncherError, urlLauncherStackTrace) {
          final String urlLauncherErrorMessage =
              'Error launching email via url_launcher: $urlLauncherError';
          debugPrint(
            '$urlLauncherErrorMessage\nStackTrace: $urlLauncherStackTrace',
          );
        }
      } else {
        final sender.Email email = sender.Email(
          subject: subject,
          body: message,
          recipients: <String>[constants.supportEmail, constants.adminEmail],
        );
        try {
          await sender.FlutterEmailSender.send(email);
          debugPrint('Order email sent successfully via fallback method.');
        } catch (fallbackError, fallbackStackTrace) {
          final String fallbackErrorMessage = 'Fallback email failed: '
              '$fallbackError';
          debugPrint('$fallbackErrorMessage\nStackTrace: $fallbackStackTrace');
        }
      }
    }
  }

  String _formatPrice(int priceInCents) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'en_US');
    return formatter.format(priceInCents / 100);
  }
}
