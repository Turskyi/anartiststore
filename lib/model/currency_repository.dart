import 'package:anartiststore/enums/currency.dart';

abstract interface class CurrencyRepository {
  const CurrencyRepository();

  Future<Currency> getSelectedCurrency();

  Future<void> saveSelectedCurrency(Currency currency);
}
