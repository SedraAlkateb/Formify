import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/model_q.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/request.dart';
import 'package:formify/domain/usecase/create_survey_question_usecase.dart';
import 'package:formify/domain/usecase/create_survey_usecase.dart';
import 'package:formify/domain/usecase/get_all_survey_usecase.dart';
import 'package:meta/meta.dart';

part 'survey_event.dart';
part 'survey_state.dart';

class SurveyBloc extends Bloc<SurveyEvent, SurveyState> {
  CreateSurveyUsecase createSurveyUsecase;
  CreateSurveyQuestionUsecase createSurveyQuestionUsecase;
  GetAllSurveyUsecase getAllSurveyUsecase;
  int id = 0;
  SurveyModel surveyModel = SurveyModel.create();
  SurveyBloc(this.createSurveyUsecase, this.createSurveyQuestionUsecase,this.getAllSurveyUsecase)
    : super(SurveyInitial()) {
    on<SurveyEvent>((event, emit) async {
      if (event is CreateSurveyEvent) {
        surveyModel.description = event.description;
        surveyModel.title = event.title;
        surveyModel.color = event.color;
        emit(CreateSurveyLoadingState());
        (await createSurveyUsecase.execute(
          SurveyRequest(event.title, event.description, event.color),
        )).fold(
          (failure) {
            emit(CreateSurveyErrorState(failure: failure));
          },
          (data) async {
            id = data.id;
            emit(CreateSurveyState());
          },
        );
      } else if (event is CreateQuesSurveyEvent) {
        event.questionModel.order = surveyModel.questions.length + 2;
        surveyModel.questions.add(event.questionModel);
        emit(ViewSurveyState(surveyModel));
      } else if (event is CreateQuesNameSurveyEvent) {
        surveyModel.questions.last.title = event.questionName;
        emit(ViewSurveyState(surveyModel));
      } else if (event is CreateQuesIsRequiredSurveyEvent) {
        surveyModel.questions.last.isRequired = event.isRequired;
        emit(ViewSurveyState(surveyModel));
      } else if (event is CreateEmptyAnswerSurveyEvent) {
        surveyModel.questions.last.answers.add("");
        emit(ViewSurveyState(surveyModel));
      } else if (event is CreateBoolAnswerSurveyEvent) {
        surveyModel.questions.last.answers.add("0");
        emit(ViewSurveyState(surveyModel));
      } else if (event is CreateEmptyQuesNameSurveyEvent) {
        surveyModel.questions.add(
          QuestionModel(
            title: "",
            order: surveyModel.questions.length + 2,
            isRequired: true,
            answers: [],
            type: event.type,
          ),
        );
        emit(ViewSurveyState(surveyModel));
      } else if (event is RemoveLastAnswerEvent) {
        surveyModel.questions.last.answers.clear();
        emit(ViewSurveyState(surveyModel));
      } else if (event is RemoveAnswerAtEvent) {
        surveyModel.questions.last.answers.removeAt(event.index);
        emit(ViewSurveyState(surveyModel));
      } else if (event is CreateAnswerSurveyEvent) {
        surveyModel.questions.last.answers[event.index] = event.value;
        emit(ViewSurveyState(surveyModel));
      } else if (event is CreateSurveyWithQuestionEvent) {
        emit(CreateSurveyWithQuestionLoadingState());

        (await createSurveyQuestionUsecase.execute(
          SurveyQuestionAndAnswersModel(id, surveyModel.questions),
        )).fold(
          (failure) {
            emit(CreateSurveyWithQuestionErrorState(failure: failure));
          },
          (data) async {
            //updateRecipes(data);
            emit(CreateSurveyWithQuestionState());
          },
        );
      }
    });
  }
}
