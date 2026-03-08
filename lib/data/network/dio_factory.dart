import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:formify/app/constants.dart';
import 'package:formify/data/network/error_handler.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// هذه الاستيرادات فقط لغير الويب
import 'dart:io' show HttpClient, X509Certificate;
import 'package:dio/io.dart' show IOHttpClientAdapter;

const String applicationJson = "application/json";
const String multipart = "multipart/form-data";
const String contentType = "content-type";
const String accept = "accept";
const String authorization = "authorization";
const String defaultLanguage = "lang";

class DioFactory {
  DioFactory();

  Future<Dio> getDio() async {
    final dio = Dio();

    // هذا الجزء يعمل فقط خارج الويب
    if (!kIsWeb) {
      final adapter = dio.httpClientAdapter;
      if (adapter is IOHttpClientAdapter) {
        adapter.createHttpClient = () {
          final client = HttpClient();
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        };
      }
    }

    final String to = "";
    final String token = "Bearer $to";
    final String language = "ar";

    final headers = <String, String>{
      contentType: multipart,
      accept: applicationJson,
      "X-Requested-With": "XMLHttpRequest",
      authorization: token,
      defaultLanguage: language,
    };

    dio.options = BaseOptions(
      baseUrl: Constants.baseUrl,
      headers: headers,
      connectTimeout: const Duration(seconds: 50),
      receiveTimeout: const Duration(seconds: 50),
    );

    dio.interceptors.add(MyApiInterceptor());

    if (!kReleaseMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      );
    }

    return dio;
  }
}

class MyApiInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final String authToken = "";
    final String lang = "en";

    options.headers['Authorization'] = "Bearer $authToken";
    options.headers['lang'] = lang;

    return handler.next(options);
  }

  @override
  void onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {
    debugPrint(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );

    if (err.response?.statusCode == ResponseCode.UNAUTORISED) {
      // refresh token logic
    }

    super.onError(err, handler);
  }

  final Dio client = Dio();
}