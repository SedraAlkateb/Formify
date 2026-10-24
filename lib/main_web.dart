import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:formify/web_form/web_form_page.dart';

/// Web entry point for the public fill-in form.
/// Build: flutter build web -t lib/main_web.dart
/// Link:  https://host/?t=TOKEN   (use ?t=demo for sample data)
void main() {
  final token = Uri.base.queryParameters['t'] ?? '';
  runApp(WebFormApp(token: token));
}

class WebFormApp extends StatelessWidget {
  final String token;
  const WebFormApp({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Formify',
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Tajawal',
        colorSchemeSeed: const Color(0xFF3F7FBF),
      ),
      home: token.isEmpty
          ? const Scaffold(body: Center(child: Text('الرابط غير صالح')))
          : WebFormPage(token: token),
    );
  }
}
