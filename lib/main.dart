import 'dart:io';
import 'package:flutter/material.dart';
import 'package:formify/app/app.dart';
import 'package:formify/app/app_preferences.dart';
import 'package:formify/app/constants.dart';
import 'package:formify/app/di.dart';

void main() async {

   WidgetsFlutterBinding.ensureInitialized();
   await initAppModule();
    final appPreferences = instance<AppPreferences>();
   Constants.isLogin = appPreferences.routLogin();
//   HttpOverrides.global = MyHttpOverrides();


  runApp(const MyApp());
}

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }
