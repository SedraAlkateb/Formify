import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formify/data/mapper/mapper.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/usecase/add_async_data_sql_usecase.dart';
import 'package:formify/domain/usecase/delete_data_sql_usecase.dart';
import 'package:formify/domain/usecase/get_all_async_info_usecase.dart';
import 'package:formify/domain/usecase/get_conference_info_sql_usecase.dart';
import 'package:formify/domain/usecase/get_conference_sql_usecase.dart';
import 'package:formify/domain/usecase/get_question_answers_usecase.dart';
import 'package:formify/domain/usecase/get_surveys_sql_usecase.dart';
import 'package:formify/domain/usecase/get_user_answer_sql_usecase.dart';
import 'package:formify/domain/usecase/insert_user_and_answer_usecase.dart';
import 'package:formify/domain/usecase/synchronize_users_answers_usecase.dart';
import 'package:meta/meta.dart';

part 'sync_event.dart';
part 'sync_state.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final GetAllAsyncInfoUsecase getAllAsyncInfoUsecase;
  final AddAsyncDataSqlUsecase addAsyncDataSqlUsecase;
  final GetUserAnswerSqlUsecase getUserAnswerSqlUsecase;
  final DeleteDataSqlUsecase deleteDataSqlUsecase;
  final SynchronizeUsersAnswersUsecase synchronizeUsersAnswersUsecase;
  final GetConferenceSqlUsecase getConferenceSqlUsecase;
  final GetSurveysSqlUsecase getSurveysSqlUsecase;
  final GetQuestionAnswersUsecase getQuestionAnswersUsecase;
  final InsertUserAndAnswerUsecase insertUserAndAnswerUsecase;
  GetConferenceInfoSqlUsecase getConferenceInfoSqlUsecase;
  List<IsActiveMainSurveyModel> surveys = [];
  UserSqlModel? userSqlModel;
  int? conferenceId;
  int finished = 0;
  SyncBloc(
    this.getAllAsyncInfoUsecase,
    this.addAsyncDataSqlUsecase,
    this.getUserAnswerSqlUsecase,
    this.deleteDataSqlUsecase,
    this.synchronizeUsersAnswersUsecase,
    this.getConferenceSqlUsecase,
    this.getSurveysSqlUsecase,
    this.getQuestionAnswersUsecase,
    this.insertUserAndAnswerUsecase,
    this.getConferenceInfoSqlUsecase,
  ) : super(const SyncInitial()) {
    // ===== Existing =====
    on<AsyncDataEvent>(_onAsyncData);
    on<InsertDataSqlEvent>(_onInsertSql);
    on<DeleteDataEvent>(_onDeleteData);
    on<GetDataEvent>(_onGetData);
    on<GetInfoConferenceEvent>(_infoConference);

    on<UploadDataEvent>(_onUpload);
    on<GetConferenceAsyncEvent>(_onGetConference);
    on<GetSurveyAsyncEvent>(_onGetSurveys);
    on<InputUserSqlEvent>((e, emit) async {
      userSqlModel = e.userSqlModel;
      finished = 0;
    });

    // ===== Survey flow =====
    on<GetQuestionAnswersEvent>(_onGetQuestionAnswers);
    on<SurveyPageChangedEvent>(_onSurveyPageChanged);
    on<SurveySaveAnswerEvent>(_onSurveySaveAnswer);
    on<SurveySubmitEvent>(_onSurveySubmit);
  }

  Future<void> _onAsyncData(
    AsyncDataEvent event,
    Emitter<SyncState> emit,
  ) async {
    (await getAllAsyncInfoUsecase.execute(conferenceId ?? -1)).fold(
      (failure) => emit(DataErrorState(failure: failure)),
      (data) => emit(AsyncConferenceState(data)),
    );
  }

  Future<void> _onInsertSql(
    InsertDataSqlEvent event,
    Emitter<SyncState> emit,
  ) async {
    (await addAsyncDataSqlUsecase.execute(event.asyncModel)).fold(
      (failure) => emit(DataErrorState(failure: failure)),
      (_) => emit(const InsertSucState()),
    );
  }

  Future<void> _onDeleteData(
    DeleteDataEvent event,
    Emitter<SyncState> emit,
  ) async {
    (await deleteDataSqlUsecase.execute()).fold(
      (failure) => emit(DataErrorState(failure: failure)),
      (_) => emit(const DeleteDataState()),
    );
  }

  Future<void> _onGetData(GetDataEvent event, Emitter<SyncState> emit) async {
    emit(const DataLoadingState());
    (await getUserAnswerSqlUsecase.execute()).fold(
      (failure) => emit(DataErrorState(failure: failure)),
      (data) {
        conferenceId = event.conferenceId;
        emit(GetDataState(data, event.conferenceId));
      },
    );
  }

  Future<void> _onUpload(UploadDataEvent event, Emitter<SyncState> emit) async {
    if (event.userRequest.isNotEmpty) {
      (await synchronizeUsersAnswersUsecase.execute(
        AllUserModel(event.userRequest, event.conference_id),
      )).fold(
        (failure) => emit(DataErrorState(failure: failure)),
        (_) => emit(const UploadDataState()),
      );
    } else {
      emit(DeleteDataState());
    }
  }

  Future<void> _infoConference(
    GetInfoConferenceEvent event,
    Emitter<SyncState> emit,
  ) async {
    (await getConferenceInfoSqlUsecase.execute()).fold(
      (failure) => emit(GetInfoConferenceErrorState(failure: failure)),
      (data) => emit( GetInfoConferenceSuccessState(data)),
    );
  }

  Future<void> _onGetConference(
    GetConferenceAsyncEvent event,
    Emitter<SyncState> emit,
  ) async {
    emit(const GetConferenceAsyncLoadingState());
    (await getConferenceSqlUsecase.execute()).fold(
      (failure) => emit(GetConferenceAsyncErrorState(failure: failure)),
      (data) {
        if (data == null) {
          emit(GetConferenceAsyncEmptyState());
        } else {
          emit(GetConferenceAsyncState(data));
        }
      },
    );
  }

  Future<void> _onGetSurveys(
    GetSurveyAsyncEvent event,
    Emitter<SyncState> emit,
  ) async {
    emit(const GetSurveyAsyncLoadingState());
    (await getSurveysSqlUsecase.execute()).fold(
      (failure) => emit(GetSurveyAsyncErrorState(failure: failure)),
      (data) {
        surveys = data.toDomain();
        emit(GetSurveyAsyncState(surveys));
      },
    );
  }

  Future<void> _onGetQuestionAnswers(
    GetQuestionAnswersEvent event,
    Emitter<SyncState> emit,
  ) async {
    emit(const SurveyLoadingState());

    (await getQuestionAnswersUsecase.execute(event.id)).fold(
      (failure) => emit(SurveyErrorState(failure: failure)),
      (questions) {
        emit(
          SurveyReadyState(
            index: event.index,
            surveyName: event.surveyName,
            surveyDescription: event.surveyDescription,
            questions: questions,
            answers: <int, List<AnswerUserModel>>{},
            currentIndex: 0,
          ),
        );
      },
    );
  }

  Future<void> _onSurveyPageChanged(
    SurveyPageChangedEvent event,
    Emitter<SyncState> emit,
  ) async {
    final s = state;
    if (s is! SurveyReadyState) return;
    emit(s.copyWith(currentIndex: event.index));
  }

  Future<void> _onSurveySaveAnswer(
    SurveySaveAnswerEvent event,
    Emitter<SyncState> emit,
  ) async {
    final s = state;
    if (s is! SurveyReadyState) return;
    //
    final mapped = _mapToAnswers(event.question, event.rawValue);

    final newAnswers = Map<int, List<AnswerUserModel>>.from(s.answers);
    newAnswers[event.index] = mapped;

    emit(s.copyWith(answers: newAnswers));
  }

  List<AnswerUserModel> _mapToAnswers(QuestionModel q, dynamic rawValue) {
    if (rawValue == null) return [];

    // String / num -> content
    if (rawValue is String || rawValue is num) {
      final answerId = q.answers.isNotEmpty ? q.answers[0].id : null;
      return [AnswerUserModel(answerId, rawValue.toString())];
    }

    // AnswerModel (dropdown/radio)
    if (rawValue is AnswerModel) {
      return [AnswerUserModel(rawValue.id, rawValue.title)];
    }

    // List<AnswerModel> (checkbox)
    if (rawValue is List<AnswerModel>) {
      return rawValue.map((a) => AnswerUserModel(a.id, a.title)).toList();
    }

    // DateTime / bool / double (optional support)
    if (rawValue is DateTime) {
      final answerId = q.answers.isNotEmpty ? q.answers[0].id : null;
      return [AnswerUserModel(answerId, rawValue.toIso8601String())];
    }
    if (rawValue is bool) {
      final answerId = q.answers.isNotEmpty ? q.answers[0].id : null;
      return [AnswerUserModel(answerId, rawValue ? "1" : "0")];
    }

    return [];
  }

  Future<void> _onSurveySubmit(
    SurveySubmitEvent event,
    Emitter<SyncState> emit,
  ) async {
    final s = state;
    if (s is! SurveyReadyState) return;

    emit(SurveySubmittingState(s));

    try {
      // هنا استخدم s.answers للإدخال/الإرسال
      // مثال طباعة:
      s.answers.forEach((index, list) {
        for (final a in list) {
          print(a.content);
          userSqlModel?.answerModel.add(a);
        }
      });

      surveys[s.index].isActive = true;
      finished = finished + 1;
      if (finished == surveys.length) {
        emit(const InsertUserLoadingState());

        (await insertUserAndAnswerUsecase.execute(userSqlModel!)).fold(
          (failure) => emit(InsertUserErrorState(failure: failure)),
          (questions) {
            emit(InsertUserSuccessState());
          },
        );
        emit(FinishedSurveyState());
      } else {
        emit(SurveySubmitSuccessState(surveys));
      }
    } catch (e) {
      emit(SurveySubmitErrorState(failure: Failure(0, e.toString())));
    }
  }
}
