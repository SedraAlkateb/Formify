import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/domain/models/models.dart';
import 'package:meta/meta.dart';

part 'survey_event.dart';
part 'survey_state.dart';

class SurveyBloc extends Bloc<SurveyEvent, SurveyState> {
  SurveyModel surveyModel = SurveyModel.create();
  SurveyBloc() : super(SurveyInitial()) {
    on<SurveyEvent>((event, emit) {
      if (event is CreateSurveyEvent) {
        surveyModel.description = event.description;
        surveyModel.title = event.title;
        surveyModel.color = event.color;
      } else if (event is CreateQuesSurveyEvent) {
        event.questionModel.order = surveyModel.questions.length + 2;
        surveyModel.questions.add(event.questionModel);
        emit(ViewSurveyState(surveyModel));
      } else if (event is CreateQuesNameSurveyEvent) {
        surveyModel.questions.add(
          QuestionModel(
            title: event.questionName,
            order: surveyModel.questions.length + 2,
            isRequired: true,
            answers: [],
          ),
        );
        emit(ViewSurveyState(surveyModel));
      } else if (event is CreateQuesNameSurveyEvent) {
        surveyModel.questions.last.title=event.questionName;
        emit(ViewSurveyState(surveyModel));
      } else if (event is CreateEmptyAnswerSurveyEvent) {
        surveyModel.questions.last.answers.add("");
        emit(ViewSurveyState(surveyModel));
      }else if (event is CreateEmptyQuesNameSurveyEvent) {
        surveyModel.questions.add(
          QuestionModel(
            title: "",
            order: surveyModel.questions.length + 2,
            isRequired: true,
            answers: [],
          ),
        );
        emit(ViewSurveyState(surveyModel));
      }else if (event is RemoveLastAnswerEvent) {
      surveyModel.questions.last.answers.clear();
      emit(ViewSurveyState(surveyModel));
    }else if (event is RemoveAnswerAtEvent) {
        surveyModel.questions.last.answers.removeAt(event.index);
        emit(ViewSurveyState(surveyModel));
      }else if (event is CreateAnswerSurveyEvent) {
        surveyModel.questions.last.answers[event.index]=event.value;
        emit(ViewSurveyState(surveyModel));
      }
    });
  }
}
