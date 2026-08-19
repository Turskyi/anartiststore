import 'package:json_annotation/json_annotation.dart';

part 'currency_response.g.dart';

@JsonSerializable()
class CurrencyResponse {
  const CurrencyResponse({
    required this.rates,
    required this.base,
    required this.date,
  });

  factory CurrencyResponse.fromJson(Map<String, Object?> json) =>
      _$CurrencyResponseFromJson(json);

  final Map<String, double> rates;
  final String base;
  final String date;

  Map<String, Object?> toJson() => _$CurrencyResponseToJson(this);

  @override
  String toString() {
    return 'CurrencyResponse(rates: $rates, base: $base, date: $date)';
  }
}
