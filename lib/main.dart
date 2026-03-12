import 'package:flutter/material.dart';
import 'package:formify/app/app.dart';
import 'package:formify/app/di.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await initAppModule();
  runApp(const MyApp());
}
