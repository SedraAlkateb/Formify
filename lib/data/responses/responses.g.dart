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

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse((json['data'] as num?)?.toInt())
      ..status = json['status'] as String?
      ..message = json['message'] as String?;

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };
