import 'package:anartiststore/data/remote/models/product_catalog_response/product_catalog_response/product_catalog_response.dart';
import 'package:anartiststore/res/values/constants.dart' as constants;
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'retrofit_rest_client.g.dart';

@RestApi(baseUrl: constants.baseUrl)
abstract class RetrofitRestClient {
  factory RetrofitRestClient(Dio dio, {String baseUrl}) = _RetrofitRestClient;

  @GET('/products')
  Future<ProductCatalogResponse> getProductCatalog({
    @Query('page') String? page,
  });
}
