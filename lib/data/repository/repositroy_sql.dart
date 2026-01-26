import 'package:dartz/dartz.dart';
import 'package:formify/data/network/app_sql_api.dart';
import 'package:formify/data/network/error_handler.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
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
  Future<Either<Failure, AllUserModel>> getDataSql() async {
    try {
      final response = await _databaseHelper.getDataSql();
      return Right(response);
    } catch (e) {
      Failure failure = ErrorHandler.handle(e).failure;
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, GetAllConferenceModel>> getConference() async {
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
}
