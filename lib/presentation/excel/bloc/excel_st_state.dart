part of 'excel_st_bloc.dart';

@immutable
sealed class ExcelStState {}

final class ExcelStInitial extends ExcelStState {}
final class ExelLoading extends ExcelStState {}

final class ExelSuccess extends ExcelStState {
 final  List<Map<String, String>> exelModel;
 final Map<int, String>  rowExcel;
 final Map<String, String> searchFields ;

 ExelSuccess(this.exelModel,this.rowExcel,this.searchFields);
}

final class ExelError extends ExcelStState {
final Failure failure;
  ExelError({required this.failure});
}

final class SurveyStatisticsLoading extends ExcelStState {}

final class SurveyStatisticsSuccess extends ExcelStState {
  final  List<QuestionsStatisticsModel> surveyStatistics;
  final  List<CountModel> count;

  final  MainSurveyModel surveyModel;
  SurveyStatisticsSuccess(this.surveyStatistics,this.count,this.surveyModel);
}

final class SurveyStatisticsError extends ExcelStState {
  final Failure failure;
  SurveyStatisticsError({required this.failure});
}