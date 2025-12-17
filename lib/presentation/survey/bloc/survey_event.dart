part of 'survey_bloc.dart';

@immutable
sealed class SurveyEvent extends Equatable {}

/// تغيير اللون الأساسي للتطبيق
class CreateSurveyEvent extends SurveyEvent {
  final String color;
  final String title;
  final String description;

  CreateSurveyEvent(this.color, this.title, this.description);

  @override
  List<Object?> get props => [color,title,description];
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
final String type;
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
  CreateAnswerSurveyEvent(this.index,this.value);

  @override
  List<Object?> get props => [index,value];
}
