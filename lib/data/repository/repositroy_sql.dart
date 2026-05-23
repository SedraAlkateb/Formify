import 'package:dartz/dartz.dart';
import 'package:formify/data/network/app_sql_api.dart';
import 'package:formify/data/network/error_handler.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/user_type.dart';
import 'package:formify/domain/repostitory/repository_sql.dart';

class RepositroySqlImp extends RepositorySql {
  final AppSqlApi _databaseHelper;

  RepositroySqlImp(this._databaseHelper);

  @override
  Future<Either<Failure, String>> asyncData(GetAsyncModel asyncData)async {
    try {
      final response = await _databaseHelper.asyncData(asyncData);
      return Right(response);
    } catch (e) {
      Failure failure = ErrorHandler.handle(e).failure;
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, void>> deleteData() async {
    try {
      final response = await _databaseHelper.deleteData();
      return Right(response);
    } catch (e) {
      Failure failure = ErrorHandler.handle(e).failure;
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, List<UserSqlModel>>> getDataSql() async {
    try {
      final response = await _databaseHelper.getDataSql();
      return Right(response);
    } catch (e) {
      Failure failure = ErrorHandler.handle(e).failure;
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, GetAllConferenceModel?>> getConference() async {
    try {
      final response = await _databaseHelper.getConference();
      return Right(response);
    } catch (e) {
      Failure failure = ErrorHandler.handle(e).failure;
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, List<MainSurveyModel>>> getSurveys() async {
    try {
      final response = await _databaseHelper.getSurveys();
      return Right(response);
    } catch (e) {
      Failure failure = ErrorHandler.handle(e).failure;
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, List<QuestionModel>>> getSurveyQuestionsWithAnswers(int surveyId) async {
    try {
      final response = await _databaseHelper.getSurveyQuestionsWithAnswers(surveyId);
      return Right(response);
    } catch (e) {
      Failure failure = ErrorHandler.handle(e).failure;
      return Left(failure);
    }
  }


  @override
  Future<Either<Failure, void>> insertUserWithAnswer(UserSqlModel user)  async {
    try {
      final response =await _databaseHelper.insertUserWithAnswer(user);
      return Right(response);
    } catch (e) {
      Failure failure = ErrorHandler.handle(e).failure;
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, InfoConference>> getConferenceInfo()  async {
    try {
      final response =await _databaseHelper.getConferenceInfo();
      return Right(response);
    } catch (e) {
      Failure failure = ErrorHandler.handle(e).failure;
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser()  async {
    try {
      final response =await _databaseHelper.deleteUser();
      return Right(response);
    } catch (e) {
      Failure failure = ErrorHandler.handle(e).failure;
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, List<UserModel>>> getDoctors() async {
    try {
      final response =await _databaseHelper.getDoctors();
      return Right(response);
    } catch (e) {
      Failure failure = ErrorHandler.handle(e).failure;
      return Left(failure);
    }
  }


  @override
  Future<Either<Failure, void>> insertDoctor( UserModel doctor)async {
    try {
      final response =await _databaseHelper.insertDoctor(doctor);
      return Right(response);
    } catch (e) {
      Failure failure = ErrorHandler.handle(e).failure;
      return Left(failure);
    }
  }

@override
Future<Either<Failure, List<UserModel>>> getUserConference(int conferenceId)async {
  try {
    final response =await _databaseHelper.getUserConference(conferenceId);
    return Right(response);
  } catch (e) {
    Failure failure = ErrorHandler.handle(e).failure;
    return Left(failure);
  }
}
  @override
  Future<Either<Failure, void>> updateUser(UserModel user)async {
    try {
      final response =await _databaseHelper.updateUser(user);
      return Right(response);
    } catch (e) {
      Failure failure = ErrorHandler.handle(e).failure;
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, void>> insertAllUsers(List<UserModel> users) async {
    try {
      final response = await _databaseHelper.insertAllUsers(users);
      return Right(response);
    } catch (e) {
      Failure failure = ErrorHandler
          .handle(e)
          .failure;
      return Left(failure);
    }
  }

@override
Future<Either<Failure, List<UserModel>>> getAllImportantDoctorNotCome(List<UserModel> users) async {
  try {
    final response = await _databaseHelper.getAllImportantDoctorNotCome(users);
    return Right(response);
  } catch (e) {
    Failure failure = ErrorHandler
        .handle(e)
        .failure;
    return Left(failure);
  }
}

  @override
  Future<Either<Failure, List<DoctorMockItem>>> refreshAndSyncUsers() async {
    try {
      final response = await _databaseHelper.refreshAndSyncUsers();
      return Right(response);
    } catch (e) {
      Failure failure = ErrorHandler
          .handle(e)
          .failure;
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, void>> updateIsDone(int isDone, int doctorId) async {
    try {
      final response = await _databaseHelper.updateIsDone(isDone,doctorId);
      return Right(response);
    } catch (e) {
      Failure failure = ErrorHandler
          .handle(e)
          .failure;
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, AddAndModifyUsersRequest>> getUserAddAndModify() async {
    try {
      final response = await _databaseHelper.getUserAddAndModify();
      return Right(response);
    } catch (e) {
      Failure failure = ErrorHandler
          .handle(e)
          .failure;
      return Left(failure);
    }
  }
  @override
  Future<Either<Failure, void>> addServerIdToUser(List<AddModifyUser>syncedUsers) async {
    try {
      final response = await _databaseHelper.addServerIdToUser(syncedUsers);
      return Right(response);
    } catch (e) {
      Failure failure = ErrorHandler
          .handle(e)
          .failure;
      return Left(failure);
    }
  }
  @override
  Future<Either<Failure,SyncUsersRequest>>getConferenceAndAnswers(int conferenceId)  async {
    try {
      final response = await _databaseHelper.getConferenceAndAnswers(conferenceId);
      return Right(response);
    } catch (e) {
      Failure failure = ErrorHandler
          .handle(e)
          .failure;
      return Left(failure);
    }
  }
  @override
  Future<Either<Failure,void>>deleteSyncData() async {
    try {
      final response = await _databaseHelper.deleteSyncData();
      return Right(response);
    } catch (e) {
      Failure failure = ErrorHandler
          .handle(e)
          .failure;
      return Left(failure);
    }
  }
  @override
  Future<Either<Failure,void>>addSyncData(SaveDataBaseModel baseData) async {
    try {
      final response = await _databaseHelper.addSyncData(baseData);
      return Right(response);
    } catch (e) {
      Failure failure = ErrorHandler
          .handle(e)
          .failure;
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, List<SpecModel>>> getSpec() async {
    try {
      final response = await _databaseHelper.getSpec();
      return Right(response);
    } catch (e) {
      Failure failure = ErrorHandler
          .handle(e)
          .failure;
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure,List<UserModel>>>getUsersBySpecIdAndName(int specId, String name) async {
    try {
      final response = await _databaseHelper.getUsersBySpecIdAndName(specId,name);

      return Right(response);
    } catch (e) {
      Failure failure = ErrorHandler
          .handle(e)
          .failure;
      return Left(failure);
    }
  }

}
