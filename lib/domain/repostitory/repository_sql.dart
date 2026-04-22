
import 'package:dartz/dartz.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';

abstract class RepositorySql {
  Future<Either<Failure, String>> asyncData(GetAsyncModel asyncData);
  Future<Either<Failure, void>>  deleteData();
  Future<Either<Failure, List<UserSqlModel>>> getDataSql();
  Future<Either<Failure, GetAllConferenceModel?>>getConference();
  Future<Either<Failure, List<MainSurveyModel>>>getSurveys();
  Future<Either<Failure, List<QuestionModel>>>getSurveyQuestionsWithAnswers(int surveyId);
  Future<Either<Failure, void>>  insertUserWithAnswer(UserSqlModel user);
  Future<Either<Failure, InfoConference>>  getConferenceInfo();
  Future<Either<Failure, void>>  deleteUser();
  Future<Either<Failure, List<DoctorsModel>>>  getDoctors();
  Future<Either<Failure,Map<String, DoctorsModel>>>  getDoctorsAsMap();

}
