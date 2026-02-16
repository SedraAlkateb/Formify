import 'dart:io';
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
import 'package:image_picker/image_picker.dart';
import  'package:meta/meta.dart';

part 'survey_event.dart';
part 'survey_state.dart';

class SurveyBloc extends Bloc<SurveyEvent, SurveyState> {
  CreateSurveyUsecase createSurveyUsecase;
  GetSurveyQuestionIdUsecase getSurveyQuestionIdUsecase;
  CreateSurveyQuestionUsecase createSurveyQuestionUsecase;
  GetAllSurveyUsecase getAllSurveyUsecase;

  /////////////////////////////////////////////
  QuestionModel question = QuestionModel.create();
  List<QuestionModel> questions = [];

  SurveyModel surveyModel = SurveyModel.create();
  int id = 0;
  List<File> files = [];
 void initSurveyBloc(){
    questions=[];
    question=QuestionModel.create();
    surveyModel = SurveyModel.create();
    id=0;
    files=[];
  }
  SurveyBloc(
    this.createSurveyUsecase,
    this.createSurveyQuestionUsecase,
    this.getAllSurveyUsecase,
    this.getSurveyQuestionIdUsecase,
  ) : super(SurveyInitial()) {
    on<SurveyEvent>((event, emit) async {
      if (event is PickAnswerImageEvent) {
        final s = state;
        if (s is! ViewQuestionState) return;

        final picker = ImagePicker();
        final XFile? file = await picker.pickImage(source: ImageSource.gallery);
        if (file == null) return;
        final newImages = Map<int, XFile>.from(s.images);
        newImages[event.index] = file;
        s.questionModel.answers[event.index].imgName = file.name;
        s.questionModel.answers[event.index].img = file;
        emit(ViewQuestionState(s.questionModel, images: newImages));
      } else if (event is CreateSurveyEvent) {
        surveyModel.description = event.description;
        surveyModel.title = event.title;
        surveyModel.color = event.color;
        emit(CreateSurveyLoadingState());
        (await createSurveyUsecase.execute(
          SurveyRequest(event.title, event.description, event.color,event.timer),
        )).fold(
          (failure) {
            emit(CreateSurveyErrorState(failure: failure));
          },
          (data) async {
            id = data.id;
            emit(CreateSurveyState());
          },
        );
      } else if (event is GetAllSurveyEvent) {
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
      else if (event is CreateQuesNameSurveyEvent) {
        question.title = event.questionName;
        QuestionModel question1 = question.instanceQuestion();
        emit(ViewQuestionState(question1));
      } else if (event is CreateQuesIsRequiredSurveyEvent) {
        question.isRequired = event.isRequired;
        QuestionModel question1 = question.instanceQuestion();
        emit(ViewQuestionState(question1));
      } else if (event is CreateEmptyAnswerSurveyEvent) {
        question.answers.add(AnswerModel(0, ""));
        QuestionModel question1 = question.instanceQuestion();
        emit(ViewQuestionState(question1));
      } else if (event is CreateBoolAnswerSurveyEvent) {
        question.answers.add(AnswerModel(0, ""));
        QuestionModel question1 = question.instanceQuestion();
        emit(ViewQuestionState(question1));
      } else if (event is CreateEmptyQuesNameSurveyEvent) {
        question = QuestionModel(
          title: "",
          order: surveyModel.questions.length + 2,
          isRequired: true,
          answers: [],
          type: event.type,
          value: 0
        );

        emit(ViewQuestionState(question));
      } else if (event is RemoveLastAnswerEvent) {
        question.answers.clear();
        QuestionModel question1 = question.instanceQuestion();
        emit(ViewQuestionState(question1));
      } else if (event is RemoveAnswerAtEvent) {
        question.answers.removeAt(event.index);
        QuestionModel question1 = question.instanceQuestion();
        emit(ViewQuestionState(question1));
      } else if (event is CreateAnswerSurveyEvent) {
        question.answers[event.index] = AnswerModel(0, event.value);
        QuestionModel question1 = question.instanceQuestion();
        emit(ViewQuestionState(question1));
      } else if (event is CreateSurveyWithQuestionEvent) {
        emit(CreateSurveyWithQuestionLoadingState());

        for (final q in questions) {
          for (final answer in q.answers) {
            if (answer.img != null) {
              answer.imgName = answer.img!.name;
              files.add(File(answer.img!.path,));
            }
          }
        }
        (await createSurveyQuestionUsecase.execute(
          SurveyQuestionAndAnswersModel(id, questions),
          files,
        )).fold(
          (failure) {
            emit(CreateSurveyWithQuestionErrorState(failure: failure));
          },
          (data) async {
            files=[];
            questions=[];
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
            questions = [];
            emit(ViewSurveyState(data));
          },
        );
      }
      if (event is AddQuestionEvent) {
        if (question.title != "" || question.title.isNotEmpty) {
          questions.add(question);
          surveyModel.questions.add(question);
          emit(ViewSurveyState(surveyModel));
        }
      }
      on<SelectValueAnswerEvent>((event, emit) {
        final q = (state as ViewQuestionState).questionModel;
        q.value = event.index;
        emit(ViewQuestionState(q));
      });
    });
  }
}
