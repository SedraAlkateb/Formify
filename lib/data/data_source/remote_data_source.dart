import 'package:formify/data/network/app_api.dart';
import 'package:formify/data/responses/responses.dart';

abstract class RemoteDataSource {

  Future<LoginResponse> login(int loginRequest);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final AppServiceClient _appServiceClient;

  RemoteDataSourceImpl(this._appServiceClient);

  @override
  Future<LoginResponse> login(int loginRequest) async {
    return await _appServiceClient.login(
       "6","7",7);
  }

}
