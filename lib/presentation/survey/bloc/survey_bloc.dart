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
import 'package:formify/domain/usecase/get_survey_question_id_usecase.dart';
import 'package:meta/meta.dart';

part 'survey_event.dart';
part 'survey_state.dart';

class SurveyBloc extends Bloc<SurveyEvent, SurveyState> {
  CreateSurveyUsecase createSurveyUsecase;
  GetSurveyQuestionIdUsecase getSurveyQuestionIdUsecase;
  CreateSurveyQuestionUsecase createSurveyQuestionUsecase;
  GetAllSurveyUsecase getAllSurveyUsecase;
  int id = 0;
  QuestionModel question=QuestionModel.create();
  List<QuestionModel> questions=[];
  SurveyModel surveyModel = SurveyModel.create();
  SurveyBloc(
    this.createSurveyUsecase,
    this.createSurveyQuestionUsecase,
    this.getAllSurveyUsecase,
    this.getSurveyQuestionIdUsecase,
  ) : super(SurveyInitial()) {
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
      }
      else if (event is GetAllSurveyEvent) {
        emit(GetAllSurveyLoadingState());
        (await getAllSurveyUsecase.execute()).fold(
          (failure) {
            emit(GetAllSurveyErrorState(failure: failure));
          },
          (data) async {
            emit(GetAllSurveyState(data));
          },
        );
      }
      // else if (event is CreateQuesSurveyEvent) {
      //   question=QuestionModel.create();
      //   event.questionModel.order = surveyModel.questions.length + 2;
      //   question=event.questionModel;
      //  // surveyModel.questions.add(event.questionModel);
      //   emit(ViewSurveyState(surveyModel));
      // }
      //
      else if (event is CreateQuesNameSurveyEvent) {
        question.title = event.questionName;
        emit(ViewQuestionState(question));
      } else if (event is CreateQuesIsRequiredSurveyEvent) {
        question.isRequired = event.isRequired;
        emit(ViewQuestionState(question));
      } else if (event is CreateEmptyAnswerSurveyEvent) {
        question.answers.add(AnswerModel(0, ""));
        emit(ViewQuestionState(question));
      } else if (event is CreateBoolAnswerSurveyEvent) {
        question.answers.add(AnswerModel(0, ""));
        emit(ViewQuestionState(question));
      } else if (event is CreateEmptyQuesNameSurveyEvent) {
        question=  QuestionModel(
          title: "",
          order: surveyModel.questions.length + 2,
          isRequired: true,
          answers: [],
          type: event.type,
        );

        emit(ViewQuestionState(question));
      } else if (event is RemoveLastAnswerEvent) {
        question.answers.clear();
        emit(ViewQuestionState(question));
      } else if (event is RemoveAnswerAtEvent) {
        question.answers.removeAt(event.index);
        emit(ViewQuestionState(question));
      } else if (event is CreateAnswerSurveyEvent) {
        question.answers[event.index] = AnswerModel(
          0,
          event.value,
        );
        emit(ViewQuestionState(question));
      } else if (event is CreateSurveyWithQuestionEvent) {
        emit(CreateSurveyWithQuestionLoadingState());
        (await createSurveyQuestionUsecase.execute(
          SurveyQuestionAndAnswersModel(id, questions),
        )).fold(
          (failure) {
            emit(CreateSurveyWithQuestionErrorState(failure: failure));
          },
          (data) async {
            //updateRecipes(data);
            emit(CreateSurveyWithQuestionState());
          },
        );
      } else if (event is ViewSurveyByIdEvent) {
        emit(ViewSurveyLoadingState());

        (await getSurveyQuestionIdUsecase.execute(event.id)).fold(
          (failure) {
            emit(ViewSurveyErrorState(failure: failure));
          },
          (data) async {
            surveyModel = data;
            id = data.id ?? 0;
            questions=[];
            emit(ViewSurveyState(data));
          },
        );
      }
      if(event is AddQuestionEvent){
        if(question.title!=""||question.title.isNotEmpty){
          questions.add(question);
          surveyModel.questions.add(question);
        emit(ViewSurveyState(surveyModel));
      }}
    });
  }
}
