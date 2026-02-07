import 'package:formify/app/constants.dart';
import 'package:formify/data/responses/responses.dart';
import 'package:formify/domain/models/model_q.dart';
import 'package:formify/domain/models/models.dart';

extension GetMainSurveyModelMapper on GetSurveyResponse? {
  MainSurveyModel toDomain() {
    return MainSurveyModel(
      this?.id ?? Constants.zero,
      this?.title ?? Constants.empty,
      this?.description ?? Constants.empty,
      this?.color ?? Constants.empty,
    );
  }
}

extension GetAnswerModelMapper on GetAnswerResponse? {
  AnswerModel toDomain() {
    return AnswerModel(
      this?.id ?? Constants.zero,
      this?.title ?? Constants.empty,
      "",
    );
  }
}

extension GetAllAnswerModelMapper on List<GetAnswerResponse>? {
  List<AnswerModel> toDomain() {
    List<AnswerModel> allAnswer =
        (this?.map((response) => response.toDomain()) ?? const Iterable.empty())
            .cast<AnswerModel>()
            .toList();
    return allAnswer;
  }
}

extension GetQuestionModelMapper on GetQuestionAndAnswerResponse? {
  QuestionModel toDomain() {
    return QuestionModel(
      id: this?.id ?? Constants.zero,

      title: this?.question ?? Constants.empty,
      order: this?.question_order ?? Constants.zero,
      isRequired: this?.is_required ?? false,
      type: QuestionType.values.firstWhere(
        (e) => e.toString().split('.').last == this?.type,
        orElse: () => QuestionType.text, // قيمة افتراضية
      ),
      answers: this!.answers.toDomain(),
    );
  }
}

extension GetAsyncQuestionModelMapper on GetQuestionForAsyncResponse? {
  AsyncQuestionModel toDomain() {
    return AsyncQuestionModel(
      this?.id ?? Constants.zero,
      this?.question ?? Constants.empty,
      this?.question_order ?? Constants.zero,
      this?.is_required ?? false,
      convertToQuestionType(this?.type ?? "TextField"),
      this?.survey_id ?? Constants.zero,
    );
  }
}

extension ViewSurveyModelMapper on GetSurveyWithQuestionAndAnswerResponse? {
  SurveyModel toDomain() {
    return SurveyModel(
      id: this?.id ?? Constants.zero,
      title: this?.title ?? Constants.empty,
      description: this?.description ?? Constants.empty,
      color: this?.color ?? Constants.empty,
      questions: this!.questions.toDomain(),
    );
  }
}

extension GetSurveyWithQuestionAndAnswerByIdBaseResponseMapper
    on GetSurveyWithQuestionAndAnswerByIdBaseResponse? {
  SurveyModel toDomain() {
    return SurveyModel(
      id: this?.data.id ?? Constants.zero,
      title: this?.data.title ?? Constants.empty,
      description: this?.data.description ?? Constants.empty,
      color: this?.data.color ?? Constants.empty,
      questions: this!.data.questions.toDomain(),
    );
  }
}

extension GetQuestionModelUserMapper on GetQuestionAndAnswerForUserResponse? {
  QuestionModel toDomain() {
    return QuestionModel(
      id: this?.id ?? Constants.zero,

      title: this?.question ?? Constants.empty,
      order: this?.question_order ?? Constants.zero,
      isRequired: this?.is_required ?? false,
      type: QuestionType.values.firstWhere(
        (e) => e.toString().split('.').last == this?.type,
        orElse: () => QuestionType.text, // قيمة افتراضية
      ),
      answers: this!.answers.toDomain(),
    );
  }
}

extension GetAllAnswerUserModelMapper on List<GetAnswerUserResponse>? {
  List<AnswerUserSurveyModel> toDomain() {
    List<AnswerUserSurveyModel> allAnswer =
        (this?.map((response) => response.toDomain()) ?? const Iterable.empty())
            .cast<AnswerUserSurveyModel>()
            .toList();
    return allAnswer;
  }
}

extension GetAllQuestionForUserMapper
    on GetSurveyWithQuestionAndAnswerForUserBaseResponse? {
  SurveyUserModel toDomain() {
    List<AnswerUserSurveyWithIndexModel> answerUser = [];

    List<QuestionModel> allQuestion =
        (this!.data.questions?.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final response = entry.value;
                  if (response.answersUser.isNotEmpty) {
                    answerUser.add(
                      AnswerUserSurveyWithIndexModel(
                        response.answersUser.toDomain(),
                        index,
                      ),
                    );
                  }
                  return response.toDomain(); // مهم ترجع القيمة
                }) ??
                const Iterable.empty())
            .toList();
    SurveyModel surveyModel = SurveyModel(
      title: this?.data.title ?? Constants.empty,
      description: this?.data.description ?? Constants.empty,
      color: this?.data.color ?? Constants.empty,
      questions: allQuestion,
    );
    SurveyUserModel surveyUser = SurveyUserModel(
      surveyModel: surveyModel,
      answerUser: answerUser,
    );
    return surveyUser;
  }
}

extension GetAnswerUserModelMapper on GetAnswerUserResponse? {
  AnswerUserSurveyModel toDomain() {
    return AnswerUserSurveyModel(
      this?.id ?? Constants.zero,
      this?.answer_id ?? Constants.zero,
      this?.content ?? Constants.empty,
    );
  }
}

////////////////
extension GetSurveyModelMapper on SurveyToConferenceModel? {
  MainSurveyModel toDomain() {
    return MainSurveyModel(
      this?.id ?? Constants.zero,
      this?.title ?? Constants.empty,
      this?.description ?? Constants.empty,
      this?.color ?? Constants.empty,
    );
  }
}

extension GetSurveyToConferenceMapper on GetSurveyToConferenceResponse? {
  SurveyToConferenceModel toDomain() {
    return SurveyToConferenceModel(
      this?.id ?? Constants.zero,
      this?.title ?? Constants.empty,
      this?.description ?? Constants.empty,
      this?.color ?? Constants.empty,
      this?.survey_order ?? Constants.zero,
    );
  }
}

extension GetAllMainSurveyModelMapper on GetAllSurveyBaseResponse? {
  List<MainSurveyModel> toDomain() {
    List<MainSurveyModel> allSurvey =
        (this?.data.map((response) => response.toDomain()) ??
                const Iterable.empty())
            .cast<MainSurveyModel>()
            .toList();
    return allSurvey;
  }
}

extension GetSurveyWithQuestionAndAnswerMapper
    on GetSurveyWithQuestionAndAnswerBaseResponse? {
  List<SurveyModel> toDomain() {
    List<SurveyModel> allSurvey =
        (this?.data.map((response) => response.toDomain()) ??
                const Iterable.empty())
            .cast<SurveyModel>()
            .toList();
    return allSurvey;
  }
}

extension GetAllQuestionMapper on List<GetQuestionAndAnswerResponse>? {
  List<QuestionModel> toDomain() {
    List<QuestionModel> allQuestion =
        (this?.map((response) => response.toDomain()) ?? const Iterable.empty())
            .cast<QuestionModel>()
            .toList();
    return allQuestion;
  }
}

extension GetAllAsyncQuestionMapper on List<GetQuestionForAsyncResponse>? {
  List<AsyncQuestionModel> toDomain() {
    List<AsyncQuestionModel> allQuestion =
        (this?.map((response) => response.toDomain()) ?? const Iterable.empty())
            .cast<AsyncQuestionModel>()
            .toList();
    return allQuestion;
  }
}

extension CreateSurveyModelMapper on CreateSurveyBaseResponse? {
  CreateSurveyModel toDomain() {
    return CreateSurveyModel(
      this?.data.id ?? Constants.zero,
      this?.data.title ?? Constants.empty,
    );
  }
}

extension GetConferenceMapper on GetAllConferenceResponse? {
  GetAllConferenceModel toDomain() {
    return GetAllConferenceModel(
      this?.id ?? Constants.zero,
      this?.name ?? Constants.empty,
      this?.description ?? Constants.empty,
      this?.address ?? Constants.empty,
      this?.start_date ?? Constants.empty,
      this?.end_date ?? Constants.empty,
      this?.is_active ?? false,
    );
  }
}

extension GetAllAsyncByConferenceMapper
    on GetAllAsyncByConferenceIdBaseResponse {
  GetAsyncModel toDomain() {
    return GetAsyncModel(
      data.conference.toDomain(),
      data.survey.toDomain(),
      data.questions.toDomain(),
      data.answers.toDomain(),
      data.survey_conference.toDomain(),
    );
  }
}

extension GetConferenceByIdMapper on GetConferenceByIdBaseResponse? {
  GetAllConferenceByIdModel toDomain() {
    return GetAllConferenceByIdModel(
      this?.data.id ?? Constants.zero,
      this?.data.name ?? Constants.empty,
      this?.data.description ?? Constants.empty,
      this?.data.address ?? Constants.empty,
      this?.data.start_date ?? Constants.empty,
      this?.data.end_date ?? Constants.empty,
      this?.data.is_active ?? false,
      this!.data.surveys.toDomain(),
    );
  }
}

extension IsActiveSurveyMapper on MainSurveyModel {
  IsActiveMainSurveyModel toDomain() {
    return IsActiveMainSurveyModel(id, title, description, color, false);
  }
}

extension AllIsActiveMapper on List<MainSurveyModel> {
  List<IsActiveMainSurveyModel> toDomain() {
    List<IsActiveMainSurveyModel> allIsActiveSurvey = (map(
      (response) => response.toDomain(),
    )).cast<IsActiveMainSurveyModel>().toList();
    return allIsActiveSurvey;
  }
}

extension GetAllConferenceMapper on GetAllConferenceBaseResponse? {
  List<GetAllConferenceModel> toDomain() {
    List<GetAllConferenceModel> allConference =
        (this?.data.map((response) => response.toDomain()) ??
                const Iterable.empty())
            .cast<GetAllConferenceModel>()
            .toList();
    return allConference;
  }
}

//List<SurveyToConferenceModel> surveys;
extension GetAllSurveyToConferenceMapper
    on List<GetSurveyToConferenceResponse> {
  List<SurveyToConferenceModel> toDomain() {
    List<SurveyToConferenceModel> allSurvey = (this.map(
      (response) => response.toDomain(),
    )).cast<SurveyToConferenceModel>().toList();
    return allSurvey;
  }
}

extension GetAsyncAnswerMapper on GetAnswerForAsyncResponse? {
  AnswerModel toDomain() {
    return AnswerModel(
      this?.id ?? Constants.zero,
      this?.title ?? Constants.empty,
      "",
      questionId: this?.question_id ?? Constants.zero,
    );
  }
}

extension GetAllAsyncAnswerMapper on List<GetAnswerForAsyncResponse>? {
  List<AnswerModel> toDomain() {
    List<AnswerModel> allAnswer =
        (this?.map((response) => response.toDomain()) ?? const Iterable.empty())
            .cast<AnswerModel>()
            .toList();
    return allAnswer;
  }
}

extension GetAsyncSurveyConferenceMapper on SurveyConferenceForAsyncResponse? {
  SurveyConferenceAsyncModel toDomain() {
    return SurveyConferenceAsyncModel(
      this?.id ?? Constants.zero,
      this?.survey_order ?? Constants.zero,
      this?.survey_id ?? Constants.zero,
      this?.conference_id ?? Constants.zero,
    );
  }
}

extension GetAllAsyncSurveyConferenceMapper
    on List<SurveyConferenceForAsyncResponse>? {
  List<SurveyConferenceAsyncModel> toDomain() {
    List<SurveyConferenceAsyncModel> allSurveyConference =
        (this?.map((response) => response.toDomain()) ?? const Iterable.empty())
            .cast<SurveyConferenceAsyncModel>()
            .toList();
    return allSurveyConference;
  }
}

extension GetAllAsyncSurveyMapper on List<GetSurveyResponse>? {
  List<MainSurveyModel> toDomain() {
    List<MainSurveyModel> allSurvey =
        (this?.map((response) => response.toDomain()) ?? const Iterable.empty())
            .cast<MainSurveyModel>()
            .toList();
    return allSurvey;
  }
}

extension GetConferenceModelMapper on GetSurveyWithActiveResponse? {
  IsActiveMainSurveyModel toDomain() {
    return IsActiveMainSurveyModel(
      this?.id ?? Constants.zero,
      this?.title ?? Constants.empty,
      this?.description ?? Constants.empty,
      this?.color ?? Constants.empty,
      this?.isActive ?? false,
    );
  }
}

extension GetAllConferenceModelMapper on GetAllSurveyWithActiveBaseResponse {
  List<IsActiveMainSurveyModel> toDomain() {
    List<IsActiveMainSurveyModel> allSurvey = (data.map(
      (response) => response.toDomain(),
    )).cast<IsActiveMainSurveyModel>().toList();
    return allSurvey;
  }
}

/////////////////////////USER
extension GetUserModelMapper on UserResponse? {
  UserModel toDomain() {
    return UserModel(
      this?.id ?? Constants.zero,
      this?.fullName ?? Constants.empty,
      this?.email ?? Constants.empty,
      this?.phone ?? Constants.empty,
      this?.address ?? Constants.empty,
    );
  }
}

extension GetAllUserModelMapper on GetAllUserBaseResponse {
  List<UserModel> toDomain() {
    List<UserModel> allSurvey = (data.map(
      (response) => response.toDomain(),
    )).cast<UserModel>().toList();
    return allSurvey;
  }
}
