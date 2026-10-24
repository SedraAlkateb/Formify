import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formify/data/network/error_handler.dart';

// دالة مساعدة: تبني خطأ Dio بنوع محدد حتى لا نكرر الكود في كل اختبار.
DioException _dioError(
  DioExceptionType type, {
  Response? response,
  String? message,
}) {
  return DioException(
    requestOptions: RequestOptions(path: '/test'),
    type: type,
    response: response,
    message: message,
  );
}

// استجابة وهمية من الخادم بحالة وجسم نختارهما نحن.
Response _response(int status, dynamic data) {
  return Response(
    requestOptions: RequestOptions(path: '/test'),
    statusCode: status,
    data: data,
  );
}

void main() {
  group('DataSource.getFailure', () {
    test('every DataSource has a non-empty message', () {
      for (final ds in DataSource.values) {
        expect(ds.getFailure().massage, isNotEmpty, reason: '$ds');
      }
    });

    test('local error codes are unique', () {
      final codes = [
        ResponseCode.CONNECT_TIOMOUT,
        ResponseCode.CANCEL,
        ResponseCode.RECIEVE_TIMEOUT,
        ResponseCode.SEND_TIMOUT,
        ResponseCode.CACHE_ERROR,
        ResponseCode.NO_INTERNET_CONNECTION,
        ResponseCode.DEFAULT,
      ];
      expect(codes.toSet().length, codes.length);
    });

    test('DEFAULT does not collide with SYNTAX_ERROR', () {
      expect(ResponseCode.DEFAULT, isNot(ResponseCode.SYNTAX_ERROR));
    });

    test('NOT_FOUND message differs from FORBIDDEN message', () {
      expect(ResponseMassage.NOT_FOUND, isNot(ResponseMassage.FORBIDDEN));
    });
  });

  group('ErrorHandler.handle with DioException', () {
    test('maps timeout/connection/cancel types to local codes', () {
      final expected = {
        DioExceptionType.connectionTimeout: ResponseCode.CONNECT_TIOMOUT,
        DioExceptionType.sendTimeout: ResponseCode.SEND_TIMOUT,
        DioExceptionType.receiveTimeout: ResponseCode.RECIEVE_TIMEOUT,
        DioExceptionType.connectionError: ResponseCode.NO_INTERNET_CONNECTION,
        DioExceptionType.cancel: ResponseCode.CANCEL,
      };
      expected.forEach((type, code) {
        expect(ErrorHandler.handle(_dioError(type)).failure.code, code,
            reason: '$type');
      });
    });

    test('badResponse uses server "message" and the HTTP status', () {
      final f = ErrorHandler.handle(_dioError(
        DioExceptionType.badResponse,
        response: _response(422, {'message': 'invalid'}),
      )).failure;
      expect(f.code, 422);
      expect(f.massage, 'invalid');
    });

    test('badResponse falls back to the "error" key', () {
      final f = ErrorHandler.handle(_dioError(
        DioExceptionType.badResponse,
        response: _response(400, {'error': 'boom'}),
      )).failure;
      expect(f.massage, 'boom');
    });

    test('badResponse with a plain-text body keeps the status code', () {
      final f = ErrorHandler.handle(_dioError(
        DioExceptionType.badResponse,
        response: _response(500, '<html>Server error</html>'),
      )).failure;
      expect(f.code, 500);
    });

    test('badResponse with a map lacking message keys keeps the status', () {
      final f = ErrorHandler.handle(_dioError(
        DioExceptionType.badResponse,
        response: _response(500, {'foo': 'bar'}),
      )).failure;
      expect(f.code, 500);
    });
  });

  group('ErrorHandler.handle with other errors', () {
    test('FormatException maps to code 0 and keeps its message', () {
      final f = ErrorHandler.handle(const FormatException('bad', 'src')).failure;
      expect(f.code, 0);
      expect(f.massage, contains('bad'));
    });

    test('any other exception becomes a generic failure', () {
      final f = ErrorHandler.handle(Exception('oops')).failure;
      expect(f.massage, contains('oops'));
    });
  });
}
