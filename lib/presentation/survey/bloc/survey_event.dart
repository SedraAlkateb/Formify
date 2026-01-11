part of 'survey_bloc.dart';

@immutable
sealed class SurveyEvent extends Equatable {}

class CreateSurveyEvent extends SurveyEvent {
  final String color;
  final String title;
  final String description;

  CreateSurveyEvent(this.color, this.title, this.description);

  @override
  List<Object?> get props => [color, title, description];
}
class GetAllSurveyEvent extends SurveyEvent {
  GetAllSurveyEvent();

  @override
  List<Object?> get props => [];
}

class CreateQuesSurveyEvent extends SurveyEvent {
  final QuestionModel questionModel;

  CreateQuesSurveyEvent(this.questionModel);

  @override
  List<Object?> get props => [questionModel];
}

class CreateQuesNameSurveyEvent extends SurveyEvent {
  final String questionName;

  CreateQuesNameSurveyEvent(this.questionName);

  @override
  List<Object?> get props => [questionName];
}

class CreateEmptyQuesNameSurveyEvent extends SurveyEvent {
  final QuestionType type;
  CreateEmptyQuesNameSurveyEvent(this.type);

  @override
  List<Object?> get props => [type];
}

class CreateEmptyAnswerSurveyEvent extends SurveyEvent {
  CreateEmptyAnswerSurveyEvent();

  @override
  List<Object?> get props => [];
}

class RemoveLastAnswerEvent extends SurveyEvent {
  RemoveLastAnswerEvent();

  @override
  List<Object?> get props => [];
}

class RemoveAnswerAtEvent extends SurveyEvent {
  final int index;
  RemoveAnswerAtEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class CreateAnswerSurveyEvent extends SurveyEvent {
  final int index;
  final String value;
  CreateAnswerSurveyEvent(this.index, this.value);

  @override
  List<Object?> get props => [index, value];
}

class CreateQuesIsRequiredSurveyEvent extends SurveyEvent {
  final bool isRequired;

  CreateQuesIsRequiredSurveyEvent(this.isRequired);

  @override
  List<Object?> get props => [isRequired];
}
class CreateSurveyWithQuestionEvent extends SurveyEvent {

  CreateSurveyWithQuestionEvent();

  @override
  List<Object?> get props => [];
}
class CreateBoolAnswerSurveyEvent extends SurveyEvent {

  CreateBoolAnswerSurveyEvent();

  @override
  List<Object?> get props => [];
}
