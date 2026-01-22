part of 'survey_bloc.dart';

@immutable
sealed class SurveyState extends Equatable{}

final class SurveyInitial extends SurveyState {
  @override
  List<Object?> get props => [];
}
final class ViewSurveyErrorState extends SurveyState {
  final Failure failure;
 ViewSurveyErrorState({required this.failure});
  @override
  List<Object?> get props =>[failure];
}
final class ViewSurveyLoadingState extends SurveyState {
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


class ViewQuestionState extends SurveyState {
  final QuestionModel questionModel;
  ViewQuestionState(this.questionModel) ;

  @override
  List<Object?> get props => [questionModel];
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

final class GetAllSurveyState extends SurveyState {
 final List<MainSurveyModel> surveys;
  GetAllSurveyState(this.surveys);
  List<Object?> get props => [surveys];
}
final class GetAllSurveyErrorState extends SurveyState {
  final Failure failure;
  GetAllSurveyErrorState({required this.failure});
  @override
  List<Object?> get props =>[failure];
}
final class GetAllSurveyLoadingState extends SurveyState {
  @override
  List<Object?> get props => [];
}
final class GetAllEmptySurveyState extends SurveyState {
  @override
  List<Object?> get props => [];
}
