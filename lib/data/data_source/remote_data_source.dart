import 'package:formify/data/network/app_api.dart';
import 'package:formify/data/responses/responses.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/request.dart';

abstract class RemoteDataSource {
  Future<CreateSurveyBaseResponse> createSurvey(SurveyRequest survey);

  Future<CreateSurveyQuestionsBaseResponse> createSurveyQuestionsAndAnswers(
    SurveyQuestionAndAnswersModel surveyQ,
  );

  Future<GetAllSurveyBaseResponse> getAllSurvey();

  Future<GetSurveyWithQuestionAndAnswerBaseResponse> getSurveyWithQuestionById(
    int id,
  );
  Future<CreateConferenceBaseResponse> createConference(
    ConferenceModel conference,
  );
  Future<GetAllConferenceBaseResponse> getAllConference(int isActive);
  Future<Message1Response> linkSurveyConference(
    SurveyConference surveyConference,
  );
  Future<Message1Response> deleteConference(int id);
  Future<GetConferenceByIdBaseResponse> getConferenceById(int id);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final AppServiceClient _appServiceClient;

  RemoteDataSourceImpl(this._appServiceClient);

  @override
  Future<CreateSurveyBaseResponse> createSurvey(SurveyRequest survey) async {
    return await _appServiceClient.createSurvey(
      survey.title,
      survey.description,
      survey.color,
    );
  }

  @override
  Future<CreateSurveyQuestionsBaseResponse> createSurveyQuestionsAndAnswers(
    SurveyQuestionAndAnswersModel surveyQ,
  ) async {
    return await _appServiceClient.createSurveyQuestionsAndAnswers(surveyQ);
  }

  @override
  Future<GetAllSurveyBaseResponse> getAllSurvey() async {
    return await _appServiceClient.getAllSurvey();
  }

  @override
  Future<GetSurveyWithQuestionAndAnswerBaseResponse> getSurveyWithQuestionById(
    int id,
  ) async {
    return await _appServiceClient.getSurveyWithQuestionById(id);
  }

  @override
  Future<CreateConferenceBaseResponse> createConference(
    ConferenceModel conference,
  ) async {
    return await _appServiceClient.createConference(conference);
  }

  @override
  Future<GetAllConferenceBaseResponse> getAllConference(int isActive) async {
    return await _appServiceClient.getAllConference(isActive);
  }

  @override
  Future<Message1Response> linkSurveyConference(
    SurveyConference surveyConference,
  ) async {
    return await _appServiceClient.linkSurveyConference(
      surveyConference.survey_id,
      surveyConference.conference_id,
      surveyConference.survey_order,
    );
  }

  @override
  Future<Message1Response> deleteConference(int id) async {
    return await _appServiceClient.deleteConference(id);
  }

  @override
  Future<GetConferenceByIdBaseResponse> getConferenceById(int id)  async {
    return await _appServiceClient.getConferenceById(id);
  }
}
