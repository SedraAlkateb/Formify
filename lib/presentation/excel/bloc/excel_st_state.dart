part of 'excel_st_bloc.dart';

@immutable
sealed class ExcelStState extends Equatable{}

final class ExcelStInitial extends ExcelStState {
  @override

  List<Object?> get props =>[];
}
final class ExelLoading extends ExcelStState {
  @override

  List<Object?> get props => [];
}

final class ExelSuccess extends ExcelStState {
 final  List<Map<String, String>> exelModel;
 final Map<int, String>  rowExcel;
 final Map<String, String> searchFields ;

 ExelSuccess(this.exelModel,this.rowExcel,this.searchFields);
 @override
  List<Object?> get props =>[exelModel,rowExcel,searchFields];
}

final class ExelError extends ExcelStState {
final Failure failure;
  ExelError({required this.failure});
@override
  List<Object?> get props =>[failure];
}

final class SurveyStatisticsLoading extends ExcelStState {
  @override
  List<Object?> get props =>[];
}

final class SurveyStatisticsSuccess extends ExcelStState {
  final  List<QuestionsStatisticsModel> surveyStatistics;
  final  List<CountModel> count;

  final  MainSurveyModel surveyModel;
  SurveyStatisticsSuccess(this.surveyStatistics,this.count,this.surveyModel);

  @override
  List<Object?> get props =>[surveyStatistics,count,surveyModel];

}

final class SurveyStatisticsError extends ExcelStState {
  final Failure failure;
  SurveyStatisticsError({required this.failure});

  @override
  List<Object?> get props =>[failure];
}

