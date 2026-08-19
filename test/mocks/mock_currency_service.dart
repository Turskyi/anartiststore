import 'package:anartiststore/data/remote/currency_service.dart';
import 'package:anartiststore/enums/currency.dart';

class MockCurrencyService implements CurrencyService {
  @override
  Future<Map<Currency, double>> fetchExchangeRates() async =>
      <Currency, double>{Currency.eur: 1.0};
}
