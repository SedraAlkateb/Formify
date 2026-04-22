import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formify/app/app_preferences.dart';
import 'package:formify/app/di.dart';
import 'package:formify/data/mapper/mapper.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/usecase/add_async_data_sql_usecase.dart';
import 'package:formify/domain/usecase/check_password_usecase.dart';
import 'package:formify/domain/usecase/delete_data_sql_usecase.dart';
import 'package:formify/domain/usecase/delete_user_sql_usecase.dart';
import 'package:formify/domain/usecase/get_all_async_info_usecase.dart';
import 'package:formify/domain/usecase/get_conference_info_sql_usecase.dart';
import 'package:formify/domain/usecase/get_conference_sql_usecase.dart';
import 'package:formify/domain/usecase/get_doctors_sql_usecase.dart';
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
  final DeleteUserSqlUsecase deleteUserSqlUsecase;
  final SynchronizeUsersAnswersUsecase synchronizeUsersAnswersUsecase;
  final GetDoctorsSqlUsecase getDoctorsSqlUsecase;

  final GetConferenceSqlUsecase getConferenceSqlUsecase;
  final GetSurveysSqlUsecase getSurveysSqlUsecase;
  final GetQuestionAnswersUsecase getQuestionAnswersUsecase;
  final InsertUserAndAnswerUsecase insertUserAndAnswerUsecase;
  final GetConferenceInfoSqlUsecase getConferenceInfoSqlUsecase;
  final CheckPasswordUsecase checkPasswordUsecase;

  // القوائم المخزنة في الذاكرة
  List<IsActiveMainSurveyModel> surveys = [];
  List<DoctorsModel> doctor = [];

  // الطبيب المختار حالياً (المصدر الوحيد للحقيقة لـ doctorId)
  DoctorsModel? selectedDoctor;

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
    this.checkPasswordUsecase,
    this.deleteUserSqlUsecase,
    this.getDoctorsSqlUsecase,
  ) : super(const SyncInitial()) {
    // الأحداث الأساسية
    on<AsyncDataEvent>(_onAsyncData);
    on<InsertDataSqlEvent>(_onInsertSql);
    on<DeleteDataEvent>(_onDeleteData);
    on<DeleteUserEvent>(_onDeleteUser);
    on<GetDataEvent>(_onGetData);
    on<GetInfoConferenceEvent>(_infoConference);
    on<UploadDataEvent>(_onUpload);
    on<GetConferenceAsyncEvent>(_onGetConference);
    on<GetSurveyAsyncEvent>(_onGetSurveys);
    on<CheckEvent>(_onCheck);

    // أحداث إدخال المستخدم
    on<InputUserSqlEvent>((e, emit) async {
      userSqlModel = e.userSqlModel;
      if (selectedDoctor != null) {
        userSqlModel?.doctorId = selectedDoctor?.id;
        userSqlModel?.address = selectedDoctor?.region;
      }

      finished = 0;
    });

    // أحداث الأطباء والبحث (المعدلة)
    on<DoctorEvent>(_onGetDoctors);
    on<SearchDoctorEvent>(_onSearchDoctor);
    on<SelectDoctorEvent>(_onSelectDoctor);
    on<ClearDoctorSelectionEvent>(_onClearDoctorSelection);

    // أحداث الاستبيان
    on<GetQuestionAnswersEvent>(_onGetQuestionAnswers);
    on<SurveyPageChangedEvent>(_onSurveyPageChanged);
    on<SurveySaveAnswerEvent>(_onSurveySaveAnswer);
    on<SurveySubmitEvent>(_onSurveySubmit);
  }

  // --- Doctor Handlers ---

  Future<void> _onGetDoctors(DoctorEvent event, Emitter<SyncState> emit) async {
    (await getDoctorsSqlUsecase.execute()).fold(
      (failure) => emit(DataErrorState(failure: failure)),
      (data) {
        doctor = data;
        emit(DoctorsState(data, selectedDoctor: selectedDoctor));
      },
    );
  }

  Future<void> _onSearchDoctor(
    SearchDoctorEvent event,
    Emitter<SyncState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(DoctorsState(doctor, selectedDoctor: selectedDoctor));
      return;
    }

    final filteredList = doctor.where((doc) {
      return doc.name.toLowerCase().contains(event.query.toLowerCase());
    }).toList();

    emit(DoctorsState(filteredList, selectedDoctor: selectedDoctor));
  }

  void _onSelectDoctor(SelectDoctorEvent event, Emitter<SyncState> emit) {
    selectedDoctor = event.doctor;
    emit(DoctorsState(doctor, selectedDoctor: selectedDoctor));
  }

  void _onClearDoctorSelection(
    ClearDoctorSelectionEvent event,
    Emitter<SyncState> emit,
  ) {
    selectedDoctor = null;
    if (state is DoctorsState) {
      emit(DoctorsState(doctor, selectedDoctor: null));
    }
  }

  // --- Async & Cloud Handlers ---

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
      (_) => emit(InsertSucState(event.asyncModel.conferenceModel.id)),
    );
  }

  Future<void> _onDeleteData(
    DeleteDataEvent event,
    Emitter<SyncState> emit,
  ) async {
    (await deleteDataSqlUsecase.execute()).fold(
      (failure) => emit(DataErrorState(failure: failure)),
      (_) => emit(const DeleteDataState(0)),
    );
  }

  Future<void> _onDeleteUser(
    DeleteUserEvent event,
    Emitter<SyncState> emit,
  ) async {
    (await deleteUserSqlUsecase.execute()).fold(
      (failure) => emit(DataErrorState(failure: failure)),
      (_) => emit(const DeleteDataState(1)),
    );
  }

  Future<void> _onGetData(GetDataEvent event, Emitter<SyncState> emit) async {
    emit(const DataLoadingState());
    (await getUserAnswerSqlUsecase.execute()).fold(
      (failure) => emit(DataErrorState(failure: failure)),
      (data) {
        conferenceId = event.conferenceId;
        emit(GetDataState(data, event.conferenceId, event.isActive));
      },
    );
  }

  Future<void> _onUpload(UploadDataEvent event, Emitter<SyncState> emit) async {
    if (event.userRequest.isNotEmpty) {
      (await synchronizeUsersAnswersUsecase.execute(
        AllUserModel(event.userRequest, event.conference_id, event.isActive),
      )).fold(
        (failure) => emit(DataErrorState(failure: failure)),
        (_) => emit(UploadDataState(event.isActive)),
      );
    } else {
      emit(UploadDataState(event.isActive));
    }
  }

  Future<void> _infoConference(
    GetInfoConferenceEvent event,
    Emitter<SyncState> emit,
  ) async {
    (await getConferenceInfoSqlUsecase.execute()).fold(
      (failure) => emit(GetInfoConferenceErrorState(failure: failure)),
      (data) => emit(GetInfoConferenceSuccessState(data)),
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

    final result = await getSurveysSqlUsecase.execute();

    await result.fold(
      (failure) async => emit(GetSurveyAsyncErrorState(failure: failure)),
      (data) async {
        surveys = data.toDomain();
        if (surveys.isEmpty) {
          emit(const InsertUserLoadingState());

          final insertResult = await insertUserAndAnswerUsecase.execute(
            userSqlModel!,
          );

          insertResult.fold(
            (failure) => emit(InsertUserErrorState(failure: failure)),
            (_) => emit(FinishedSurveyState()),
          );
        } else {
          emit(GetSurveyAsyncState(surveys));
        }
      },
    );
  }
  // --- Survey Logic Handlers ---

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
            time: event.time,
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
    final mapped = _mapToAnswers(event.question, event.rawValue);
    final newAnswers = Map<int, List<AnswerUserModel>>.from(s.answers);
    newAnswers[event.index] = mapped;
    emit(s.copyWith(answers: newAnswers));
  }

  List<AnswerUserModel> _mapToAnswers(QuestionModel q, dynamic rawValue) {
    if (rawValue == null) return [];
    if (rawValue is String || rawValue is num) {
      final answerId = q.answers.isNotEmpty ? q.answers[0].id : null;
      return [
        AnswerUserModel(answerId, rawValue.toString(), q.answers[0].isCorrect),
      ];
    }
    if (rawValue is AnswerModel) {
      return [AnswerUserModel(rawValue.id, rawValue.title, rawValue.isCorrect)];
    }
    if (rawValue is List<AnswerModel>) {
      return rawValue
          .map((a) => AnswerUserModel(a.id, a.title, a.isCorrect))
          .toList();
    }
    return [];
  }

  Future<void> _onCheck(CheckEvent event, Emitter<SyncState> emit) async {
    final checkResult = await checkPasswordUsecase.execute(event.password);
    checkResult.fold((failure) => null, (isValid) async {
      if (!isValid) {
        await deleteDataSqlUsecase.execute();
        await instance<AppPreferences>().signOut();
        if (!emit.isDone) emit(CheckoutState());
      }
    });
  }

  Future<void> _onSurveySubmit(
    SurveySubmitEvent event,
    Emitter<SyncState> emit,
  ) async {
    final s = state;
    if (s is! SurveyReadyState) return;
    emit(SurveySubmittingState(s));

    try {
      s.answers.forEach((index, list) {
        for (final a in list) {
          userSqlModel?.answerModel.add(a);
        }
      });

      surveys[s.index].isActive = true;
      finished++;

      if (finished == surveys.length) {
        emit(const InsertUserLoadingState());
        (await insertUserAndAnswerUsecase.execute(userSqlModel!)).fold(
          (failure) => emit(InsertUserErrorState(failure: failure)),
          (_) {
            //   emit(InsertUserSuccessState());
            emit(FinishedSurveyState());
          },
        );
      } else {
        emit(SurveySubmitSuccessState(surveys));
      }
    } catch (e) {
      emit(SurveySubmitErrorState(failure: Failure(0, e.toString())));
    }
  }
}
