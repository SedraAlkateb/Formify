import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:formify/app/app.dart';
import 'package:formify/app/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _setupAppRequirements();

  runApp(
    Phoenix(
      child: const MyApp(),
    ),
  );
}

Future<void> _setupAppRequirements() async {
  await ScreenUtil.ensureScreenSize();

  await initAppModule();

  HttpOverrides.global = MyHttpOverrides();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}