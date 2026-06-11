
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formify/data/mapper/mapper.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/user_type.dart';
import 'package:formify/domain/usecase/all_important_doctor_not_come_sql_usecase.dart';
import 'package:formify/domain/usecase/doctors_attendance_sql_usecase.dart';
import 'package:formify/domain/usecase/get_conference_info_sql_usecase.dart';
import 'package:formify/domain/usecase/get_conference_sql_usecase.dart';
import 'package:formify/domain/usecase/get_doctors_sql_usecase.dart';
import 'package:formify/domain/usecase/get_question_answers_usecase.dart';
import 'package:formify/domain/usecase/get_spec_sql_usecase.dart';
import 'package:formify/domain/usecase/get_surveys_sql_usecase.dart';
import 'package:formify/domain/usecase/get_users_by_specId_name_sql_usecase.dart';
import 'package:formify/domain/usecase/get_users_by_specIds_sql_usecase.dart';
import 'package:formify/domain/usecase/get_users_conference_usecase.dart';
import 'package:formify/domain/usecase/insert_doctor_sql_usecase.dart';
import 'package:formify/domain/usecase/insert_imp_doctor_for_new_con_usecase.dart';
import 'package:formify/domain/usecase/insert_user_and_answer_usecase.dart';
import 'package:formify/domain/usecase/updateIs_done_usecase.dart';
import 'package:formify/domain/usecase/update_user_sql_usecase.dart';
import 'package:meta/meta.dart';
part 'sync_event.dart';
part 'sync_state.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  //  final SynchronizeUsersAnswersUsecase synchronizeUsersAnswersUsecase;
  final GetDoctorsSqlUsecase getDoctorsSqlUsecase;
  final InsertDoctorSqlUsecase insertDoctorSqlUsecase;
  final GetConferenceSqlUsecase getConferenceSqlUsecase;
  final GetSurveysSqlUsecase getSurveysSqlUsecase;
  final GetQuestionAnswersUsecase getQuestionAnswersUsecase;
  final InsertUserAndAnswerUsecase insertUserAndAnswerUsecase;
  final GetConferenceInfoSqlUsecase getConferenceInfoSqlUsecase;
  final GetUsersConferenceUsecase getUsersConferenceUsecase;
  final UpdateUserSqlUsecase updateUserSqlUsecase;
  final DoctorsAttendanceSqlUsecase doctorsAttendanceSqlUsecase;
  final UpdateDoneUsecase updateDoneUsecase;
  final GetSpecSqlUsecase getSpecSqlUsecase;
  final AllImportantDoctorNotComeSqlUsecase allImportantDoctorNotComeSqlUsecase;
  final InsertImpDoctorForNewConUsecase insertImpDoctorForNewConUsecase;
  final  GetUsersBySpecIdsSqlUsecase  getUsersBySpecIdsSqlUsecase;
  // القوائم المخزنة في الذاكرة
  GetUsersBySpecIdNameSqlUsecase getUsersBySpecIdNameSqlUsecase;
  List<IsActiveMainSurveyModel> surveys = [];
  List<IsActiveMainSurveyModel> surveysBase = [];
  List<UserModel> doctor = [];

  ///
  List<SpecModel> spec = [];

  UserModel? selectedDoctor;

  UserSqlModel? userSqlModel;
  int? conferenceId;
  int finished = 0;

  SyncBloc(
    this.getSpecSqlUsecase,
    this.getUsersBySpecIdNameSqlUsecase,
    this.getConferenceSqlUsecase,
    this.getSurveysSqlUsecase,
    this.getQuestionAnswersUsecase,
    this.insertUserAndAnswerUsecase,
    this.getConferenceInfoSqlUsecase,

    this.getDoctorsSqlUsecase,
    this.insertDoctorSqlUsecase,

    this.getUsersConferenceUsecase,
    this.updateUserSqlUsecase,
    this.doctorsAttendanceSqlUsecase,
    this.updateDoneUsecase,
    this.allImportantDoctorNotComeSqlUsecase,
      this.insertImpDoctorForNewConUsecase,
      this.getUsersBySpecIdsSqlUsecase
  ) : super(const SyncInitial()) {
    // الأحداث الأساسية

    on<GetInfoConferenceEvent>(_infoConference);
    //  on<UploadDataEvent>(_onUpload);
    on<GetConferenceAsyncEvent>(_onGetConference);
    on<GetSurveyAsyncEvent>(_onGetSurveys);
    on<EditUserEvent>(_onEditUser);
    on<UpdateDoneDoctorEvent>(_onIsDone);
    on<InputUserSqlEvent>((e, emit) async {
      userSqlModel = e.userSqlModel;
      if (selectedDoctor != null) {
        if (selectedDoctor?.server_user_id == null) {
          /// حالة وجود جديد لكن مع تعديل
          userSqlModel?.user.server_user_id = null;
          userSqlModel?.user.id = selectedDoctor?.id;
          userSqlModel?.user.is_modified = 0;
          userSqlModel?.user.is_local_new = 1;
          userSqlModel?.user.isUpload = 0;
        } else {
          /// حالة وجود قديم لكن مع تعديل
          userSqlModel?.user.server_user_id = selectedDoctor?.server_user_id;
          userSqlModel?.user.id = selectedDoctor?.id;
          userSqlModel?.user.is_modified = 1;
          userSqlModel?.user.is_local_new = 0;
          userSqlModel?.user.isUpload = 0;
        }
      } else {
        /// حالة وجود جديد
        userSqlModel?.user.is_modified = 0;
        userSqlModel?.user.is_local_new = 1;
        userSqlModel?.user.isUpload = 0;
      }

      finished = 0;
      if (surveys.isEmpty) {
        emit(NavigateToConferenceState());
      } else {
        emit(NavigateToSurveyState());
      }
    });
    on<DoctorEvent>(_onGetDoctors);
    on<SpecEvent>(_onGetSpec);
    on<FilterDoctorBySpecAndNameEvent>(_onFilterUser);
    on<InsertEvent>(_onInsertDoctors);
    on<SearchDoctorEvent>(_onSearchDoctor);
    on<SelectDoctorEvent>(_onSelectDoctor);
    on<ClearDoctorSelectionEvent>(_onClearDoctorSelection);
    on<GetQuestionAnswersEvent>(_onGetQuestionAnswers);
    on<SurveyPageChangedEvent>(_onSurveyPageChanged);
    on<SurveySaveAnswerEvent>(_onSurveySaveAnswer);
    on<SurveySubmitEvent>(_onSurveySubmit);
    on<GetAllUserEvent>(_onGetAllUserEvent);
    on<SearchInUsersEvent>(_searchInUsersEvent);
    on<InsertUserSqlEvent>(_onInsertUserSql);
    //on<DoctorsAttendanceEvent>(_onDoctorsAttendance);
    on<InsertImportantDoctors>(_onInsertImportantDoctor);
    on<GetDoctorBySpsEvent>(_onDoctorsBySps);

    on<FilterUserEvent>((event, emit) async {
      final allUsers = event.users;
      List<UserModel> filteredList = [];
      String newTitle = "المشاركون"; // لتحديث العنوان في الـ UI

      // 3. منطق الفلترة بناءً على الـ filterType
      switch (event.filterType) {
        case 0: // الكل
          filteredList = allUsers;
          newTitle = "الكل";
          break;
        case 1:
          filteredList = allUsers.where((user) {
            return user.userType == UserType.importantDoctor;
          }).toList();
          newTitle = "المهمين - حضروا";
          break;
        case 2:
          (await allImportantDoctorNotComeSqlUsecase.execute(event.users)).fold(
            (failure) {
              emit(GetUserConferenceErrorState(failure: failure));
            },
            (data) async {
              filteredList = data;
            },
          );
          newTitle = "المهمين - غائبين";
          break;
      }
      for (var user in filteredList) {
        print(
          " | اسم المستخدم: ${user.fullName} | العنوان: ${user.address}  | الرقم: ${user.phone}  | النوع: ${user.userType.name}",
        );
      }
      emit(
        GetUserConferenceState(
          allUsers,

          filteredList,
          newTitle,

          // أضف هذا الحقل للـ State لكي تستخدمه في الـ UI
        ),
      );
    });
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

  Future<void> _onGetSpec(SpecEvent event, Emitter<SyncState> emit) async {
    (await getSpecSqlUsecase.execute()).fold(
      (failure) => emit(DataErrorState(failure: failure)),
      (data) {
        spec = data;
        emit(SpecState(data));
      },
    );
  }

  Future<void> _onFilterUser(
    FilterDoctorBySpecAndNameEvent event,
    Emitter<SyncState> emit,
  ) async {
    (await getUsersBySpecIdNameSqlUsecase.execute(
      event.spId,
      event.doctorName,
    )).fold((failure) => emit(DataErrorState(failure: failure)), (data) {
      printFinalUsersOutput(data);
      emit(UserFilterState(data));
    });
  }

  Future<void> _onInsertDoctors(
    InsertEvent event,
    Emitter<SyncState> emit,
  ) async {
    // 1. إرسال حالة التحميل
    emit(InsertDoctorLoadingState());

    // 2. تنفيذ العملية
    final result = await insertDoctorSqlUsecase.execute(event.doctorsModel);

    // 3. معالجة النتيجة
    result.fold((failure) => emit(InsertDoctorErrorState(failure: failure)), (
      data,
    ) {
      doctor.add(event.doctorsModel);
      emit(InsertDoctorSucState());
    });
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
      return doc.fullName.toLowerCase().contains(event.query.toLowerCase());
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
        surveysBase = data.toDomain();
        surveys = surveysBase;
        emit(GetSurveyAsyncState(surveys));
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

  Future<void> _onEditUser(EditUserEvent event, Emitter<SyncState> emit) async {
    final checkResult = await updateUserSqlUsecase.execute(event.user);
    await checkResult.fold(
      (failure) async => emit(EditUserErrorState(failure: failure)),
      (data) async {
        emit(EditUserState());
      },
    );
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
        surveys = surveysBase;
      } else {
        emit(SurveySubmitSuccessState(surveys));
      }
    } catch (e) {
      emit(SurveySubmitErrorState(failure: Failure(0, e.toString())));
    }
  }

  // Future<void> _onDoctorsAttendance(
  //   DoctorsAttendanceEvent event,
  //   Emitter<SyncState> emit,
  // ) async {
  //   emit(const DoctorsAttendanceLoadingState());
  //   (await doctorsAttendanceSqlUsecase.execute()).fold(
  //     (failure) => emit(DoctorsAttendanceErrorState(failure: failure)),
  //     (data) {
  //       //   emit(DoctorsAttendanceSuccessState());
  //       emit(DoctorsAttendanceState(data));
  //     },
  //   );
  // }
  Future<void> _onDoctorsBySps(
      GetDoctorBySpsEvent event,
      Emitter<SyncState> emit,
      ) async {
    emit(const DoctorsBySpsLoadingState());
    (await getUsersBySpecIdsSqlUsecase.execute()).fold(
          (failure) => emit(DoctorsBySpsErrorState(failure: failure)),
          (data) {
        //   emit(DoctorsBySpsSuccessState());
        emit(DoctorsBySpsState(data.users,data.conferenceModel));
      },
    );
  }



  Future<void> _onInsertImportantDoctor(
      InsertImportantDoctors event,
      Emitter<SyncState> emit,
      ) async {
    emit(const DoctorsAttendanceLoadingState());
    (await insertImpDoctorForNewConUsecase.execute()).fold(
          (failure) => emit(DoctorsAttendanceErrorState(failure: failure)),
          (data) {
      },
    );
  }

  Future<void> _onIsDone(
    UpdateDoneDoctorEvent event,
    Emitter<SyncState> emit,
  ) async {
    emit(const DoctorsAttendanceLoadingState());
    final checkResult = await updateDoneUsecase.execute(
      event.isDone,
      event.doctor.userModel.id??0,
    );
    await checkResult.fold(
      (failure) async => emit(DoctorsAttendanceErrorState(failure: failure)),
      (data) async {
        emit(DoctorsAttendanceState(event.doctor,event.isDone==0?false:true));
      },
    );
  }

  Future<void> _onInsertUserSql(
    InsertUserSqlEvent event,
    Emitter<SyncState> emit,
  ) async {
    emit(const InsertUserLoadingState());
    (await insertUserAndAnswerUsecase.execute(userSqlModel!)).fold(
      (failure) => emit(InsertUserErrorState(failure: failure)),
      (_) {
        //   emit(InsertUserSuccessState());
        emit(FinishedSurveyState());
      },
    );
  }

  Future<void> _onGetAllUserEvent(
    GetAllUserEvent event,
    Emitter<SyncState> emit,
  ) async {
    (await getUsersConferenceUsecase.execute(conferenceId ?? 0)).fold(
      (failure) => emit(GetUserConferenceErrorState(failure: failure)),
      (data) {
        if (data.isEmpty) {
          emit(GetUserConferenceEmptyState());
        } else {
          emit(GetUserConferenceState(data, data, "الكل"));
        }
      },
    );
  }

  Future<void> _searchInUsersEvent(
    SearchInUsersEvent event,
    Emitter<SyncState> emit,
  ) async {
    final allUsers = event.users;
    List<UserModel> filteredList = [];

    filteredList = allUsers.where((value) {
      if (value.fullName.contains(event.search)) {
        return true;
      }
      if (value.address != null && value.address!.contains(event.search)) {
        return true;
      }

      return false;
    }).toList();

    emit(GetUserConferenceState(allUsers, filteredList, event.nameFilter));
  }
}

void printFinalUsersOutput(List<UserModel> usersList) {
  // 1️⃣ التحقق مما إذا كانت المصفوفة فارغة تماماً
  if (usersList.isEmpty) {
    print("⚠️ النتيجة: مصفوفة المستخدمين فارغة، لا توجد بيانات لطباعتها.");
    return;
  }

  print(
    "================ 📥 الخرج النهائي لمصفوفة المستخدمين (${usersList.length}) ================",
  );

  // 2️⃣ الدوران حول كل كائن مستخدم داخل المصفوفة لطباعة تفاصيله
  for (int i = 0; i < usersList.length; i++) {
    final user = usersList[i];

    print("👤 المستخدم رقم [${i + 1}]:");
    print("   🔹 المعرف (ID): ${user.id}");
    print("   🔹 الاسم الكامل: ${user.fullName}");
    print("   🔹 رقم الهاتف: ${user.phone}");
    print("   🔹 البريد الإلكتروني: ${user.email ?? 'لا يوجد'}");
    print("   🔹 العنوان: ${user.address ?? 'لا يوجد'}");
    print("   🔹 نوع المستخدم (Type ID): ${user.userType.id}");
    print("   🔹 الملاحظات: ${user.notes ?? 'لا توجد'}");

    // 3️⃣ التحقق من كائن الاختصاص (SpecModel) المدمج وطباعته إن وجد
    if (user.spec != null) {
      print("   🔬 الاختصاص الطبي المدمج:");
      print("      🔸 معرف الاختصاص: ${user.spec!.id}");
      print("      🔸 اسم الاختصاص: ${user.spec!.title}");
    } else {
      print(
        "   🔬 الاختصاص الطبي المدمج: ❌ لا يوجد اختصاص مرتبط بهذا المستخدم",
      );
    }

    print("------------------------------------------------------------------");
  }

  print(
    "========================================================================",
  );
}
