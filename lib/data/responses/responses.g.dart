// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponse _$BaseResponseFromJson(Map<String, dynamic> json) => BaseResponse()
  ..status = json['status'] as String?
  ..message = json['message'] as String?;

Map<String, dynamic> _$BaseResponseToJson(BaseResponse instance) =>
    <String, dynamic>{'status': instance.status, 'message': instance.message};

Message1Response _$Message1ResponseFromJson(Map<String, dynamic> json) =>
    Message1Response()
      ..status = json['status'] as String?
      ..message = json['message'] as String?;

Map<String, dynamic> _$Message1ResponseToJson(Message1Response instance) =>
    <String, dynamic>{'status': instance.status, 'message': instance.message};

MessageResponse _$MessageResponseFromJson(Map<String, dynamic> json) =>
    MessageResponse(json['message'] as String?)
      ..status = json['status'] as String?;

Map<String, dynamic> _$MessageResponseToJson(MessageResponse instance) =>
    <String, dynamic>{'status': instance.status, 'message': instance.message};

CreateUserResponse _$CreateUserResponseFromJson(Map<String, dynamic> json) =>
    CreateUserResponse((json['user_id'] as num?)?.toInt())
      ..status = json['status'] as String?
      ..message = json['message'] as String?;

Map<String, dynamic> _$CreateUserResponseToJson(CreateUserResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'user_id': instance.user_id,
    };

CreateSurveyResponse _$CreateSurveyResponseFromJson(
  Map<String, dynamic> json,
) => CreateSurveyResponse(
  (json['id'] as num?)?.toInt(),
  json['title'] as String?,
);

Map<String, dynamic> _$CreateSurveyResponseToJson(
  CreateSurveyResponse instance,
) => <String, dynamic>{'id': instance.id, 'title': instance.title};

CreateSurveyBaseResponse _$CreateSurveyBaseResponseFromJson(
  Map<String, dynamic> json,
) =>
    CreateSurveyBaseResponse(
        CreateSurveyResponse.fromJson(json['data'] as Map<String, dynamic>),
      )
      ..status = json['status'] as String?
      ..message = json['message'] as String?;

Map<String, dynamic> _$CreateSurveyBaseResponseToJson(
  CreateSurveyBaseResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

CreateSurveyQuestionsBaseResponse _$CreateSurveyQuestionsBaseResponseFromJson(
  Map<String, dynamic> json,
) =>
    CreateSurveyQuestionsBaseResponse(
        CreateSurveyQuestionsResponse.fromJson(
          json['data'] as Map<String, dynamic>,
        ),
      )
      ..status = json['status'] as String?
      ..message = json['message'] as String?;

Map<String, dynamic> _$CreateSurveyQuestionsBaseResponseToJson(
  CreateSurveyQuestionsBaseResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

CreateSurveyQuestionsResponse _$CreateSurveyQuestionsResponseFromJson(
  Map<String, dynamic> json,
) => CreateSurveyQuestionsResponse(
  (json['survey_id'] as num?)?.toInt(),
  (json['questions_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$CreateSurveyQuestionsResponseToJson(
  CreateSurveyQuestionsResponse instance,
) => <String, dynamic>{
  'survey_id': instance.survey_id,
  'questions_count': instance.questions_count,
};

GetSurveyResponse _$GetSurveyResponseFromJson(Map<String, dynamic> json) =>
    GetSurveyResponse(
      (json['id'] as num?)?.toInt(),
      json['title'] as String?,
      json['description'] as String?,
      json['color'] as String?,
    );

Map<String, dynamic> _$GetSurveyResponseToJson(GetSurveyResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'color': instance.color,
    };

GetAllSurveyBaseResponse _$GetAllSurveyBaseResponseFromJson(
  Map<String, dynamic> json,
) =>
    GetAllSurveyBaseResponse(
        (json['data'] as List<dynamic>)
            .map((e) => GetSurveyResponse.fromJson(e as Map<String, dynamic>))
            .toList(),
      )
      ..status = json['status'] as String?
      ..message = json['message'] as String?;

Map<String, dynamic> _$GetAllSurveyBaseResponseToJson(
  GetAllSurveyBaseResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

GetSurveyWithQuestionAndAnswerResponse
_$GetSurveyWithQuestionAndAnswerResponseFromJson(Map<String, dynamic> json) =>
    GetSurveyWithQuestionAndAnswerResponse(
      (json['id'] as num?)?.toInt(),
      json['title'] as String?,
      json['description'] as String?,
      json['color'] as String?,
      (json['questions'] as List<dynamic>?)
          ?.map(
            (e) => GetQuestionAndAnswerResponse.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );

Map<String, dynamic> _$GetSurveyWithQuestionAndAnswerResponseToJson(
  GetSurveyWithQuestionAndAnswerResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'color': instance.color,
  'questions': instance.questions,
};

GetSurveyWithQuestionAndAnswerByIdBaseResponse
_$GetSurveyWithQuestionAndAnswerByIdBaseResponseFromJson(
  Map<String, dynamic> json,
) =>
    GetSurveyWithQuestionAndAnswerByIdBaseResponse(
        GetSurveyWithQuestionAndAnswerResponse.fromJson(
          json['data'] as Map<String, dynamic>,
        ),
      )
      ..status = json['status'] as String?
      ..message = json['message'] as String?;

Map<String, dynamic> _$GetSurveyWithQuestionAndAnswerByIdBaseResponseToJson(
  GetSurveyWithQuestionAndAnswerByIdBaseResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

GetQuestionAndAnswerResponse _$GetQuestionAndAnswerResponseFromJson(
  Map<String, dynamic> json,
) => GetQuestionAndAnswerResponse(
  (json['id'] as num?)?.toInt(),
  json['question'] as String?,
  (json['question_order'] as num?)?.toInt(),
  json['is_required'] as bool?,
  json['type'] as String?,
  (json['answers'] as List<dynamic>)
      .map((e) => GetAnswerResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GetQuestionAndAnswerResponseToJson(
  GetQuestionAndAnswerResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'question': instance.question,
  'question_order': instance.question_order,
  'is_required': instance.is_required,
  'type': instance.type,
  'answers': instance.answers,
};

GetAnswerResponse _$GetAnswerResponseFromJson(Map<String, dynamic> json) =>
    GetAnswerResponse((json['id'] as num?)?.toInt(), json['title'] as String?);

Map<String, dynamic> _$GetAnswerResponseToJson(GetAnswerResponse instance) =>
    <String, dynamic>{'id': instance.id, 'title': instance.title};

GetSurveyWithQuestionAndAnswerBaseResponse
_$GetSurveyWithQuestionAndAnswerBaseResponseFromJson(
  Map<String, dynamic> json,
) =>
    GetSurveyWithQuestionAndAnswerBaseResponse(
        (json['data'] as List<dynamic>)
            .map(
              (e) => GetSurveyWithQuestionAndAnswerResponse.fromJson(
                e as Map<String, dynamic>,
              ),
            )
            .toList(),
      )
      ..status = json['status'] as String?
      ..message = json['message'] as String?;

Map<String, dynamic> _$GetSurveyWithQuestionAndAnswerBaseResponseToJson(
  GetSurveyWithQuestionAndAnswerBaseResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

CreateConferenceBaseResponse _$CreateConferenceBaseResponseFromJson(
  Map<String, dynamic> json,
) =>
    CreateConferenceBaseResponse(
        CreateConferenceResponse.fromJson(json['data'] as Map<String, dynamic>),
      )
      ..status = json['status'] as String?
      ..message = json['message'] as String?;

Map<String, dynamic> _$CreateConferenceBaseResponseToJson(
  CreateConferenceBaseResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

CreateConferenceResponse _$CreateConferenceResponseFromJson(
  Map<String, dynamic> json,
) => CreateConferenceResponse((json['id'] as num?)?.toInt());

Map<String, dynamic> _$CreateConferenceResponseToJson(
  CreateConferenceResponse instance,
) => <String, dynamic>{'id': instance.id};

GetAllConferenceResponse _$GetAllConferenceResponseFromJson(
  Map<String, dynamic> json,
) => GetAllConferenceResponse(
  (json['id'] as num?)?.toInt(),
  json['name'] as String?,
  json['description'] as String?,
  json['address'] as String?,
  json['start_date'] as String?,
  json['end_date'] as String?,
  json['is_active'] as bool?,
);

Map<String, dynamic> _$GetAllConferenceResponseToJson(
  GetAllConferenceResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'address': instance.address,
  'start_date': instance.start_date,
  'end_date': instance.end_date,
  'is_active': instance.is_active,
};

GetAllConferenceByIdResponse _$GetAllConferenceByIdResponseFromJson(
  Map<String, dynamic> json,
) => GetAllConferenceByIdResponse(
  (json['id'] as num?)?.toInt(),
  json['name'] as String?,
  json['description'] as String?,
  json['address'] as String?,
  json['start_date'] as String?,
  json['end_date'] as String?,
  json['is_active'] as bool?,
  (json['surveys'] as List<dynamic>)
      .map(
        (e) =>
            GetSurveyToConferenceResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$GetAllConferenceByIdResponseToJson(
  GetAllConferenceByIdResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'address': instance.address,
  'start_date': instance.start_date,
  'end_date': instance.end_date,
  'is_active': instance.is_active,
  'surveys': instance.surveys,
};

GetAllConferenceBaseResponse _$GetAllConferenceBaseResponseFromJson(
  Map<String, dynamic> json,
) =>
    GetAllConferenceBaseResponse(
        (json['data'] as List<dynamic>)
            .map(
              (e) =>
                  GetAllConferenceResponse.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
      )
      ..status = json['status'] as String?
      ..message = json['message'] as String?;

Map<String, dynamic> _$GetAllConferenceBaseResponseToJson(
  GetAllConferenceBaseResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

GetSurveyToConferenceResponse _$GetSurveyToConferenceResponseFromJson(
  Map<String, dynamic> json,
) => GetSurveyToConferenceResponse(
  (json['id'] as num?)?.toInt(),
  json['title'] as String?,
  json['description'] as String?,
  json['color'] as String?,
  (json['survey_order'] as num?)?.toInt(),
);

Map<String, dynamic> _$GetSurveyToConferenceResponseToJson(
  GetSurveyToConferenceResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'color': instance.color,
  'survey_order': instance.survey_order,
};

GetConferenceByIdBaseResponse _$GetConferenceByIdBaseResponseFromJson(
  Map<String, dynamic> json,
) =>
    GetConferenceByIdBaseResponse(
        GetAllConferenceByIdResponse.fromJson(
          json['data'] as Map<String, dynamic>,
        ),
      )
      ..status = json['status'] as String?
      ..message = json['message'] as String?;

Map<String, dynamic> _$GetConferenceByIdBaseResponseToJson(
  GetConferenceByIdBaseResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

GetSurveyWithActiveResponse _$GetSurveyWithActiveResponseFromJson(
  Map<String, dynamic> json,
) => GetSurveyWithActiveResponse(
  (json['id'] as num?)?.toInt(),
  json['title'] as String?,
  json['description'] as String?,
  json['color'] as String?,
  json['isActive'] as bool?,
);

Map<String, dynamic> _$GetSurveyWithActiveResponseToJson(
  GetSurveyWithActiveResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'color': instance.color,
  'isActive': instance.isActive,
};

GetAllSurveyWithActiveBaseResponse _$GetAllSurveyWithActiveBaseResponseFromJson(
  Map<String, dynamic> json,
) =>
    GetAllSurveyWithActiveBaseResponse(
        (json['data'] as List<dynamic>)
            .map(
              (e) => GetSurveyWithActiveResponse.fromJson(
                e as Map<String, dynamic>,
              ),
            )
            .toList(),
      )
      ..status = json['status'] as String?
      ..message = json['message'] as String?;

Map<String, dynamic> _$GetAllSurveyWithActiveBaseResponseToJson(
  GetAllSurveyWithActiveBaseResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

GetAllAsyncByConferenceIdBaseResponse
_$GetAllAsyncByConferenceIdBaseResponseFromJson(Map<String, dynamic> json) =>
    GetAllAsyncByConferenceIdBaseResponse(
        GetAsyncConferenceResponse.fromJson(
          json['data'] as Map<String, dynamic>,
        ),
      )
      ..status = json['status'] as String?
      ..message = json['message'] as String?;

Map<String, dynamic> _$GetAllAsyncByConferenceIdBaseResponseToJson(
  GetAllAsyncByConferenceIdBaseResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

GetAsyncConferenceResponse _$GetAsyncConferenceResponseFromJson(
  Map<String, dynamic> json,
) => GetAsyncConferenceResponse(
  GetAllConferenceResponse.fromJson(json['conference'] as Map<String, dynamic>),
  (json['survey'] as List<dynamic>)
      .map((e) => GetSurveyResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  (json['questions'] as List<dynamic>)
      .map(
        (e) => GetQuestionForAsyncResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  (json['answers'] as List<dynamic>)
      .map((e) => GetAnswerForAsyncResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  (json['survey_conference'] as List<dynamic>)
      .map(
        (e) => SurveyConferenceForAsyncResponse.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
);

Map<String, dynamic> _$GetAsyncConferenceResponseToJson(
  GetAsyncConferenceResponse instance,
) => <String, dynamic>{
  'conference': instance.conference,
  'survey': instance.survey,
  'questions': instance.questions,
  'answers': instance.answers,
  'survey_conference': instance.survey_conference,
};

GetQuestionForAsyncResponse _$GetQuestionForAsyncResponseFromJson(
  Map<String, dynamic> json,
) => GetQuestionForAsyncResponse(
  (json['id'] as num?)?.toInt(),
  json['question'] as String?,
  (json['question_order'] as num?)?.toInt(),
  json['is_required'] as bool?,
  json['type'] as String?,
  (json['survey_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$GetQuestionForAsyncResponseToJson(
  GetQuestionForAsyncResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'question': instance.question,
  'question_order': instance.question_order,
  'is_required': instance.is_required,
  'type': instance.type,
  'survey_id': instance.survey_id,
};

GetAnswerForAsyncResponse _$GetAnswerForAsyncResponseFromJson(
  Map<String, dynamic> json,
) => GetAnswerForAsyncResponse(
  (json['id'] as num?)?.toInt(),
  json['title'] as String?,
  (json['question_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$GetAnswerForAsyncResponseToJson(
  GetAnswerForAsyncResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'question_id': instance.question_id,
};

SurveyConferenceForAsyncResponse _$SurveyConferenceForAsyncResponseFromJson(
  Map<String, dynamic> json,
) => SurveyConferenceForAsyncResponse(
  (json['id'] as num?)?.toInt(),
  (json['survey_order'] as num?)?.toInt(),
  (json['survey_id'] as num?)?.toInt(),
  (json['conference_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$SurveyConferenceForAsyncResponseToJson(
  SurveyConferenceForAsyncResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'survey_order': instance.survey_order,
  'survey_id': instance.survey_id,
  'conference_id': instance.conference_id,
};
