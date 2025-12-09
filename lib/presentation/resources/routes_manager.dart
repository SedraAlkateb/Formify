import 'package:flutter/material.dart';
import 'package:formify/app/di.dart';
import 'package:formify/presentation/conference/pages/create_conference_page.dart';
import 'package:formify/presentation/onboarding/pages/onboarding_page.dart';
import 'package:formify/presentation/resources/strings_manager.dart';
import 'package:formify/presentation/survey/pages/create_survey_page.dart';

class Routes {
  static const String onboarding = "/onboarding";
  static const String home = "/home";
  static const String createConference = "/createConference";
  static const String createSurvey = "/createSurvey";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onboarding:
        initOnBoardingModule();
        return MaterialPageRoute(builder: (_) => OnBoardingPage());
      case Routes.createConference:
        return MaterialPageRoute(builder: (_) => CreateConferencePage());
      case Routes.createSurvey:
        return MaterialPageRoute(builder: (_) => CreateSurveyPage());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text(
            StringsManager.noRouteFound,
          ), // string to strings manager
        ),
        body: const Center(
          child: Text(StringsManager.noRouteFound),
        ), //string to strings manager
      ),
    );
  }
}
