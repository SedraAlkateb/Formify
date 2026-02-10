import 'package:flutter/material.dart';
import 'package:formify/app/app_preferences.dart';
import 'package:formify/app/di.dart';
import 'package:formify/presentation/resources/routes_manager.dart';

class FinishedInputSurveys extends StatelessWidget {
  const FinishedInputSurveys({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              onPressed:(){

                Navigator.pushNamedAndRemoveUntil(context, Routes.showConference, (route) => false,);
                instance<AppPreferences>().setLoggedIn(2);
              }, child: Text("data"))
        ],
      ),
    );
  }
}
