import 'package:flutter/material.dart';
import 'package:formify/app/di.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/active_conference/page/all_active_conference.dart';
import 'package:formify/presentation/active_conference/page/view_active_conference_page.dart';
import 'package:formify/presentation/active_conference/page/view_completed_survey.dart';
import 'package:formify/presentation/conference/pages/Update_conference_page.dart';
import 'package:formify/presentation/conference/pages/link_survey_by_id.dart';
import 'package:formify/presentation/conference/pages/create_conference_page.dart';
import 'package:formify/presentation/conference/pages/view_conference_page.dart';
import 'package:formify/presentation/active_conference/page/view_user_survey.dart';
import 'package:formify/presentation/excel/page/exel_page.dart';
import 'package:formify/presentation/excel/page/survey_dashboard.dart';
import 'package:formify/presentation/home/pages/home_page.dart';
import 'package:formify/presentation/onboarding/pages/login_page.dart';
import 'package:formify/presentation/onboarding/pages/onboarding_page.dart';
import 'package:formify/presentation/question/page/multi_answer.dart';
import 'package:formify/presentation/question/page/text.dart';
import 'package:formify/presentation/resources/strings_manager.dart';
import 'package:formify/presentation/survey/pages/create_ques_survey_page.dart';
import 'package:formify/presentation/survey/pages/create_survey_page.dart';
import 'package:formify/presentation/survey/pages/update_survey_page.dart';
import 'package:formify/presentation/survey/pages/view_all_survey_page.dart';
import 'package:formify/presentation/survey/pages/view_survey.dart';
import 'package:formify/presentation/sync/page/finished_input_surveys.dart';
import 'package:formify/presentation/sync/page/game_input_page.dart';
import 'package:formify/presentation/sync/page/insert_user_page.dart';
import 'package:formify/presentation/sync/page/list_of_surveys_page.dart';
import 'package:formify/presentation/sync/page/setting_page.dart';
import 'package:formify/presentation/sync/page/show_conference_page.dart';
import 'package:formify/presentation/sync/page/survey_input_page.dart';

class Routes {
  static const String onboarding = "/onboarding";
  static const String home = "/home";
  static const String createConference = "/createConference";
  static const String createSurvey = "/createSurvey";
  static const String createQuesSurvey = "/createQuesSurvey";
  static const String textQuestion = "/textQuestion";
  static const String conferenceSurveyById = "/conferenceSurveyById";
  //static const String getAllConference = "/getAllConference";
  static const String getAllActiveConference = "/getAllActiveConference";
  static const String viewConference = "/viewConference";
  static const String viewSurvey = "/viewSurvey";
  static const String getAllSurvey = "/getAllSurvey";
  static const String multiAnswer = "/multiAnswer";
  static const String showConference = "/ShowConference";
  static const String listOfSurveys = "/listOfSurveys";
  static const String insertUser = "/insertUser";
  static const String viewActiveConference = "/viewActiveConference";
  static const String settingPage = "/settingPage";

  static const String viewUserSurvey = "/viewUserSurvey";
  static const String viewCompletedSurvey = "/viewCompletedSurvey";
  static const String finishedSurvey = "/finishedSurvey";

  static const String gameInput = "/gameInput";
  static const String surveyInput = "/surveyInput";
  static const String loginPage = "/LoginPage";
  static const String updateSurvey = "/updateSurvey";
  static const String updateConference = "/updateConference";
  static const String exelConference = "/exelConference";
  static const String dashboardSurvey = "/dashboardSurvey";

}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onboarding:
        initOnBoardingModule();
        return _animatedRoute(OnBoardingPage());
      case Routes.loginPage:
        return _animatedRoute(LoginPage());
      case Routes.home:
       initConferenceModule();
        initSyncModule();
        return _animatedRoute(HomePage());
      case Routes.createConference:
        return _animatedRoute(CreateConferencePage());

      case Routes.createSurvey:
        initSurveyModule();
        return _animatedRoute(CreateSurveyPage());

      case Routes.createQuesSurvey:
        return _animatedRoute(CreateQuesSurveyPage());

      case Routes.viewSurvey:
        initSurveyModule();
        return _animatedRoute(ViewSurvey());

      case Routes.viewConference:
        final conferenceId = settings.arguments as int;
        return _animatedRoute(ViewConferencePage(conferenceId: conferenceId));
      case Routes.viewActiveConference:
        initExcelModule();
        final conferenceId = settings.arguments as int;
        return _animatedRoute(
          ViewActiveConferencePage(conferenceId: conferenceId),
        );
      case Routes.settingPage:
        final conferenceId = settings.arguments as int;
        return _animatedRoute(SettingPage(id: conferenceId));
      case Routes.textQuestion:
        return _animatedRoute(TextQuestionPage());
      case Routes.conferenceSurveyById:
        final args = settings.arguments as Map<String, dynamic>;
        final conferenceId = args["conferenceId"] as int;
        return _animatedRoute(ConferenceSurveyById(conferenceId: conferenceId));

      case Routes.multiAnswer:
        return _animatedRoute(MultiAnswerPage());
      case Routes.showConference:
        initSyncModule();
        return _animatedRoute(ShowConferencePage());
      case Routes.listOfSurveys:
        return _animatedRoute(ListOfSurveysPage());
      case Routes.gameInput:
        return _animatedRoute(GameInputPage());
      case Routes.surveyInput:
        return _animatedRoute(SurveyInputPage());
      case Routes.insertUser:
        return _animatedRoute(InsertUserPage());
      case Routes.viewUserSurvey:
        return _animatedRoute(ViewUserSurveyPage());
      case Routes.exelConference:
        final filename = settings.arguments as String;
        return _animatedRoute(ExelConferencePage(
          filename: filename,
        ));
      case Routes.finishedSurvey:
        return _animatedRoute(FinishedInputSurveysPage());
      case Routes.updateSurvey:
        final id = settings.arguments as int;
        return _animatedRoute(UpdateSurveyPage(id: id));
      case Routes.updateConference:
        final conference = settings.arguments as GetAllConferenceByIdModel;
        return _animatedRoute(UpdateConferencePage( conferenceModel: conference,));
      // case Routes.getAllConference:
      //   initConferenceModule();
      //   return _animatedRoute(AllConferencePage());

      case Routes.getAllActiveConference:
        return _animatedRoute(AllActiveConferencePage());
      case Routes.viewCompletedSurvey:
        return _animatedRoute(ViewCompletedSurvey());
      case Routes.getAllSurvey:
        initSurveyModule();
        return _animatedRoute(ViewAllSurveyPage());
      case Routes.dashboardSurvey:
        return _animatedRoute(SurveyDashboardPage());

      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return _animatedRoute(
      Scaffold(
        appBar: AppBar(title: const Text(StringsManager.noRouteFound)),
        body: const Center(child: Text(StringsManager.noRouteFound)),
      ),
    );
  }

  static Route<dynamic> _animatedRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 600),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final begin = const Offset(1.0, 0.0); // تغيير الاتجاه إلى اليمين لليسار
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

  // ignore: unused_element
  static Route<dynamic> _Route(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
    );
  }
}
