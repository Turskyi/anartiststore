import 'package:anartiststore/data/remote/models/currency_response/currency_response.dart';
import 'package:anartiststore/res/values/constants.dart' as constants;
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'currency_rest_client.g.dart';

@RestApi(baseUrl: constants.exchangeRateBaseUrl)
abstract class CurrencyRestClient {
  factory CurrencyRestClient(Dio dio, {String baseUrl}) = _CurrencyRestClient;

  @GET('{currencyCode}')
  Future<CurrencyResponse> getExchangeRates(
    @Path('currencyCode') String currencyCode,
  );
}
