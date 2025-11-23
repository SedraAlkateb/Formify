import 'package:json_annotation/json_annotation.dart';
part 'responses.g.dart';

@JsonSerializable()
class BaseResponse {
  @JsonKey(name: "status")
  String? status;
  @JsonKey(name: "message")
  String? message;
}

//////////ForMessage
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
class LoginResponse extends BaseResponse {
  LoginResponse();
  // from json
  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  // to json
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
