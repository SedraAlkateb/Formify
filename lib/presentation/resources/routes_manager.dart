import 'package:flutter/material.dart';
import 'package:formify/app/di.dart';
import 'package:formify/presentation/conference/pages/all_active_conference.dart';
import 'package:formify/presentation/conference/pages/all_conference.dart';
import 'package:formify/presentation/conference/pages/conference_survey_by_id.dart';
import 'package:formify/presentation/conference/pages/create_conference_page.dart';
import 'package:formify/presentation/conference/pages/view_conference_page.dart';
import 'package:formify/presentation/home/pages/home_page.dart';
import 'package:formify/presentation/onboarding/pages/onboarding_page.dart';
import 'package:formify/presentation/question/page/checkbox.dart';
import 'package:formify/presentation/question/page/multiple_choice.dart';
import 'package:formify/presentation/question/page/switch.dart';
import 'package:formify/presentation/question/page/text.dart';
import 'package:formify/presentation/resources/strings_manager.dart';
import 'package:formify/presentation/survey/pages/create_ques_survey_page.dart';
import 'package:formify/presentation/survey/pages/create_survey_page.dart';
import 'package:formify/presentation/survey/pages/view_all_survey_page.dart';
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
  static const String conferenceSurveyById = "/conferenceSurveyById";
  static const String getAllConference = "/getAllConference";
  static const String getAllActiveConference = "/getAllActiveConference";
  static const String viewConference = "/viewConference";
  static const String viewSurvey = "/viewSurvey";
  static const String dropDownQuestion = "/dropDownQuestion";
  static const String getAllSurvey = "/getAllSurvey";

}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {

      case Routes.onboarding:
        initOnBoardingModule();
        return _animatedRoute(OnBoardingPage());

      case Routes.home:
        initConferenceModule();
        return _animatedRoute(HomePage());

      case Routes.createConference:
        initConferenceModule();
        return _animatedRoute(CreateConferencePage());

      case Routes.createSurvey:
        initSurveyModule();
        return _animatedRoute(CreateSurveyPage());

      case Routes.createQuesSurvey:
        return _animatedRoute(CreateQuesSurveyPage());

      case Routes.viewSurvey:
        return _animatedRoute(ViewSurvey());

      case Routes.viewConference:
        return _animatedRoute(ViewConferencePage());

      case Routes.textQuestion:
        return _animatedRoute(TextQuestionPage());

      case Routes.multipleChoiceQuestion:
        return _animatedRoute(MultipleChoicePage());

      case Routes.checkboxQuestion:
        return _animatedRoute(CheckboxPage());

      case Routes.conferenceSurveyById:
        final conferenceId = settings.arguments as int;
        return _animatedRoute(
          ConferenceSurveyById(conferenceId: conferenceId),
        );

      case Routes.getAllConference:
        initConferenceModule();
        return _animatedRoute(AllConferencePage());

      case Routes.getAllActiveConference:
        return _animatedRoute(AllActiveConferencePage());

      case Routes.switchQuestion:
        return _animatedRoute(SwitchQuestionPage());
      case Routes.getAllSurvey:
        initSurveyModule();
        return _animatedRoute(ViewAllSurveyPage());

      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return _animatedRoute(Scaffold(
      appBar: AppBar(
        title: const Text(StringsManager.noRouteFound),
      ),
      body: const Center(
        child: Text(StringsManager.noRouteFound),
      ),
    ));
  }

  static Route<dynamic> _animatedRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 600),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final begin = const Offset(1.0, 0.0);  // تغيير الاتجاه إلى اليمين لليسار
        final end = Offset.zero;
        final curve = Curves.easeInOut;
        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }
}
