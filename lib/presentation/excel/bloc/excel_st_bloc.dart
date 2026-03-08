import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/usecase/statistics_for_users_answers_usecase.dart';
import 'package:formify/domain/usecase/statistics_survey_usecase.dart';
import 'package:meta/meta.dart';

part 'excel_st_event.dart';
part 'excel_st_state.dart';

class ExcelStBloc extends Bloc<ExcelStEvent, ExcelStState> {
  final StatisticsForUsersAnswersUsecase statisticsForUsersAnswersUsecase;
  StatisticsSurveyUsecase statisticsSurveyUsecase;
   Map<int, String> questionsMap={};
  List<Map<String, String>> userAnswersList=[];
  ExcelStBloc(this.statisticsForUsersAnswersUsecase,this.statisticsSurveyUsecase) : super(ExcelStInitial()) {
    on<UsersAnswersStatisticsEvent>(_onFetch);
    on<SurveyStatisticsEvent>(_surveyStatistics);
  }
  Future<void> _onFetch(
    UsersAnswersStatisticsEvent event,
    Emitter<ExcelStState> emit,
  ) async {
    emit(ExelLoading());
    final result = await statisticsForUsersAnswersUsecase.execute(
      event.surveyId,
    );
    result.fold(
      (failure) {
        emit(ExelError(failure: failure));
      },
      (data) {
        createExcel(data);
        emit(ExelSuccess(userAnswersList,questionsMap));
      },
    );
  }
  Future<void> _surveyStatistics(
      SurveyStatisticsEvent event,
      Emitter<ExcelStState> emit,
      ) async {
    emit(SurveyStatisticsLoading());
    final result = await statisticsSurveyUsecase.execute(
      event.surveyId,
      event.conferenceId
    );
    result.fold(
          (failure) {
        emit(SurveyStatisticsError(failure: failure));
      },
          (data) {
        emit(SurveyStatisticsSuccess(data));
      },
    );
  }
  void createExcel(ExelModel excel) {
    // بيانات الأسئلة
    // List<Map<String, dynamic>> surveyQuestions = [
    //   {"id": 24, "question": "ناتل ااخنا نانا ؟", "type": "text"},
    //   {"id": 25, "question": "غلاع", "type": "email"},
    //   {"id": 26, "question": " ةعغةفىىغهىفىهف ؟", "type": "dropdown"},
    //   // يمكن إضافة المزيد من الأسئلة هنا
    // ];
    //
    // // بيانات الإجابات (من أكثر من مستخدم)
    // List<Map<String, dynamic>> userAnswers = [
    //   {
    //     "user-Information": {
    //       "id": 7,
    //       "fullname": "sedra",
    //       "email": "sedraalkateb3@gmail.com",
    //       "phone": "0965469235",
    //       "address": "Damascus"
    //     },
    //     "user-answers": [
    //       {"question-id": 24, "question": "ناتل ااخنا نانا ؟", "content": "ycycycy"},
    //       {"question-id": 25, "question": "غلاع", "content": "sedraalkateb3@gmail.com"},
    //       {"question-id": 26, "question": " ةعغةفىىغهىفىهف ؟", "content": "بغفب"},
    //       // يمكن إضافة المزيد من الإجابات هنا
    //     ]
    //   },
    //   {
    //     "user-Information": {
    //       "id": 8,
    //       "fullname": "sedra",
    //       "email": "g@gmail.com",
    //       "phone": "096547552",
    //       "address": "fffgyu"
    //     },
    //     "user-answers": [
    //       {"question-id": 24, "question": "ناتل ااخنا نانا ؟", "content": "uftdt"},
    //       {"question-id": 25, "question": "غلاع", "content": "gh@gmail.com"},
    //       {"question-id": 26, "question": " ةعغةفىىغهىفىهف ؟", "content": "لعغل"},
    //       // يمكن إضافة المزيد من الإجابات هنا
    //     ]
    //   },
    //   // المزيد من المستخدمين يمكن إضافتهم هنا
    // ];

    // تحويل الأسئلة إلى Map لتسهيل الوصول إليها عبر الـ id
    questionsMap = {
      for (var question in excel.surveyQuestionModel) question.id: question.question
    };
    userAnswersList = [];

    for (var user in excel.userAndAnswersModel) {
      Map<String, String> userAnswerMap = {};
      userAnswerMap["user"]=user.userModel.fullName;
      userAnswerMap["address"]=user.userModel.address;
      for (var answer in user.userAnswerForStatModel) {
        String question = questionsMap[answer.questionId] ?? "سؤال غير موجود";
        userAnswerMap[question] = answer.content ?? "لا توجد إجابة";
      }
      userAnswersList.add(userAnswerMap);
    }

    for (var userAnswer in userAnswersList) {
      print("إجابات المستخدم:");
      userAnswer.forEach((question, answer) {
        print("$question: $answer");
      });
      print("\n");
    }

  }

}
