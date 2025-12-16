import 'package:flutter/material.dart';
import 'package:formify/app/di.dart';
import 'package:formify/presentation/conference/pages/create_conference_page.dart';
import 'package:formify/presentation/onboarding/pages/onboarding_page.dart';
import 'package:formify/presentation/question/page/drop_down.dart';
import 'package:formify/presentation/question/page/text.dart';
import 'package:formify/presentation/resources/strings_manager.dart';
import 'package:formify/presentation/survey/pages/create_ques_survey_page.dart';
import 'package:formify/presentation/survey/pages/create_survey_page.dart';
import 'package:formify/presentation/survey/pages/view_survey.dart';

class Routes {
  static const String onboarding = "/onboarding";
  static const String home = "/home";
  static const String createConference = "/createConference";
  static const String createSurvey = "/createSurvey";
  static const String createQuesSurvey = "/createQuesSurvey";
  static const String textQuestion = "/textQuestion";
  static const String viewSurvey = "/viewSurvey";
  static const String dropDownQuestion = "/dropDownQuestion";

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
        initSurveyModule();
        return MaterialPageRoute(builder: (_) => CreateSurveyPage());
      case Routes.createQuesSurvey:
        return MaterialPageRoute(builder: (_) => CreateQuesSurveyPage());
      case Routes.viewSurvey:
        return MaterialPageRoute(builder: (_) => ViewSurvey());
      case Routes.dropDownQuestion:
        // final args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => DropDownQuestionPage(
            // name: args["name"],
            // valid: args["valid"],
          ),
        );
      case Routes.textQuestion:
      // final args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => TextQuestionPage(
            // name: args["name"],
            // valid: args["valid"],
          ),
        );

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
