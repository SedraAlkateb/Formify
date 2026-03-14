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
        final Map<String, String> searchFields = {
          'all': 'كل الحقول',
          'user': 'اسم المستخدم',
          'address': 'العنوان',
          ...{
            for (final entry in questionsMap.entries) entry.value: entry.value,
          },
        };

        emit(ExelSuccess(userAnswersList,questionsMap,searchFields));
      },
    );
  }
  Future<void> _surveyStatistics(
      SurveyStatisticsEvent event,
      Emitter<ExcelStState> emit,
      ) async {
    emit(SurveyStatisticsLoading());
    final result = await statisticsSurveyUsecase.execute(
      event.survey.id,
      event.conferenceId
    );
    result.fold(
          (failure) {
        emit(SurveyStatisticsError(failure: failure));
      },
          (data) {
        emit(SurveyStatisticsSuccess(data,event.survey));
      },
    );
  }
  void createExcel(ExelModel excel) {
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
