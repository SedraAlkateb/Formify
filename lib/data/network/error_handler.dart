import 'package:dio/dio.dart';
import 'package:formify/data/network/failure.dart';

class ErrorHandler implements Exception {
  late Failure failure;
  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      failure = _handleError(error);
    } else if (error is FormatException) {
      failure = DataSource.DEFAULT.getFailure();
    } else {
      failure = DataSource.DEFAULT.getFailure();
    }
  }
}

/// يستخرج رسالة مقروءة من جسم الاستجابة مهما كان نوعه (Map / String / غيره).
String _extractMessage(dynamic body) {
  if (body is Map) {
    final m = body['message'] ?? body['error'];
    if (m is String && m.trim().isNotEmpty) return m;
  } else if (body is String && body.trim().isNotEmpty && body.length < 200) {
    return body;
  }
  return ResponseMassage.DEFAULT;
}

Failure _handleError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return DataSource.CONNECT_TIOMOUT.getFailure();
    case DioExceptionType.sendTimeout:
      return DataSource.SEND_TIMOUT.getFailure();
    case DioExceptionType.connectionError:
      return DataSource.NO_INTERNET_CONNECTION.getFailure();
    case DioExceptionType.receiveTimeout:
      return DataSource.RECIEVE_TIMEOUT.getFailure();
    case DioExceptionType.badCertificate:
      return DataSource.DEFAULT.getFailure();
    case DioExceptionType.badResponse:
      final code = error.response?.statusCode ?? ResponseCode.DEFAULT;
      return Failure(code, _extractMessage(error.response?.data));
    case DioExceptionType.cancel:
      return DataSource.CANCEL.getFailure();
    case DioExceptionType.unknown:
      return DataSource.DEFAULT.getFailure();
  }
}

enum DataSource {
  SUCCESS,
  NO_CONTENT,
  BAD_REQUEST,
  FORBIDDEN,
  UNAUTORISED,
  NOT_FOUND,
  INTERNAL_SERVER_ERROR,
//  Unprocessable_Content,

  CONNECT_TIOMOUT,
  CANCEL,
  RECIEVE_TIMEOUT,
  SEND_TIMOUT,
  CACHE_ERROR,

  NO_INTERNET_CONNECTION,
  DEFAULT,
}

extension DataSouceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.SUCCESS:
        return Failure(ResponseCode.SUCCESS, ResponseMassage.SUCCESS);
      case DataSource.NO_CONTENT:
        return Failure(ResponseCode.NO_CONTENT, ResponseMassage.NO_CONTENT);

      case DataSource.BAD_REQUEST:
        return Failure(ResponseCode.BAD_REQUEST, ResponseMassage.BAD_REQUEST);

      case DataSource.FORBIDDEN:
        return Failure(ResponseCode.FORBIDDEN, ResponseMassage.FORBIDDEN);

      case DataSource.UNAUTORISED:
        return Failure(ResponseCode.UNAUTORISED, ResponseMassage.UNAUTORISED);

      case DataSource.NOT_FOUND:
        return Failure(ResponseCode.NOT_FOUND, ResponseMassage.NOT_FOUND);

      case DataSource.INTERNAL_SERVER_ERROR:
        return Failure(ResponseCode.INTERNAL_SERVER_ERROR,
            ResponseMassage.INTERNAL_SERVER_ERROR);
      case DataSource.CONNECT_TIOMOUT:
        return Failure(
            ResponseCode.CONNECT_TIOMOUT, ResponseMassage.CONNECT_TIOMOUT);
      case DataSource.CANCEL:
        return Failure(ResponseCode.CANCEL, ResponseMassage.CANCEL);
      case DataSource.RECIEVE_TIMEOUT:
        return Failure(
            ResponseCode.RECIEVE_TIMEOUT, ResponseMassage.RECIEVE_TIMEOUT);
      case DataSource.SEND_TIMOUT:
        return Failure(ResponseCode.SEND_TIMOUT, ResponseMassage.SEND_TIMOUT);
      case DataSource.CACHE_ERROR:
        return Failure(ResponseCode.CACHE_ERROR, ResponseMassage.CACHE_ERROR);
      case DataSource.NO_INTERNET_CONNECTION:
        return Failure(ResponseCode.NO_INTERNET_CONNECTION,
            ResponseMassage.NO_INTERNET_CONNECTION);
      case DataSource.DEFAULT:
        return Failure(ResponseCode.DEFAULT, ResponseMassage.DEFAULT);
    }
  }
}

class ResponseCode {
  static const int SUCCESS = 200; //success with data
  static const int NO_CONTENT = 201; //success with no data (no content)
  static const int BAD_REQUEST = 400; //failure ,Api rejected request
  static const int UNAUTORISED = 401; //failure,user is not authorised
  static const int FORBIDDEN = 403; //failure ,Api rejected request
  static const int NOT_FOUND = 404;
  // static const int Unprocessable_Content =422;//success with no data (no content)

  static const int INTERNAL_SERVER_ERROR = 500; //failure,crash in server side
//local status code

  static const int CONNECT_TIOMOUT = -1; //
  static const int CANCEL = -2; //
  static const int RECIEVE_TIMEOUT = -3; //
  static const int SEND_TIMOUT = -4; //
  static const int CACHE_ERROR = -5; //
  static const int NO_INTERNET_CONNECTION = -6; //
  static const int SYNTAX_ERROR = -7; //
  static const int READ_ONLY = -8; //
  static const int DB_LOCKED = -9; //
  static const int TABLE_NOT_FOUND = -10; //
  static const int CONSTRAINT_VIOLATION = -11; //

  static const int DEFAULT = -7;
}

class ResponseMassage {
  static const String SUCCESS = "success"; //success with data
  static const String NO_CONTENT =
      "success"; //success with no data (no content)
  static const String BAD_REQUEST =
      "طلب غير صالح، يرجى المحاولة لاحقاً"; //failure ,Api rejected request
  static const String UNAUTORISED =
      "غير مصرح لك بتنفيذ هذه العملية"; //failure,user is not authorised
  static const String FORBIDDEN =
      "ليس لديك صلاحية لتنفيذ هذا الطلب"; //failure ,Api rejected request
  static const String INTERNAL_SERVER_ERROR =
      "حدث خطأ, يرجى إعادة المحاولة"; //failure,crash in server side
  static const String NOT_FOUND = "المورد المطلوب غير موجود";
  // static const String Unprocessable_Content ="Unprocessable Content";//success with no data (no content)

//local status code

  static const String CONNECT_TIOMOUT = "انتهت مهلة الاتصال، يرجى المحاولة لاحقاً";
  static const String CANCEL = "تم إلغاء الطلب";
  static const String RECIEVE_TIMEOUT = "انتهت مهلة الاتصال، يرجى المحاولة لاحقاً";
  static const String SEND_TIMOUT = "انتهت مهلة الاتصال، يرجى المحاولة لاحقاً";
  static const String CACHE_ERROR = "حدث خطأ في البيانات المحفوظة";
  static const String NO_INTERNET_CONNECTION =
      "يرجى التأكد من اتصالك بالانترنت";
  static const String DEFAULT = "حدث خطأ, يرجى إعادة المحاولة";
}
class ApiInternalStatus {
  static const String SUCCESS = "success";
  static const int FAILURE = 0;
}
