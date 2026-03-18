import 'dart:io';

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
  Future<Either<Failure, CreateSurveyModel>> createSurvey(
    SurveyRequest survey,
  ) async {
    try {
      if (await _networkInfo.isConnected) {
        final response = await _remoteDataSource.createSurvey(survey);

        if (response.status == "200" ||
            response.status == ApiInternalStatus.SUCCESS) {
          return Right(response.toDomain());
        } else {
          Failure failure = Failure(
            ApiInternalStatus.FAILURE,
            response.message ?? ResponseMassage.DEFAULT,
          );
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
  Future<Either<Failure, Null>> createSurveyQuestionsAndAnswers(
    SurveyQuestionAndAnswersModel surveyQ,
    List<File> images,
  ) async {
    try {
      if (await _networkInfo.isConnected) {
        final response = await _remoteDataSource
            .createSurveyQuestionsAndAnswers(surveyQ, images);

        if (response.status == "200" ||
            response.status == ApiInternalStatus.SUCCESS) {
          return Right(null);
        } else {
          Failure failure = Failure(
            ApiInternalStatus.FAILURE,
            response.message ?? ResponseMassage.DEFAULT,
          );
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
          Failure failure = Failure(
            ApiInternalStatus.FAILURE,
            response.message ?? ResponseMassage.DEFAULT,
          );
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
  Future<Either<Failure, int>> createConference(
    ConferenceModel conference,
  ) async {
    try {
      if (await _networkInfo.isConnected) {
        final response = await _remoteDataSource.createConference(conference);

        if (response.status == "200" ||
            response.status == ApiInternalStatus.SUCCESS) {
          return Right(response.data.id ?? 0);
        } else {
          Failure failure = Failure(
            ApiInternalStatus.FAILURE,
            response.message ?? ResponseMassage.DEFAULT,
          );
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
  Future<Either<Failure, List<GetAllConferenceModel>>> getAllConference(
    int isActive,
  ) async {
    try {
      if (await _networkInfo.isConnected) {
        final response = await _remoteDataSource.getAllConference(isActive);

        if (response.status == "200" ||
            response.status == ApiInternalStatus.SUCCESS) {
          return Right(response.toDomain());
        } else {
          Failure failure = Failure(
            ApiInternalStatus.FAILURE,
            response.message ?? ResponseMassage.DEFAULT,
          );
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
  Future<Either<Failure, Null>> linkSurveyConference(
    SurveyConference surveyConference,
  ) async {
    try {
      if (await _networkInfo.isConnected) {
        final response = await _remoteDataSource.linkSurveyConference(
          surveyConference,
        );

        if (response.status == "200" ||
            response.status == ApiInternalStatus.SUCCESS) {
          return Right(null);
        } else {
          Failure failure = Failure(
            ApiInternalStatus.FAILURE,
            response.message ?? ResponseMassage.DEFAULT,
          );
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
  Future<Either<Failure, Null>> deleteConference(int id) async {
    try {
      if (await _networkInfo.isConnected) {
        final response = await _remoteDataSource.deleteConference(id);

        if (response.status == "200" ||
            response.status == ApiInternalStatus.SUCCESS) {
          return Right(null);
        } else {
          Failure failure = Failure(
            ApiInternalStatus.FAILURE,
            response.message ?? ResponseMassage.DEFAULT,
          );
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
  Future<Either<Failure, GetAllConferenceByIdModel>> getConferenceById(
    int id,
  ) async {
    try {
      if (await _networkInfo.isConnected) {
        final response = await _remoteDataSource.getConferenceById(id);

        if (response.status == "200" ||
            response.status == ApiInternalStatus.SUCCESS) {
          return Right(response.toDomain());
        } else {
          Failure failure = Failure(
            ApiInternalStatus.FAILURE,
            response.message ?? ResponseMassage.DEFAULT,
          );
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
  Future<Either<Failure, int>> createUserWithConferenceId(
    UserInputModel userInputModel,
  ) async {
    try {
      if (await _networkInfo.isConnected) {
        final response = await _remoteDataSource.createUserWithConferenceId(
          userInputModel,
        );

        if (response.status == "200" ||
            response.status == ApiInternalStatus.SUCCESS) {
          return Right(response.user_id ?? 0);
        } else {
          Failure failure = Failure(
            ApiInternalStatus.FAILURE,
            response.message ?? ResponseMassage.DEFAULT,
          );
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
  Future<Either<Failure, SurveyModel>> getSurveyWithQuestionById(int id) async {
    try {
      if (await _networkInfo.isConnected) {
        final response = await _remoteDataSource.getSurveyWithQuestionById(id);

        if (response.status == "200" ||
            response.status == ApiInternalStatus.SUCCESS) {
          return Right(response.toDomain());
        } else {
          Failure failure = Failure(
            ApiInternalStatus.FAILURE,
            response.message ?? ResponseMassage.DEFAULT,
          );
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
  Future<Either<Failure, GetAsyncModel>> getAllInformationConference(
    int id,
  ) async {
    try {
      if (await _networkInfo.isConnected) {
        final response = await _remoteDataSource.getAllInformationConference(
          id,
        );

        if (response.status == "200" ||
            response.status == ApiInternalStatus.SUCCESS) {
          return Right(response.toDomain());
        } else {
          Failure failure = Failure(
            ApiInternalStatus.FAILURE,
            response.message ?? ResponseMassage.DEFAULT,
          );
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
  Future<Either<Failure, List<IsActiveMainSurveyModel>>>
  getAllSurveyAndActiveSurvey(int conferenceId) async {
    try {
      if (await _networkInfo.isConnected) {
        final response = await _remoteDataSource.getAllSurveyAndActiveSurvey(
          conferenceId,
        );

        if (response.status == "200" ||
            response.status == ApiInternalStatus.SUCCESS) {
          return Right(response.toDomain());
        } else {
          Failure failure = Failure(
            ApiInternalStatus.FAILURE,
            response.message ?? ResponseMassage.DEFAULT,
          );
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
  Future<Either<Failure, List<UserModel>>> getUsersByConferenceId(
    int conferenceId,
  ) async {
    try {
      if (await _networkInfo.isConnected) {
        final response = await _remoteDataSource.getUsersByConferenceId(
          conferenceId,
        );

        if (response.status == "200" ||
            response.status == ApiInternalStatus.SUCCESS) {
          return Right(response.toDomain());
        } else {
          Failure failure = Failure(
            ApiInternalStatus.FAILURE,
            response.message ?? ResponseMassage.DEFAULT,
          );
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
  Future<Either<Failure, Null>> synchronizeUsersAnswers(
    AllUserModel userRequest,
  ) async {
    try {
      if (await _networkInfo.isConnected) {
        final response = await _remoteDataSource.synchronizeUsersAnswers(
          userRequest,
        );

        if (response.status == "200" ||
            response.status == ApiInternalStatus.SUCCESS) {
          return Right(null);
        } else {
          Failure failure = Failure(
            ApiInternalStatus.FAILURE,
            response.message ?? ResponseMassage.DEFAULT,
          );
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
  Future<Either<Failure, SurveyUserModel>> getUserAnswersForSpecificSurvey(
    int id,
    int user_id,
  ) async {
    try {
      if (await _networkInfo.isConnected) {
        final response = await _remoteDataSource
            .getUserAnswersForSpecificSurvey(id, user_id);

        if (response.status == "200" ||
            response.status == ApiInternalStatus.SUCCESS) {
          return Right(response.toDomain());
        } else {
          Failure failure = Failure(
            ApiInternalStatus.FAILURE,
            response.message ?? ResponseMassage.DEFAULT,
          );
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
  Future<Either<Failure, Null>> login(LoginRequest loginRequest) async {
    try {
      if (await _networkInfo.isConnected) {
        final response = await _remoteDataSource.login(loginRequest);

        if (response.status == "200" ||
            response.status == ApiInternalStatus.SUCCESS) {
          return Right(null);
        } else {
          Failure failure = Failure(
            ApiInternalStatus.FAILURE,
            response.message ?? ResponseMassage.DEFAULT,
          );
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
  Future<Either<Failure, Null>> updateConference(
    int id,
    ConferenceModel update,
  ) async {
    try {
      if (await _networkInfo.isConnected) {
        final response = await _remoteDataSource.updateConference(id, update);

        if (response.status == "200" ||
            response.status == ApiInternalStatus.SUCCESS) {
          return Right(null);
        } else {
          Failure failure = Failure(
            ApiInternalStatus.FAILURE,
            response.message ?? ResponseMassage.DEFAULT,
          );
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
  Future<Either<Failure, Null>> updateSurvey(UpdateSurveyRequest update) async {
    try {
      if (await _networkInfo.isConnected) {
        final response = await _remoteDataSource.updateSurvey(update);

        if (response.status == "200" ||
            response.status == ApiInternalStatus.SUCCESS) {
          return Right(null);
        } else {
          Failure failure = Failure(
            ApiInternalStatus.FAILURE,
            response.message ?? ResponseMassage.DEFAULT,
          );
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
  Future<Either<Failure, ExelModel>> statisticsForUsersAnswers(
    int surveyId,
  ) async {
    try {
      if (await _networkInfo.isConnected) {
        final response = await _remoteDataSource.statisticsForUsersAnswers(
          surveyId,
        );

        if (response.status == "200" ||
            response.status == ApiInternalStatus.SUCCESS) {
          return Right(response.toDomain());
        } else {
          Failure failure = Failure(
            ApiInternalStatus.FAILURE,
            response.message ?? ResponseMassage.DEFAULT,
          );
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
  Future<Either<Failure, StatisticsModel>>
  getStatisticsForQuestionTypes(int surveyId, int conferenceId) async {
    try {
      if (await _networkInfo.isConnected) {
        final response = await _remoteDataSource.getStatisticsForQuestionTypes(
          surveyId,conferenceId
        );

        if (response.status == "200" ||
            response.status == ApiInternalStatus.SUCCESS) {
          return Right(response.toDomain());
        } else {
          Failure failure = Failure(
            ApiInternalStatus.FAILURE,
            response.message ?? ResponseMassage.DEFAULT,
          );
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
  Future<Either<Failure, bool>> checkPassword(String password) async {
    try {
      if (await _networkInfo.isConnected) {
        final response = await _remoteDataSource.checkPassword(password);
        return Right(response.success);
      } else {
        return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
      }
    } catch (error) {
      Failure failure = ErrorHandler.handle(error).failure;
      return Left(failure);
    }
  }
}
