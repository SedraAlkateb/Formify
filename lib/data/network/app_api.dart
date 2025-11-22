import 'package:formify/app/constants.dart';
import 'package:dio/dio.dart';
import 'package:formify/data/responses/responses.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
part 'app_api.g.dart';
@RestApi(baseUrl: Constants.baseUrl)
abstract class AppServiceClient {
  factory AppServiceClient(Dio dio, {String baseUrl}) = _AppServiceClient;

  @POST("/loginU.php")
  Future<LoginResponse> login(
      @Part(name: "userName") String userName,
      @Part(name: "password") String password,
      @Part(name: "ver") int ver,
      );
}