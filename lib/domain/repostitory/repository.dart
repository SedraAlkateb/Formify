import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/request.dart';

abstract class Repository {
  Future<Either<Failure, CreateSurveyModel>> createSurvey(SurveyRequest survey);
  Future<Either<Failure, Null>> createSurveyQuestionsAndAnswers(
    SurveyQuestionAndAnswersModel surveyQ,     List<File>images
  );
 Future<Either<Failure, List<MainSurveyModel>>> getAllSurvey();
  Future<Either<Failure,int>> createConference(ConferenceModel conference);
 Future<Either<Failure, SurveyModel>> getSurveyWithQuestionById(int id);
  Future<Either<Failure,List<GetAllConferenceModel>>> getAllConference(int isActive);
  Future<Either<Failure,Null>> linkSurveyConference(SurveyConference surveyConference);
  Future<Either<Failure,Null>>deleteConference(int id);
  Future<Either<Failure,GetAllConferenceByIdModel>> getConferenceById(int id);
  Future<Either<Failure,int>>createUserWithConferenceId(  UserInputModel userInputModel,);
  Future<Either<Failure,GetAsyncModel>> getAllInformationConference(int id);
  Future<Either<Failure,List<IsActiveMainSurveyModel>>>  getAllSurveyAndActiveSurvey(int conferenceId);
  Future<Either<Failure,List<UserModel>>>  getUsersByConferenceId(int conferenceId);
  Future<Either<Failure,Null>>  synchronizeUsersAnswers(AllUserModel userRequest,);
  Future<Either<Failure, SurveyUserModel>> getUserAnswersForSpecificSurvey(int id, int user_id) ;
  Future<Either<Failure,Null>>  login(LoginRequest loginRequest);

}
