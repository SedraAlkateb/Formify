part of 'excel_st_bloc.dart';

@immutable
sealed class ExcelStEvent extends Equatable {}

class UsersAnswersStatisticsEvent extends ExcelStEvent {
  final int surveyId;

  UsersAnswersStatisticsEvent(this.surveyId);

  @override
  List<Object?> get props => [surveyId];
}
