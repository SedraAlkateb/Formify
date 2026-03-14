import 'package:json_annotation/json_annotation.dart';
part 'responses.g.dart';

@JsonSerializable()
class BaseResponse {
  @JsonKey(name: "status")
  String? status;
  @JsonKey(name: "message")
  String? message;
}

//////////FormMessage
@JsonSerializable()
class Message1Response extends BaseResponse {
  Message1Response();
  // from json
  factory Message1Response.fromJson(Map<String, dynamic> json) =>
      _$Message1ResponseFromJson(json);

  // to json
  Map<String, dynamic> toJson() => _$Message1ResponseToJson(this);
}

@JsonSerializable()
class MessageResponse extends BaseResponse {
  @JsonKey(name: "message")
  String? message;
  MessageResponse(this.message);
  // from json
  factory MessageResponse.fromJson(Map<String, dynamic> json) =>
      _$MessageResponseFromJson(json);
  // to json
  Map<String, dynamic> toJson() => _$MessageResponseToJson(this);
}

@JsonSerializable()
class CreateUserResponse extends BaseResponse {
  @JsonKey(name: "user_id")
  int? user_id;
  CreateUserResponse(this.user_id);
  // from json
  factory CreateUserResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateUserResponseFromJson(json);
  // to json
  Map<String, dynamic> toJson() => _$CreateUserResponseToJson(this);
}

///////////////////////////CREATESERVEY
@JsonSerializable()
class CreateSurveyResponse {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "title")
  String? title;
  CreateSurveyResponse(this.id, this.title);
  // from json
  factory CreateSurveyResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateSurveyResponseFromJson(json);
  // to json
  Map<String, dynamic> toJson() => _$CreateSurveyResponseToJson(this);
}

@JsonSerializable()
class CreateSurveyBaseResponse extends BaseResponse {
  @JsonKey(name: "data")
  CreateSurveyResponse data;
  CreateSurveyBaseResponse(this.data);
  // from json
  factory CreateSurveyBaseResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateSurveyBaseResponseFromJson(json);

  // to json
  Map<String, dynamic> toJson() => _$CreateSurveyBaseResponseToJson(this);
}

/////////////////////////////////CREATESURVEYQUESTION////////////////
@JsonSerializable()
class CreateSurveyQuestionsBaseResponse extends BaseResponse {
  @JsonKey(name: "data")
  CreateSurveyQuestionsResponse data;
  CreateSurveyQuestionsBaseResponse(this.data);
  // from json
  factory CreateSurveyQuestionsBaseResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$CreateSurveyQuestionsBaseResponseFromJson(json);

  // to json
  Map<String, dynamic> toJson() =>
      _$CreateSurveyQuestionsBaseResponseToJson(this);
}

@JsonSerializable()
class CreateSurveyQuestionsResponse {
  @JsonKey(name: "survey_id")
  int? survey_id;
  @JsonKey(name: "questions_count")
  int? questions_count;

  CreateSurveyQuestionsResponse(this.survey_id, this.questions_count);
  // from json
  factory CreateSurveyQuestionsResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateSurveyQuestionsResponseFromJson(json);
  // to json
  Map<String, dynamic> toJson() => _$CreateSurveyQuestionsResponseToJson(this);
}

/////////////////////GETALLSURVEY
@JsonSerializable()
class GetSurveyResponse {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "description")
  String? description;
  @JsonKey(name: "color")
  String? color;
  @JsonKey(name: "timer")
  String? timer;

  GetSurveyResponse(
    this.id,
    this.title,
    this.description,
    this.color,
    this.timer,
  );
  // from json
  factory GetSurveyResponse.fromJson(Map<String, dynamic> json) =>
      _$GetSurveyResponseFromJson(json);
  // to json
  Map<String, dynamic> toJson() => _$GetSurveyResponseToJson(this);
}

@JsonSerializable()
class GetAllSurveyBaseResponse extends BaseResponse {
  @JsonKey(name: "data")
  List<GetSurveyResponse> data;
  GetAllSurveyBaseResponse(this.data);
  // from json
  factory GetAllSurveyBaseResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllSurveyBaseResponseFromJson(json);

  // to json
  Map<String, dynamic> toJson() => _$GetAllSurveyBaseResponseToJson(this);
}

/////////////////////GETALLSURVEYWITHQUESTIONANDANSWER
@JsonSerializable()
class GetSurveyWithQuestionAndAnswerResponse {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "description")
  String? description;
  @JsonKey(name: "color")
  String? color;
  @JsonKey(name: "timer")
  String? timer;
  @JsonKey(name: "questions")
  List<GetQuestionAndAnswerResponse>? questions;

  GetSurveyWithQuestionAndAnswerResponse(
    this.id,
    this.title,
    this.description,
    this.color,
    this.timer,
    this.questions,
  ); // from json
  factory GetSurveyWithQuestionAndAnswerResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$GetSurveyWithQuestionAndAnswerResponseFromJson(json);
  // to json
  Map<String, dynamic> toJson() =>
      _$GetSurveyWithQuestionAndAnswerResponseToJson(this);
}

@JsonSerializable()
class GetSurveyWithQuestionAndAnswerForUserResponse {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "description")
  String? description;
  @JsonKey(name: "color")
  String? color;
  @JsonKey(name: "timer")
  String? timer;
  @JsonKey(name: "questions")
  List<GetQuestionAndAnswerForUserResponse>? questions;

  GetSurveyWithQuestionAndAnswerForUserResponse(
    this.id,
    this.title,
    this.description,
    this.color,
    this.questions,
  ); // from json
  factory GetSurveyWithQuestionAndAnswerForUserResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$GetSurveyWithQuestionAndAnswerForUserResponseFromJson(json);
  // to json
  Map<String, dynamic> toJson() =>
      _$GetSurveyWithQuestionAndAnswerForUserResponseToJson(this);
}

@JsonSerializable()
class GetSurveyWithQuestionAndAnswerByIdBaseResponse extends BaseResponse {
  @JsonKey(name: "data")
  GetSurveyWithQuestionAndAnswerResponse data;

  GetSurveyWithQuestionAndAnswerByIdBaseResponse(this.data); // from json
  factory GetSurveyWithQuestionAndAnswerByIdBaseResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$GetSurveyWithQuestionAndAnswerByIdBaseResponseFromJson(json);
  // to json
  Map<String, dynamic> toJson() =>
      _$GetSurveyWithQuestionAndAnswerByIdBaseResponseToJson(this);
}

@JsonSerializable()
class GetQuestionAndAnswerResponse {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "question")
  String? question;
  @JsonKey(name: "question_order")
  int? question_order;
  @JsonKey(name: "is_required")
  bool? is_required;
  @JsonKey(name: "type")
  String? type;

  @JsonKey(name: "answers")
  List<GetAnswerResponse> answers;

  GetQuestionAndAnswerResponse(
    this.id,
    this.question,
    this.question_order,
    this.is_required,
    this.type,
    this.answers,
  ); // from json
  factory GetQuestionAndAnswerResponse.fromJson(Map<String, dynamic> json) =>
      _$GetQuestionAndAnswerResponseFromJson(json);
  // to json
  Map<String, dynamic> toJson() => _$GetQuestionAndAnswerResponseToJson(this);
}

@JsonSerializable()
class GetQuestionAndAnswerForUserResponse {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "question")
  String? question;
  @JsonKey(name: "question_order")
  int? question_order;
  @JsonKey(name: "is_required")
  bool? is_required;
  @JsonKey(name: "type")
  String? type;

  @JsonKey(name: "answers")
  List<GetAnswerResponse>? answers;
  @JsonKey(name: "user_answers")
  List<GetAnswerUserResponse>? answersUser;

  GetQuestionAndAnswerForUserResponse(
    this.id,
    this.question,
    this.question_order,
    this.is_required,
    this.type,
    this.answers,
    this.answersUser,
  ); // from json
  factory GetQuestionAndAnswerForUserResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$GetQuestionAndAnswerForUserResponseFromJson(json);
  // to json
  Map<String, dynamic> toJson() =>
      _$GetQuestionAndAnswerForUserResponseToJson(this);
}

@JsonSerializable()
class GetAnswerUserResponse {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "answer_id")
  int? answer_id;
  @JsonKey(name: "content")
  String? content;
  @JsonKey(name: "isCorrect")
  int? isCorrect;
  GetAnswerUserResponse(this.id, this.answer_id, this.content, this.isCorrect);
  // from json
  factory GetAnswerUserResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAnswerUserResponseFromJson(json);
  // to json
  Map<String, dynamic> toJson() => _$GetAnswerUserResponseToJson(this);
}

@JsonSerializable()
class GetAnswerResponse {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "img")
  String? img;
  @JsonKey(name: "isCorrect")
  int? isCorrect;
  GetAnswerResponse(this.id, this.title, this.img, this.isCorrect);
  // from json
  factory GetAnswerResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAnswerResponseFromJson(json);
  // to json
  Map<String, dynamic> toJson() => _$GetAnswerResponseToJson(this);
}

@JsonSerializable()
class GetSurveyWithQuestionAndAnswerBaseResponse extends BaseResponse {
  @JsonKey(name: "data")
  List<GetSurveyWithQuestionAndAnswerResponse> data;
  GetSurveyWithQuestionAndAnswerBaseResponse(this.data);
  // from json
  factory GetSurveyWithQuestionAndAnswerBaseResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$GetSurveyWithQuestionAndAnswerBaseResponseFromJson(json);

  // to json
  Map<String, dynamic> toJson() =>
      _$GetSurveyWithQuestionAndAnswerBaseResponseToJson(this);
}

@JsonSerializable()
class GetSurveyWithQuestionAndAnswerForUserBaseResponse extends BaseResponse {
  @JsonKey(name: "data")
  GetSurveyWithQuestionAndAnswerForUserResponse data;
  GetSurveyWithQuestionAndAnswerForUserBaseResponse(this.data);
  // from json
  factory GetSurveyWithQuestionAndAnswerForUserBaseResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$GetSurveyWithQuestionAndAnswerForUserBaseResponseFromJson(json);

  // to json
  Map<String, dynamic> toJson() =>
      _$GetSurveyWithQuestionAndAnswerForUserBaseResponseToJson(this);
}

@JsonSerializable()
class CreateConferenceBaseResponse extends BaseResponse {
  @JsonKey(name: "data")
  CreateConferenceResponse data;
  CreateConferenceBaseResponse(this.data);
  // from json
  factory CreateConferenceBaseResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateConferenceBaseResponseFromJson(json);

  // to json
  Map<String, dynamic> toJson() => _$CreateConferenceBaseResponseToJson(this);
}

@JsonSerializable()
class CreateConferenceResponse {
  @JsonKey(name: "id")
  int? id;
  CreateConferenceResponse(this.id);
  // from json
  factory CreateConferenceResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateConferenceResponseFromJson(json);
  // to json
  Map<String, dynamic> toJson() => _$CreateConferenceResponseToJson(this);
}

/////////////////////GETALLCONFERENCE
@JsonSerializable()
class GetAllConferenceResponse {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "description")
  String? description;
  @JsonKey(name: "address")
  String? address;
  @JsonKey(name: "start_date")
  String? start_date;
  @JsonKey(name: "end_date")
  String? end_date;
  @JsonKey(name: "isActive")
  bool? is_active;

  GetAllConferenceResponse(
    this.id,
    this.name,
    this.description,
    this.address,
    this.start_date,
    this.end_date,
    this.is_active,
  ); // from json
  factory GetAllConferenceResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllConferenceResponseFromJson(json);
  // to json
  Map<String, dynamic> toJson() => _$GetAllConferenceResponseToJson(this);
}

/////////////////////GETALLCONFERENCE
@JsonSerializable()
class GetAllConferenceByIdResponse {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "description")
  String? description;
  @JsonKey(name: "address")
  String? address;
  @JsonKey(name: "start_date")
  String? start_date;
  @JsonKey(name: "end_date")
  String? end_date;
  @JsonKey(name: "is_active")
  bool? is_active;
  @JsonKey(name: "surveys")
  List<GetSurveyToConferenceResponse> surveys;
  GetAllConferenceByIdResponse(
    this.id,
    this.name,
    this.description,
    this.address,
    this.start_date,
    this.end_date,
    this.is_active,
    this.surveys,
  ); // from json
  factory GetAllConferenceByIdResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllConferenceByIdResponseFromJson(json);
  // to json
  Map<String, dynamic> toJson() => _$GetAllConferenceByIdResponseToJson(this);
}

@JsonSerializable()
class GetAllConferenceBaseResponse extends BaseResponse {
  @JsonKey(name: "data")
  List<GetAllConferenceResponse> data;
  GetAllConferenceBaseResponse(this.data);
  // from json
  factory GetAllConferenceBaseResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllConferenceBaseResponseFromJson(json);

  // to json
  Map<String, dynamic> toJson() => _$GetAllConferenceBaseResponseToJson(this);
}

@JsonSerializable()
class GetSurveyToConferenceResponse {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "description")
  String? description;
  @JsonKey(name: "color")
  String? color;
  @JsonKey(name: "timer")
  String? timer;
  @JsonKey(name: "survey_order")
  int? survey_order;

  GetSurveyToConferenceResponse(
    this.id,
    this.title,
    this.description,
    this.color,
    this.survey_order,
  );
  // from json
  factory GetSurveyToConferenceResponse.fromJson(Map<String, dynamic> json) =>
      _$GetSurveyToConferenceResponseFromJson(json);
  // to json
  Map<String, dynamic> toJson() => _$GetSurveyToConferenceResponseToJson(this);
}

@JsonSerializable()
class GetConferenceByIdBaseResponse extends BaseResponse {
  @JsonKey(name: "data")
  GetAllConferenceByIdResponse data;
  GetConferenceByIdBaseResponse(this.data);
  // from json
  factory GetConferenceByIdBaseResponse.fromJson(Map<String, dynamic> json) =>
      _$GetConferenceByIdBaseResponseFromJson(json);

  // to json
  Map<String, dynamic> toJson() => _$GetConferenceByIdBaseResponseToJson(this);
}

///////////////////////GETALLSURVEYWITHACTIVE////////////////
/////////////////////GETALLSURVEY
@JsonSerializable()
class GetSurveyWithActiveResponse {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "description")
  String? description;
  @JsonKey(name: "color")
  String? color;
  @JsonKey(name: "timer")
  String? timer;
  @JsonKey(name: "is_active")
  bool? isActive;

  GetSurveyWithActiveResponse(
    this.id,
    this.title,
    this.description,
    this.color,
    this.isActive,
  );
  // from json
  factory GetSurveyWithActiveResponse.fromJson(Map<String, dynamic> json) =>
      _$GetSurveyWithActiveResponseFromJson(json);
  // to json
  Map<String, dynamic> toJson() => _$GetSurveyWithActiveResponseToJson(this);
}

@JsonSerializable()
class GetAllSurveyWithActiveBaseResponse extends BaseResponse {
  @JsonKey(name: "data")
  List<GetSurveyWithActiveResponse> data;
  GetAllSurveyWithActiveBaseResponse(this.data);
  // from json
  factory GetAllSurveyWithActiveBaseResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$GetAllSurveyWithActiveBaseResponseFromJson(json);

  // to json
  Map<String, dynamic> toJson() =>
      _$GetAllSurveyWithActiveBaseResponseToJson(this);
}

@JsonSerializable()
class GetAllAsyncByConferenceIdBaseResponse extends BaseResponse {
  @JsonKey(name: "data")
  GetAsyncConferenceResponse data;
  GetAllAsyncByConferenceIdBaseResponse(this.data);
  // from json
  factory GetAllAsyncByConferenceIdBaseResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$GetAllAsyncByConferenceIdBaseResponseFromJson(json);

  // to json
  Map<String, dynamic> toJson() =>
      _$GetAllAsyncByConferenceIdBaseResponseToJson(this);
}

@JsonSerializable()
class GetAsyncConferenceResponse {
  @JsonKey(name: "conference")
  GetAllConferenceResponse conference;
  @JsonKey(name: "survey")
  List<GetSurveyResponse> survey;
  @JsonKey(name: "questions")
  List<GetQuestionForAsyncResponse> questions;
  @JsonKey(name: "answers")
  List<GetAnswerForAsyncResponse> answers;
  @JsonKey(name: "survey_conference")
  List<SurveyConferenceForAsyncResponse> survey_conference;

  GetAsyncConferenceResponse(
    this.conference,
    this.survey,
    this.questions,
    this.answers,
    this.survey_conference,
  ); // from json
  factory GetAsyncConferenceResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAsyncConferenceResponseFromJson(json);
  // to json
  Map<String, dynamic> toJson() => _$GetAsyncConferenceResponseToJson(this);
}

@JsonSerializable()
class GetQuestionForAsyncResponse {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "title")
  String? question;
  @JsonKey(name: "order")
  int? question_order;
  @JsonKey(name: "isRequired")
  bool? is_required;
  @JsonKey(name: "type")
  String? type;
  @JsonKey(name: "survey_id")
  int? survey_id;
  GetQuestionForAsyncResponse(
    this.id,
    this.question,
    this.question_order,
    this.is_required,
    this.type,
    this.survey_id,
  ); // from json
  factory GetQuestionForAsyncResponse.fromJson(Map<String, dynamic> json) =>
      _$GetQuestionForAsyncResponseFromJson(json);
  // to json
  Map<String, dynamic> toJson() => _$GetQuestionForAsyncResponseToJson(this);
}

@JsonSerializable()
class GetAnswerForAsyncResponse {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "title")
  String? title;

  @JsonKey(name: "question_id")
  int? question_id;
  @JsonKey(name: "img")
  String? img;
  @JsonKey(name: "isCorrect")
  int? isCorrect;

  GetAnswerForAsyncResponse(
    this.id,
    this.title,
    this.question_id,
    this.img,
    this.isCorrect,
  );
  // from json
  factory GetAnswerForAsyncResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAnswerForAsyncResponseFromJson(json);
  // to json
  Map<String, dynamic> toJson() => _$GetAnswerForAsyncResponseToJson(this);
}

@JsonSerializable()
class SurveyConferenceForAsyncResponse {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "survey_order")
  int? survey_order;
  @JsonKey(name: "survey_id")
  int? survey_id;
  @JsonKey(name: "conference_id")
  int? conference_id;

  SurveyConferenceForAsyncResponse(
    this.id,
    this.survey_order,
    this.survey_id,
    this.conference_id,
  ); // from json
  factory SurveyConferenceForAsyncResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$SurveyConferenceForAsyncResponseFromJson(json);
  // to json
  Map<String, dynamic> toJson() =>
      _$SurveyConferenceForAsyncResponseToJson(this);
}

/////////////////////GETALL USER
@JsonSerializable()
class UserResponse {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "fullname")
  String? fullName;
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "phone")
  String? phone;
  @JsonKey(name: "address")
  String? address;

  UserResponse(
    this.id,
    this.fullName,
    this.email,
    this.phone,
    this.address,
  ); // from json
  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);
  // to json
  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}

@JsonSerializable()
class GetAllUserBaseResponse extends BaseResponse {
  @JsonKey(name: "data")
  List<UserResponse> data;
  GetAllUserBaseResponse(this.data);
  // from json
  factory GetAllUserBaseResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllUserBaseResponseFromJson(json);

  // to json
  Map<String, dynamic> toJson() => _$GetAllUserBaseResponseToJson(this);
}
//////////////////////////////////Statistics

@JsonSerializable()
class UserAnswerForStatResponse {
  @JsonKey(name: "question-id")
  int? questionId;
  @JsonKey(name: "question")
  String? question;
  @JsonKey(name: "content")
  String? content;

  UserAnswerForStatResponse(
    this.questionId,
    this.question,
    this.content,
  ); // from json
  factory UserAnswerForStatResponse.fromJson(Map<String, dynamic> json) =>
      _$UserAnswerForStatResponseFromJson(json);
  // to json
  Map<String, dynamic> toJson() => _$UserAnswerForStatResponseToJson(this);
}

@JsonSerializable()
class UserAndAnswersResponse {
  @JsonKey(name: "user-Information")
  UserResponse userInformation;
  @JsonKey(name: "user-answers")
  List<UserAnswerForStatResponse> userAnswers;

  UserAndAnswersResponse(this.userInformation, this.userAnswers); // from json
  factory UserAndAnswersResponse.fromJson(Map<String, dynamic> json) =>
      _$UserAndAnswersResponseFromJson(json);

  // to json
  Map<String, dynamic> toJson() => _$UserAndAnswersResponseToJson(this);
}

@JsonSerializable()
class StatisticsForUsersAnswersResponse {
  @JsonKey(name: "survey-questions")
  List<SurveyQuestionResponse> surveyQuestions;

  @JsonKey(name: "users-answers")
  List<UserAndAnswersResponse> usersAnswers;

  StatisticsForUsersAnswersResponse(
    this.surveyQuestions,
    this.usersAnswers,
  ); // from json
  factory StatisticsForUsersAnswersResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$StatisticsForUsersAnswersResponseFromJson(json);

  // to json
  Map<String, dynamic> toJson() =>
      _$StatisticsForUsersAnswersResponseToJson(this);
}

@JsonSerializable()
class SurveyQuestionResponse {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "question")
  String? question;
  @JsonKey(name: "type")
  String? type;

  SurveyQuestionResponse(this.id, this.question, this.type);

  factory SurveyQuestionResponse.fromJson(Map<String, dynamic> json) =>
      _$SurveyQuestionResponseFromJson(json);

  // to json
  Map<String, dynamic> toJson() => _$SurveyQuestionResponseToJson(this);
}

@JsonSerializable()
class StatisticsForUsersAnswersBaseResponse extends BaseResponse {
  @JsonKey(name: "data")
  StatisticsForUsersAnswersResponse data;
  StatisticsForUsersAnswersBaseResponse(this.data);
  // from json
  factory StatisticsForUsersAnswersBaseResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$StatisticsForUsersAnswersBaseResponseFromJson(json);

  // to json
  Map<String, dynamic> toJson() =>
      _$StatisticsForUsersAnswersBaseResponseToJson(this);
}

@JsonSerializable()
class GetQuestionForStatResponse {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "question_text")
  String? question_text;
  @JsonKey(name: "question_order")
  int? question_order;
  @JsonKey(name: "is_required")
  int? is_required;
  @JsonKey(name: "type")
  String? type;
  @JsonKey(name: "survey_id")
  int? survey_id;
  @JsonKey(name: "Group-Type")
  int? groupType;

  GetQuestionForStatResponse(
    this.id,
    this.question_text,
    this.question_order,
    this.is_required,
    this.type,
    this.survey_id,
      this.groupType
  ); // from json
  factory GetQuestionForStatResponse.fromJson(Map<String, dynamic> json) =>
      _$GetQuestionForStatResponseFromJson(json);
  // to json
  Map<String, dynamic> toJson() => _$GetQuestionForStatResponseToJson(this);
}

@JsonSerializable()
class UserAnswerStatResponse {
  @JsonKey(name: "user_answer_id")
  int? user_answer_id;
  @JsonKey(name: "content")
  String? content;

  UserAnswerStatResponse(this.user_answer_id, this.content); // from json
  factory UserAnswerStatResponse.fromJson(Map<String, dynamic> json) =>
      _$UserAnswerStatResponseFromJson(json);
  // to json
  Map<String, dynamic> toJson() => _$UserAnswerStatResponseToJson(this);
}

@JsonSerializable()
class StatisticStatResponse {
  @JsonKey(name: "answer_id")
  int? answer_id;
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "count")
  int? count;
  @JsonKey(name: "total")
  int? total;

  StatisticStatResponse(this.answer_id, this.title, this.count, this.total);

  factory StatisticStatResponse.fromJson(Map<String, dynamic> json) =>
      _$StatisticStatResponseFromJson(json);
  // to json
  Map<String, dynamic> toJson() => _$StatisticStatResponseToJson(this);
}

@JsonSerializable()
class QuestionsStatResponse {
  @JsonKey(name: "question")
  GetQuestionForStatResponse question;
  @JsonKey(name: "user-answers")
  List<UserAnswerStatResponse> userAnswers;
  @JsonKey(name: "statistics")
  List<StatisticStatResponse> statistics;

  QuestionsStatResponse(this.question, this.userAnswers, this.statistics);

  factory QuestionsStatResponse.fromJson(Map<String, dynamic> json) =>
      _$QuestionsStatResponseFromJson(json);
  // to json
  Map<String, dynamic> toJson() => _$QuestionsStatResponseToJson(this);
}

@JsonSerializable()
class QuestionsStatisticsBaseResponse extends BaseResponse{
  @JsonKey(name: "data")
  List<QuestionsStatResponse> data;

  QuestionsStatisticsBaseResponse(this.data);

  factory QuestionsStatisticsBaseResponse.fromJson(Map<String, dynamic> json) =>
      _$QuestionsStatisticsBaseResponseFromJson(json);
  // to json
  Map<String, dynamic> toJson() => _$QuestionsStatisticsBaseResponseToJson(this);
}
