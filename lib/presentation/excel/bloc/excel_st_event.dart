// excel_st_event.dart
part of 'excel_st_bloc.dart';

@immutable
sealed class ExcelStEvent extends Equatable {}

class UsersAnswersStatisticsEvent extends ExcelStEvent {
  final int surveyId;
 final int conference_id;
  UsersAnswersStatisticsEvent(this.surveyId,this.conference_id);

  @override
  List<Object?> get props => [surveyId,conference_id];
}

class SurveyStatisticsEvent extends ExcelStEvent {
  final MainSurveyModel survey;
  final int conferenceId;
  SurveyStatisticsEvent(this.survey, this.conferenceId);

  @override
  List<Object?> get props => [survey, conferenceId];
}

