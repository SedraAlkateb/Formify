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
  );
  @POST("survey-crud/create_survey_questionsAndAnswers.php")
  Future<CreateSurveyQuestionsBaseResponse> createSurveyQuestionsAndAnswers(
    @Body() SurveyQuestionAndAnswersModel surveyQ,
  );
  @GET("survey-crud/get_all_survey.php")
  Future<GetAllSurveyBaseResponse> getAllSurvey();
  @GET("survey-crud/get_surveyWithQuestion_by_id.php")
  Future<GetSurveyWithQuestionAndAnswerBaseResponse> getSurveyWithQuestionById(
    @Part(name: "id") int id,
  );
  @POST("conference-crud/create_conference.php")
  Future<CreateConferenceBaseResponse> createConference(
      @Body() ConferenceModel conference
      );
  @POST("conference-crud/get_all_conference.php")
  Future<GetAllConferenceBaseResponse> getAllConference(
      @Part(name: "is_active") int isActive,
      );
  @POST("conference-crud/get_conference_by_id.php")
  Future<GetAllConferenceBaseResponse> getConferenceById(
      @Part(name: "id") int id,
      );
  @POST("conference-crud/delete_conference.php")
  Future<Message1Response> deleteConference(
      @Part(name: "id") int id,
      );
  @POST("survey-conference/link_survey_conference.php")
  Future<Message1Response> linkSurveyConference(
      @Part(name: "survey_id") int survey_id,
      @Part(name: "conference_id") int conference_id,
      @Part(name: "survey_order") int survey_order,
      );

}
