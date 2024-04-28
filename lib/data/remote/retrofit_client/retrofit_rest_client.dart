import 'package:anartiststore/data/remote/models/email_response/email_response.dart';
import 'package:anartiststore/data/remote/models/product_catalog_response/product_catalog_response/product_catalog_response.dart';
import 'package:anartiststore/model/email/email.dart';
import 'package:anartiststore/res/values/constants.dart' as constants;
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

part 'retrofit_rest_client.g.dart';

@RestApi(baseUrl: constants.baseUrl)
abstract class RetrofitRestClient {
  factory RetrofitRestClient(Dio dio, {String baseUrl}) = _RetrofitRestClient;

  @GET('/products')
  Future<ProductCatalogResponse> getProductCatalog({
    @Query('page') String? page,
  });

  @POST('/email')
  @Headers(<String, dynamic>{'Content-Type': 'application/json'})
  Future<EmailResponse> email(@Body() Email email);

  @POST('/order')
  @Headers(<String, dynamic>{'Content-Type': 'application/json'})
  Future<EmailResponse> order(@Body() Email email);

  @POST('/send')
  @Headers(<String, dynamic>{'Content-Type': 'application/json'})
  Future<EmailResponse> send(@Body() Email email);
}
