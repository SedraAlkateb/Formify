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
      json['timer'] as String?,
    );

Map<String, dynamic> _$GetSurveyResponseToJson(GetSurveyResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'color': instance.color,
      'timer': instance.timer,
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
      json['timer'] as String?,
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
  'timer': instance.timer,
  'questions': instance.questions,
};

GetSurveyWithQuestionAndAnswerForUserResponse
_$GetSurveyWithQuestionAndAnswerForUserResponseFromJson(
  Map<String, dynamic> json,
) => GetSurveyWithQuestionAndAnswerForUserResponse(
  (json['id'] as num?)?.toInt(),
  json['title'] as String?,
  json['description'] as String?,
  json['color'] as String?,
  (json['questions'] as List<dynamic>?)
      ?.map(
        (e) => GetQuestionAndAnswerForUserResponse.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
)..timer = json['timer'] as String?;

Map<String, dynamic> _$GetSurveyWithQuestionAndAnswerForUserResponseToJson(
  GetSurveyWithQuestionAndAnswerForUserResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'color': instance.color,
  'timer': instance.timer,
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

GetQuestionAndAnswerForUserResponse
_$GetQuestionAndAnswerForUserResponseFromJson(Map<String, dynamic> json) =>
    GetQuestionAndAnswerForUserResponse(
      (json['id'] as num?)?.toInt(),
      json['question'] as String?,
      (json['question_order'] as num?)?.toInt(),
      json['is_required'] as bool?,
      json['type'] as String?,
      (json['answers'] as List<dynamic>?)
          ?.map((e) => GetAnswerResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['user_answers'] as List<dynamic>?)
          ?.map(
            (e) => GetAnswerUserResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$GetQuestionAndAnswerForUserResponseToJson(
  GetQuestionAndAnswerForUserResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'question': instance.question,
  'question_order': instance.question_order,
  'is_required': instance.is_required,
  'type': instance.type,
  'answers': instance.answers,
  'user_answers': instance.answersUser,
};

GetAnswerUserResponse _$GetAnswerUserResponseFromJson(
  Map<String, dynamic> json,
) => GetAnswerUserResponse(
  (json['id'] as num?)?.toInt(),
  (json['answer_id'] as num?)?.toInt(),
  json['content'] as String?,
  (json['isCorrect'] as num?)?.toInt(),
);

Map<String, dynamic> _$GetAnswerUserResponseToJson(
  GetAnswerUserResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'answer_id': instance.answer_id,
  'content': instance.content,
  'isCorrect': instance.isCorrect,
};

GetAnswerResponse _$GetAnswerResponseFromJson(Map<String, dynamic> json) =>
    GetAnswerResponse(
      (json['id'] as num?)?.toInt(),
      json['title'] as String?,
      json['img'] as String?,
      (json['isCorrect'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GetAnswerResponseToJson(GetAnswerResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'img': instance.img,
      'isCorrect': instance.isCorrect,
    };

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

GetSurveyWithQuestionAndAnswerForUserBaseResponse
_$GetSurveyWithQuestionAndAnswerForUserBaseResponseFromJson(
  Map<String, dynamic> json,
) =>
    GetSurveyWithQuestionAndAnswerForUserBaseResponse(
        GetSurveyWithQuestionAndAnswerForUserResponse.fromJson(
          json['data'] as Map<String, dynamic>,
        ),
      )
      ..status = json['status'] as String?
      ..message = json['message'] as String?;

Map<String, dynamic> _$GetSurveyWithQuestionAndAnswerForUserBaseResponseToJson(
  GetSurveyWithQuestionAndAnswerForUserBaseResponse instance,
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
  json['isActive'] as bool?,
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
  'isActive': instance.is_active,
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
)..timer = json['timer'] as String?;

Map<String, dynamic> _$GetSurveyToConferenceResponseToJson(
  GetSurveyToConferenceResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'color': instance.color,
  'timer': instance.timer,
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
  json['is_active'] as bool?,
)..timer = json['timer'] as String?;

Map<String, dynamic> _$GetSurveyWithActiveResponseToJson(
  GetSurveyWithActiveResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'color': instance.color,
  'timer': instance.timer,
  'is_active': instance.isActive,
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
  json['title'] as String?,
  (json['order'] as num?)?.toInt(),
  json['isRequired'] as bool?,
  json['type'] as String?,
  (json['survey_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$GetQuestionForAsyncResponseToJson(
  GetQuestionForAsyncResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.question,
  'order': instance.question_order,
  'isRequired': instance.is_required,
  'type': instance.type,
  'survey_id': instance.survey_id,
};

GetAnswerForAsyncResponse _$GetAnswerForAsyncResponseFromJson(
  Map<String, dynamic> json,
) => GetAnswerForAsyncResponse(
  (json['id'] as num?)?.toInt(),
  json['title'] as String?,
  (json['question_id'] as num?)?.toInt(),
  json['img'] as String?,
  (json['isCorrect'] as num?)?.toInt(),
);

Map<String, dynamic> _$GetAnswerForAsyncResponseToJson(
  GetAnswerForAsyncResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'question_id': instance.question_id,
  'img': instance.img,
  'isCorrect': instance.isCorrect,
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

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
  (json['id'] as num?)?.toInt(),
  json['fullname'] as String?,
  json['email'] as String?,
  json['phone'] as String?,
  json['address'] as String?,
);

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullname': instance.fullName,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
    };

GetAllUserBaseResponse _$GetAllUserBaseResponseFromJson(
  Map<String, dynamic> json,
) =>
    GetAllUserBaseResponse(
        (json['data'] as List<dynamic>)
            .map((e) => UserResponse.fromJson(e as Map<String, dynamic>))
            .toList(),
      )
      ..status = json['status'] as String?
      ..message = json['message'] as String?;

Map<String, dynamic> _$GetAllUserBaseResponseToJson(
  GetAllUserBaseResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

UserAnswerForStatResponse _$UserAnswerForStatResponseFromJson(
  Map<String, dynamic> json,
) => UserAnswerForStatResponse(
  (json['question-id'] as num?)?.toInt(),
  json['question'] as String?,
  json['content'] as String?,
);

Map<String, dynamic> _$UserAnswerForStatResponseToJson(
  UserAnswerForStatResponse instance,
) => <String, dynamic>{
  'question-id': instance.questionId,
  'question': instance.question,
  'content': instance.content,
};

UserAndAnswersResponse _$UserAndAnswersResponseFromJson(
  Map<String, dynamic> json,
) => UserAndAnswersResponse(
  UserResponse.fromJson(json['user-Information'] as Map<String, dynamic>),
  (json['user-answers'] as List<dynamic>)
      .map((e) => UserAnswerForStatResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UserAndAnswersResponseToJson(
  UserAndAnswersResponse instance,
) => <String, dynamic>{
  'user-Information': instance.userInformation,
  'user-answers': instance.userAnswers,
};

StatisticsForUsersAnswersResponse _$StatisticsForUsersAnswersResponseFromJson(
  Map<String, dynamic> json,
) => StatisticsForUsersAnswersResponse(
  (json['survey-questions'] as List<dynamic>)
      .map((e) => SurveyQuestionResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  (json['users-answers'] as List<dynamic>)
      .map((e) => UserAndAnswersResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$StatisticsForUsersAnswersResponseToJson(
  StatisticsForUsersAnswersResponse instance,
) => <String, dynamic>{
  'survey-questions': instance.surveyQuestions,
  'users-answers': instance.usersAnswers,
};

SurveyQuestionResponse _$SurveyQuestionResponseFromJson(
  Map<String, dynamic> json,
) => SurveyQuestionResponse(
  (json['id'] as num?)?.toInt(),
  json['question'] as String?,
  json['type'] as String?,
);

Map<String, dynamic> _$SurveyQuestionResponseToJson(
  SurveyQuestionResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'question': instance.question,
  'type': instance.type,
};

StatisticsForUsersAnswersBaseResponse
_$StatisticsForUsersAnswersBaseResponseFromJson(Map<String, dynamic> json) =>
    StatisticsForUsersAnswersBaseResponse(
        StatisticsForUsersAnswersResponse.fromJson(
          json['data'] as Map<String, dynamic>,
        ),
      )
      ..status = json['status'] as String?
      ..message = json['message'] as String?;

Map<String, dynamic> _$StatisticsForUsersAnswersBaseResponseToJson(
  StatisticsForUsersAnswersBaseResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

GetQuestionForStatResponse _$GetQuestionForStatResponseFromJson(
  Map<String, dynamic> json,
) => GetQuestionForStatResponse(
  (json['id'] as num?)?.toInt(),
  json['question_text'] as String?,
  (json['question_order'] as num?)?.toInt(),
  json['is_required'] as bool?,
  json['type'] as String?,
  (json['survey_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$GetQuestionForStatResponseToJson(
  GetQuestionForStatResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'question_text': instance.question_text,
  'question_order': instance.question_order,
  'is_required': instance.is_required,
  'type': instance.type,
  'survey_id': instance.survey_id,
};

UserAnswerStatResponse _$UserAnswerStatResponseFromJson(
  Map<String, dynamic> json,
) => UserAnswerStatResponse(
  (json['user_answer_id'] as num?)?.toInt(),
  json['content'] as String?,
);

Map<String, dynamic> _$UserAnswerStatResponseToJson(
  UserAnswerStatResponse instance,
) => <String, dynamic>{
  'user_answer_id': instance.user_answer_id,
  'content': instance.content,
};

StatisticStatResponse _$StatisticStatResponseFromJson(
  Map<String, dynamic> json,
) => StatisticStatResponse(
  (json['answer_id'] as num?)?.toInt(),
  json['title'] as String?,
  (json['count'] as num?)?.toInt(),
  (json['total'] as num?)?.toInt(),
);

Map<String, dynamic> _$StatisticStatResponseToJson(
  StatisticStatResponse instance,
) => <String, dynamic>{
  'answer_id': instance.answer_id,
  'title': instance.title,
  'count': instance.count,
  'total': instance.total,
};

QuestionsStatResponse _$QuestionsStatResponseFromJson(
  Map<String, dynamic> json,
) => QuestionsStatResponse(
  GetQuestionForStatResponse.fromJson(json['question'] as Map<String, dynamic>),
  (json['user-answers'] as List<dynamic>)
      .map((e) => UserAnswerStatResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  (json['statistics'] as List<dynamic>)
      .map((e) => StatisticStatResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QuestionsStatResponseToJson(
  QuestionsStatResponse instance,
) => <String, dynamic>{
  'question': instance.question,
  'user-answers': instance.userAnswers,
  'statistics': instance.statistics,
};

QuestionsStatisticsBaseResponse _$QuestionsStatisticsBaseResponseFromJson(
  Map<String, dynamic> json,
) =>
    QuestionsStatisticsBaseResponse(
        (json['data'] as List<dynamic>)
            .map(
              (e) => QuestionsStatResponse.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
      )
      ..status = json['status'] as String?
      ..message = json['message'] as String?;

Map<String, dynamic> _$QuestionsStatisticsBaseResponseToJson(
  QuestionsStatisticsBaseResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};
