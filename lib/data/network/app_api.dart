import 'dart:io';

import 'package:formify/app/constants.dart';
import 'package:dio/dio.dart';
import 'package:formify/data/responses/responses.dart';
import 'package:formify/domain/models/models.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
part 'app_api.g.dart';

@RestApi(baseUrl: Constants.baseUrl)
abstract class AppServiceClient {
  factory AppServiceClient(Dio dio, {String baseUrl}) = _AppServiceClient;

  @POST("survey-crud/create_survey.php")
  Future<CreateSurveyBaseResponse> createSurvey(
    @Part(name: "title") String title,
    @Part(name: "description") String description,
    @Part(name: "color") String color,
      @Part(name: "timer") String timer,

      );
  @MultiPart()
  @POST("survey-crud/create_survey_questionsAndAnswers.php")
  Future<CreateSurveyQuestionsBaseResponse> createSurveyQuestionsAndAnswers(
    @Part(name: "data") String surveyQ,
    @Part(name: "files[]") List<File> images,
  );
  @GET("survey-crud/get_all_survey.php")
  Future<GetAllSurveyBaseResponse> getAllSurvey();
  @POST("survey-crud/get_surveyWithQuestion_by_id.php")
  Future<GetSurveyWithQuestionAndAnswerByIdBaseResponse>
  getSurveyWithQuestionById(@Part(name: "id") int id);
  @POST("conference-crud/create_conference.php")
  Future<CreateConferenceBaseResponse> createConference(
    @Body() ConferenceModel conference,
  );
  @POST("conference-crud/get_all_conference.php")
  Future<GetAllConferenceBaseResponse> getAllConference(
    @Part(name: "is_active") int isActive,
  );
  @POST("conference-crud/get_conference_by_id.php")
  Future<GetConferenceByIdBaseResponse> getConferenceById(
    @Part(name: "id") int id,
  );
  @POST("conference-crud/delete_conference.php")
  Future<Message1Response> deleteConference(@Part(name: "id") int id);
  @POST("survey-conference/link_survey_conference.php")
  Future<Message1Response> linkSurveyConference(
    @Part(name: "survey_id") int survey_id,
    @Part(name: "conference_id") int conference_id,
    @Part(name: "survey_order") int survey_order,
    @Part(name: "is_active") bool is_active,
  );
  @POST("survey-conference/get_allSurvey_and_activeSurvey.php")
  Future<GetAllSurveyWithActiveBaseResponse> getAllSurveyAndActiveSurvey(
    @Part(name: "conference_id") int conference_id,
  );
  @POST("users-crud/create_user_with_conferenceId.php")
  Future<CreateUserResponse> createUserWithConferenceId(
    @Part(name: "fullname") String fullname,
    @Part(name: "email") String email,
    @Part(name: "phone") String phone,
    @Part(name: "address") String address,
    @Part(name: "conference_id") int conference_id,
  );
  @POST("users-crud/add_users_answers.php")
  Future<CreateConferenceBaseResponse> add_users_answers(
    @Body() UseAnswerModel userAnswerModel,
  );
  @POST("synchronize/get_allInformation_confernce.php")
  Future<GetAllAsyncByConferenceIdBaseResponse> getAllInformationConference(
    @Part(name: "conference_id") int conference_id,
  );
  @POST("users-crud/get_users_by_conferenceId.php")
  Future<GetAllUserBaseResponse> getUsersByConferenceId(
    @Part(name: "conference_id") int conference_id,
  );
  @POST("synchronize/synchronize_users_answers.php")
  Future<Message1Response> synchronizeUsersAnswers(
    @Body() AllUserModel userRequest,
  );
  @POST("users-crud/get_userAnswersFor_specificSurvey.php")
  Future<GetSurveyWithQuestionAndAnswerForUserBaseResponse>
  getUserAnswersForSpecificSurvey(
    @Part(name: "id") int id,
    @Part(name: "user_id") int user_id,
  );
  /////////////update_survey
  /////////update_conference
}
