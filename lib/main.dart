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
  runApp(const MyApp());
}
