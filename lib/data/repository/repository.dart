import 'package:dartz/dartz.dart';
import 'package:formify/data/mapper/mapper.dart';
import 'package:formify/data/data_source/remote_data_source.dart';
import 'package:formify/data/network/error_handler.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/data/network/network_info.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository.dart';

class RepositoryImp implements Repository {
  final RemoteDataSource _remoteDataSource;

  final NetworkInfo _networkInfo;

  RepositoryImp(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, LoginModel>> login(int loginRequest) async {
    try {
      if (await _networkInfo.isConnected) {
        final response = await _remoteDataSource.login(loginRequest);

        if (response.status == "200" ||
            response.status == ApiInternalStatus.SUCCESS) {
          return Right(response.toDomain());
        } else {
          Failure failure = Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMassage.DEFAULT);
          return Left(failure);

          // return Left(Failure(ApiInternalStatus.FAILURE,
          //     response.message ?? ResponseMassage.DEFAULT));
        }
      } else {
        return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
      }
    } catch (error) {
      Failure failure = ErrorHandler.handle(error).failure;
      return Left(failure);
    }
  }
}