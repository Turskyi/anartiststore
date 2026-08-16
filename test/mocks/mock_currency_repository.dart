import 'package:anartiststore/enums/currency.dart';
import 'package:anartiststore/model/currency_repository.dart';

class MockCurrencyRepository implements CurrencyRepository {
  @override
  Future<Currency> getSelectedCurrency() async => Currency.eur;

  @override
  Future<void> saveSelectedCurrency(Currency currency) async {}
}
