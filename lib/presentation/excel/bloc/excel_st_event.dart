part of 'excel_st_bloc.dart';

@immutable
sealed class ExcelStEvent extends Equatable {}

class UsersAnswersStatisticsEvent extends ExcelStEvent {
  final int surveyId;

  UsersAnswersStatisticsEvent(this.surveyId);

  @override
  List<Object?> get props => [surveyId];
}
class SurveyStatisticsEvent extends ExcelStEvent {
  final int surveyId;
  final int conferenceId;

  SurveyStatisticsEvent(this.surveyId,this.conferenceId);

  @override
  List<Object?> get props => [surveyId,conferenceId];
}
