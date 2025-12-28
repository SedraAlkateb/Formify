part of 'survey_bloc.dart';

@immutable
sealed class SurveyState extends Equatable{}

final class SurveyInitial extends SurveyState {
  @override
  List<Object?> get props => [];
}

/// عند تغيير اللون
class ViewSurveyState extends SurveyState {
  final SurveyModel surveyModel;
   ViewSurveyState(this.surveyModel) ;

  @override
  List<Object?> get props => [surveyModel];
}
final class CreateSurveyState extends SurveyState {
  CreateSurveyState();
  List<Object?> get props => [];
}
final class CreateSurveyErrorState extends SurveyState {
  final Failure failure;
  CreateSurveyErrorState({required this.failure});
  @override
  List<Object?> get props =>[failure];
}
final class CreateSurveyLoadingState extends SurveyState {
  @override
  List<Object?> get props => [];
}


final class CreateSurveyWithQuestionState extends SurveyState {
  CreateSurveyWithQuestionState();
  List<Object?> get props => [];
}
final class CreateSurveyWithQuestionErrorState extends SurveyState {
  final Failure failure;
  CreateSurveyWithQuestionErrorState({required this.failure});
  @override
  List<Object?> get props =>[failure];
}
final class CreateSurveyWithQuestionLoadingState extends SurveyState {
  @override
  List<Object?> get props => [];
}

