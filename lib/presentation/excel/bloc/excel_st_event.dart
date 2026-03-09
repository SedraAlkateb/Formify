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
  final MainSurveyModel survey;
  final int conferenceId;

  SurveyStatisticsEvent(this.survey,this.conferenceId);

  @override
  List<Object?> get props => [survey,conferenceId];
}
