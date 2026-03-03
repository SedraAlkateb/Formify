part of 'survey_bloc.dart';

@immutable
abstract class SurveyState extends Equatable{}

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
class ViewSurveyState extends SurveyState {
  final SurveyModel surveyModel;
   ViewSurveyState(this.surveyModel) ;

  @override
  List<Object?> get props => [surveyModel];
}


class ViewQuestionState extends SurveyState {
  final QuestionModel questionModel;
  final Map<int, XFile> images; // key = answer index
   ViewQuestionState(this.questionModel, {this.images = const {}});

  @override
  List<Object?> get props => [questionModel, images];
}

final class UpdateSurveyErrorState extends SurveyState {
  final Failure failure;
  UpdateSurveyErrorState({required this.failure});
  @override
  List<Object?> get props =>[failure];
}
final class UpdateSurveyLoadingState extends SurveyState {
  @override
  List<Object?> get props => [];
}
final class UpdateSurveyState extends SurveyState {
  @override
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

final class RepetitionSurveyErrorState extends SurveyState {
  final Failure failure;
  RepetitionSurveyErrorState({required this.failure});
  @override
  List<Object?> get props =>[failure];
}
final class RepetitionSurveyLoadingState extends SurveyState {
  @override
  List<Object?> get props => [];
}
final class RepetitionSurveyState extends SurveyState {
  @override
  List<Object?> get props => [];
}
