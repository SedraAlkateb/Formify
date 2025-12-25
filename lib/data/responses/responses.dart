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

  GetSurveyResponse(this.id, this.title, this.description, this.color);
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
  @JsonKey(name: "questions")
  List<GetQuestionAndAnswerResponse>? questions;

  GetSurveyWithQuestionAndAnswerResponse(this.id, this.title, this.description,
      this.color, this.questions); // from json
  factory GetSurveyWithQuestionAndAnswerResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$GetSurveyWithQuestionAndAnswerResponseFromJson(json);
  // to json
  Map<String, dynamic> toJson() =>
      _$GetSurveyWithQuestionAndAnswerResponseToJson(this);
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
class GetAnswerResponse {

  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "title")
  String? title;
  GetAnswerResponse(this.id, this.title);
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
  @JsonKey(name: "is_active")
  bool? is_active;

  GetAllConferenceResponse(this.id, this.title, this.description, this.color);
  // from json
  factory GetAllConferenceResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllConferenceResponseFromJson(json);
  // to json
  Map<String, dynamic> toJson() => _$GetAllConferenceResponseToJson(this);
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
