import 'package:dartz/dartz.dart';
import 'package:formify/data/data_source/gemini_remote_data_source.dart';
import 'package:formify/data/network/error_handler.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/data/network/network_info.dart';
import 'package:formify/domain/repostitory/statistics_repository.dart';

class RepositoryAiImp implements RepositoryAi {
  final GeminiRemoteDataSource _remoteDataSource;

  final NetworkInfo _networkInfo;

  RepositoryAiImp(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, String>> getAiResponse(String prompt) async {
    try {
      if (await _networkInfo.isConnected) {
        final response = await _remoteDataSource.getAiResponse(prompt);
          return Right(response??"يوجد خطأ بالبيانات");

      } else {
        return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
      }
    } catch (error) {
      Failure failure = ErrorHandler
          .handle(error)
          .failure;
      return Left(failure);
    }
  }
}