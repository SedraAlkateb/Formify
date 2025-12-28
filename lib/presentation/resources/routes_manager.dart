import 'package:flutter/material.dart';
import 'package:formify/app/di.dart';
import 'package:formify/presentation/conference/pages/all_conference.dart';
import 'package:formify/presentation/conference/pages/conference_survey_by_id.dart';
import 'package:formify/presentation/conference/pages/create_conference_page.dart';
import 'package:formify/presentation/conference/pages/ds.dart';
import 'package:formify/presentation/home/pages/home_page.dart';
import 'package:formify/presentation/onboarding/pages/onboarding_page.dart';
import 'package:formify/presentation/question/page/checkbox.dart';
import 'package:formify/presentation/question/page/drop_down.dart';
import 'package:formify/presentation/question/page/multiple_choice.dart';
import 'package:formify/presentation/question/page/switch.dart';
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
  static const String multipleChoiceQuestion = "/multipleChoiceQuestion";
  static const String checkboxQuestion = "/checkboxQuestion";
  static const String switchQuestion = "/switchQuestion";
  static const String  conferenceSurveyById = "/ conferenceSurveyById";
  static const String getAllConference = "/getAllConference";

  static const String viewSurvey = "/viewSurvey";
  static const String dropDownQuestion = "/dropDownQuestion";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {

      case Routes.onboarding:
        initOnBoardingModule();
        return MaterialPageRoute(builder: (_) => OnBoardingPage());
      case Routes.home:
        initConferenceModule();
        return MaterialPageRoute(builder: (_) => HomePage());
      case Routes.createConference:
        initConferenceModule();
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

        return MaterialPageRoute(builder: (_) => DropDownQuestionPage());
      case Routes.textQuestion:
        return MaterialPageRoute(builder: (_) => TextQuestionPage());
      case Routes.multipleChoiceQuestion:
        return MaterialPageRoute(builder: (_) => MultipleChoicePage());
      case Routes.checkboxQuestion:
        return MaterialPageRoute(builder: (_) => CheckboxPage());
      case Routes.conferenceSurveyById:
        return MaterialPageRoute(builder: (_) => ConferenceSurveyById());
      case Routes.getAllConference:
        initConferenceModule();
        return MaterialPageRoute(builder: (_) => AllConferencePage());
      case Routes.switchQuestion:

        return MaterialPageRoute(builder: (_) => SwitchQuestionPage());
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
