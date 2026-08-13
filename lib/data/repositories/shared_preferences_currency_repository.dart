import 'package:anartiststore/enums/currency.dart';
import 'package:anartiststore/model/currency_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesCurrencyRepository implements CurrencyRepository {
  static const String _kCurrencyKey = 'selected_currency_code';

  @override
  Future<Currency> getSelectedCurrency() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? code = prefs.getString(_kCurrencyKey);
    if (code == null) {
      return Currency.eur;
    }
    return Currency.fromCode(code);
  }

  @override
  Future<void> saveSelectedCurrency(Currency currency) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kCurrencyKey, currency.code);
  }
}
