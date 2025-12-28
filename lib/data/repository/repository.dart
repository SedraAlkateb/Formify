import 'package:dartz/dartz.dart';
import 'package:formify/data/mapper/mapper.dart';
import 'package:formify/data/data_source/remote_data_source.dart';
import 'package:formify/data/network/error_handler.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/data/network/network_info.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/request.dart';
import 'package:formify/domain/repostitory/repository.dart';

class RepositoryImp implements Repository {
  final RemoteDataSource _remoteDataSource;

  final NetworkInfo _networkInfo;

  RepositoryImp(this._remoteDataSource, this._networkInfo);


  @override
  Future<Either<Failure, CreateSurveyModel>> createSurvey(SurveyRequest survey) async {
    try {
      if (await _networkInfo.isConnected) {
        final response = await _remoteDataSource.createSurvey(survey);

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
  @override
  Future<Either<Failure, Null>> createSurveyQuestionsAndAnswers(SurveyQuestionAndAnswersModel surveyQ) async {
    try {
      if (await _networkInfo.isConnected) {
        final response = await _remoteDataSource.createSurveyQuestionsAndAnswers(surveyQ);

        if (response.status == "200" ||
            response.status == ApiInternalStatus.SUCCESS) {
          return Right(null);
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

  @override
  Future<Either<Failure, List<MainSurveyModel>>> getAllSurvey() async {
    try {
      if (await _networkInfo.isConnected) {
        final response = await _remoteDataSource.getAllSurvey();

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

  @override
  Future<Either<Failure, int>> createConference(ConferenceModel conference) async {
    try {
      if (await _networkInfo.isConnected) {
        final response = await _remoteDataSource.createConference(conference);

        if (response.status == "200" ||
            response.status == ApiInternalStatus.SUCCESS) {
          return Right(response.data.id??0);
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

  @override
  Future<Either<Failure, List<GetAllConferenceModel>>> getAllConference(int isActive)
  async {
    try {
      if (await _networkInfo.isConnected) {
        final response = await _remoteDataSource.getAllConference(isActive);

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