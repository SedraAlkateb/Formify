part of 'survey_bloc.dart';

@immutable
sealed class SurveyState {}

final class SurveyInitial extends SurveyState {}

/// عند تغيير اللون
class ViewSurveyState extends SurveyState {
  final SurveyModel surveyModel;
   ViewSurveyState(this.surveyModel) ;

  @override
  List<Object?> get props => [surveyModel];
}