import 'dart:convert';
import 'dart:io';

import 'package:formify/data/network/app_api.dart';
import 'package:formify/data/responses/responses.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/request.dart';

abstract class RemoteDataSource {
  Future<CreateSurveyBaseResponse> createSurvey(SurveyRequest survey);

  Future<CreateSurveyQuestionsBaseResponse> createSurveyQuestionsAndAnswers(
    SurveyQuestionAndAnswersModel surveyQ,
    List<File> images,
  );

  Future<GetAllSurveyBaseResponse> getAllSurvey();

  Future<GetSurveyWithQuestionAndAnswerByIdBaseResponse>
  getSurveyWithQuestionById(int id);
  Future<CreateConferenceBaseResponse> createConference(
    ConferenceModel conference,
  );
  Future<GetAllConferenceBaseResponse> getAllConference(int isActive);
  Future<Message1Response> linkSurveyConference(
    SurveyConference surveyConference,
  );
  Future<Message1Response> deleteConference(int id);
  Future<GetConferenceByIdBaseResponse> getConferenceById(int id);
  Future<CreateUserResponse> createUserWithConferenceId(
    UserInputModel userInputModel,
  );
  Future<GetAllAsyncByConferenceIdBaseResponse> getAllInformationConference(
    int conferenceId,
  );
  Future<GetAllSurveyWithActiveBaseResponse> getAllSurveyAndActiveSurvey(
    int conference_id,
  );
  Future<GetAllUserBaseResponse> getUsersByConferenceId(int conferenceId);
  Future<Message1Response> synchronizeUsersAnswers(AllUserModel userRequest);
  Future<GetSurveyWithQuestionAndAnswerForUserBaseResponse>
  getUserAnswersForSpecificSurvey(int id, int user_id);
  Future<Message1Response> login(LoginRequest loginRequest);
  Future<Message1Response> updateConference(int id, ConferenceModel conference);
  Future<Message1Response> updateSurvey(UpdateSurveyRequest update);
  Future<StatisticsForUsersAnswersBaseResponse> statisticsForUsersAnswers(
    int surveyId,
  );

  Future<QuestionsStatisticsBaseResponse> getStatisticsForQuestionTypes(
    int survey_id,
    int conference_id,
  );
  Future< CheckoutResponse> checkPassword(String password);
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
      survey.timer,
    );
  }

  @override
  Future<CreateSurveyQuestionsBaseResponse> createSurveyQuestionsAndAnswers(
    SurveyQuestionAndAnswersModel surveyQ,
    List<File> images,
  ) async {
    final surveyJson = jsonEncode(surveyQ.toJson());
    return await _appServiceClient.createSurveyQuestionsAndAnswers(
      surveyJson,
      images,
    );
  }

  @override
  Future<GetAllSurveyBaseResponse> getAllSurvey() async {
    return await _appServiceClient.getAllSurvey();
  }

  @override
  Future<GetSurveyWithQuestionAndAnswerByIdBaseResponse>
  getSurveyWithQuestionById(int id) async {
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
      surveyConference.is_active,
    );
  }

  @override
  Future<Message1Response> deleteConference(int id) async {
    return await _appServiceClient.deleteConference(id);
  }

  @override
  Future<GetConferenceByIdBaseResponse> getConferenceById(int id) async {
    return await _appServiceClient.getConferenceById(id);
  }

  @override
  Future<CreateUserResponse> createUserWithConferenceId(
    UserInputModel userInputModel,
  ) async {
    return await _appServiceClient.createUserWithConferenceId(
      userInputModel.fullName,
      userInputModel.email,
      userInputModel.phone,
      userInputModel.address,
      userInputModel.conferenceId,
    );
  }

  @override
  Future<GetAllAsyncByConferenceIdBaseResponse> getAllInformationConference(
    int conferenceId,
  ) async {
    return await _appServiceClient.getAllInformationConference(conferenceId);
  }

  @override
  Future<GetAllSurveyWithActiveBaseResponse> getAllSurveyAndActiveSurvey(
    int conference_id,
  ) async {
    return await _appServiceClient.getAllSurveyAndActiveSurvey(conference_id);
  }

  @override
  Future<GetAllUserBaseResponse> getUsersByConferenceId(
    int conferenceId,
  ) async {
    return await _appServiceClient.getUsersByConferenceId(conferenceId);
  }

  @override
  Future<Message1Response> synchronizeUsersAnswers(
    AllUserModel userRequest,
  ) async {
    return await _appServiceClient.synchronizeUsersAnswers(userRequest);
  }

  @override
  Future<GetSurveyWithQuestionAndAnswerForUserBaseResponse>
  getUserAnswersForSpecificSurvey(int id, int user_id) async {
    return await _appServiceClient.getUserAnswersForSpecificSurvey(id, user_id);
  }

  @override
  Future<Message1Response> login(LoginRequest loginRequest) async {
    return await _appServiceClient.login(
      loginRequest.username,
      loginRequest.password,
    );
  }

  @override
  Future<Message1Response> updateConference(
    int id,
    ConferenceModel conference,
  ) async {
    return await _appServiceClient.updateConference(
      id,
      conference.name,
      conference.description,
      conference.address,
      conference.startDate,
      conference.endDate,
      conference.isActive,
    );
  }

  @override
  Future<Message1Response> updateSurvey(UpdateSurveyRequest update) async {
    return await _appServiceClient.updateSurvey(
      update.id,
      title: update.title,
      description: update.description,
      color: update.color,
    );
  }

  @override
  Future<StatisticsForUsersAnswersBaseResponse> statisticsForUsersAnswers(
    int surveyId,
  ) async {
    return await _appServiceClient.statisticsForUsersAnswers(surveyId);
  }

  @override
  Future<QuestionsStatisticsBaseResponse> getStatisticsForQuestionTypes(int survey_id, int conference_id) async {
    return await _appServiceClient.getStatisticsForQuestionTypes(survey_id,conference_id);
  }

  @override
  Future<CheckoutResponse> checkPassword(String password)async {
    return await _appServiceClient.checkPassword(password);
  }

}
