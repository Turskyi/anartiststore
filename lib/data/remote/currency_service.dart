import 'package:anartiststore/data/remote/models/currency_response/currency_response.dart';
import 'package:anartiststore/data/remote/retrofit_client/currency_rest_client.dart';
import 'package:anartiststore/enums/currency.dart';
import 'package:flutter/foundation.dart';

class CurrencyService {
  CurrencyService(this._client);

  final CurrencyRestClient _client;
  Map<Currency, double>? _cachedRates;

  Future<Map<Currency, double>> fetchExchangeRates() async {
    final Map<Currency, double>? cachedRates = _cachedRates;
    if (cachedRates != null) {
      return cachedRates;
    }

    try {
      final CurrencyResponse response = await _client.getExchangeRates(
        Currency.eur.code,
      );

      final Map<Currency, double> parsedRates = <Currency, double>{};
      for (final Currency currency in Currency.values) {
        final double? rate = response.rates[currency.code];
        parsedRates[currency] = rate ?? 1.0;
      }
      _cachedRates = parsedRates;
      return parsedRates;
    } catch (e) {
      debugPrint('Error fetching exchange rates: $e');
      return <Currency, double>{Currency.eur: 1.0};
    }
  }
}
