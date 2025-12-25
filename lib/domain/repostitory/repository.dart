import 'package:dartz/dartz.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/request.dart';

abstract class Repository {
  Future<Either<Failure, CreateSurveyModel>> createSurvey(SurveyRequest survey);
  Future<Either<Failure, Null>> createSurveyQuestionsAndAnswers(
    SurveyQuestionAndAnswersModel surveyQ,
  );
 Future<Either<Failure, List<MainSurveyModel>>> getAllSurvey();
  Future<Either<Failure,int>> createConference(ConferenceModel conference);
// Future<Either<Failure, LoginModel>> getSurveyWithQuestionById(int id);
  Future<Either<Failure,List<GetAllConferenceModel>>> getAllConference(bool isActive);
}
