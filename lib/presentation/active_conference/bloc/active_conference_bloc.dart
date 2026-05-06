import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/user_type.dart';
import 'package:formify/domain/usecase/delete_conference_usecase.dart';
import 'package:formify/domain/usecase/get_all_conference_usecase.dart';
import 'package:formify/domain/usecase/get_all_user_usecase.dart';
import 'package:formify/domain/usecase/get_conference_by_id_usecase.dart';
import 'package:formify/domain/usecase/get_doctors_as_map_sql_usecase.dart';
import 'package:formify/domain/usecase/get_user_answers_survey_usecase.dart';
import 'package:meta/meta.dart';

part 'active_conference_event.dart';
part 'active_conference_state.dart';

class ActiveConferenceBloc
    extends Bloc<ActiveConferenceEvent, ActiveConferenceState> {
  final GetAllConferenceUsecase getAllConferenceUsecase;
  final GetConferenceByIdUsecase getConferenceByIdUsecase;
  final GetAllUserUsecase getAllUserUsecase;
  final GetDoctorsAsMapSqlUsecase getDoctorsAsMapSqlUsecase;
  final DeleteConferenceUsecase deleteConferenceUsecase;

  List<SurveyToConferenceModel> surveyModel = [];
  List<GetAllConferenceModel> allActiveConference = [];
  final GetUserAnswersSurveyUsecase getUserAnswersSurveyUsecase;
  Map<String, DoctorsModel> doctors = {};
  ActiveConferenceBloc(
    this.getAllConferenceUsecase,
    this.getConferenceByIdUsecase,
    this.getAllUserUsecase,
    this.getUserAnswersSurveyUsecase,
    this.getDoctorsAsMapSqlUsecase,
    this.deleteConferenceUsecase,
  ) : super(ActiveConferenceInitial()) {
    on<GetAllActiveConferenceEvent>((event, emit) async {
      emit(GetAllActiveConferenceLoadingState());
      final result = await getAllConferenceUsecase.execute(1);
      result.fold(
        (failure) {
          emit(GetAllActiveConferenceErrorState(failure: failure));
        },
        (data) async {
          if (data.isEmpty) {
            emit(GetAllActiveEmptyConferenceState());
          } else {
            allActiveConference = data;
            emit(GetAllActiveConferenceState(data));
          }
        },
      );
    });
    on<DeleteFinishedConferenceEvent>((event, emit) async {
      emit(DeleteFinishedConferenceLoadingState());
      (await deleteConferenceUsecase.execute(event.id)).fold(
        (failure) {
          emit(DeleteFinishedConferenceErrorState(failure: failure));
        },
        (data) async {
          allActiveConference.removeAt(event.index);
          emit(DeleteFinishedConferenceState(allActiveConference));
        },
      );
    });

    on<GetDoctorsAsMapEvent>((event, emit) async {
      emit(GetDoctorsAsMapLoadingState());
      final result = await getDoctorsAsMapSqlUsecase.execute();
      result.fold(
        (failure) {
          emit(GetDoctorsAsMapErrorState(failure: failure));
        },
        (data) async {
          doctors = data;
          emit(GetDoctorsAsMapState(data));
        },
      );
    });

    on<GetAllUserByActiveConferenceEvent>((event, emit) async {
      emit(GetAllUserActiveConferenceLoadingState());
      final result = await getAllUserUsecase.execute(event.conferenceId);
      result.fold(
        (failure) {
          emit(GetAllUserActiveConferenceErrorState(failure: failure));
        },
        (data) async {
          emit(GetAllUserActiveConferenceState(data, "المشاركون", data));
        },
      );
    });
    on<FilterDoctorEvent>((event, emit) async {
      // 1. القائمة الكاملة التي وصلت مع الـ Event
      final allUsers = event.users;

      // 2. قائمة النتائج التي سنقوم بتصفيتها
      List<UserModel> filteredList = [];
      String newTitle = "المشاركون"; // لتحديث العنوان في الـ UI

      // 3. منطق الفلترة بناءً على الـ filterType
      switch (event.filterType) {
        case 0: // الكل
          filteredList = allUsers;
          newTitle = "الكل";
          break;

        case 1: // المهمين (الذين حضروا)
          // هم المستخدمون الموجود أسماؤهم في الـ Map الخاصة بالأطباء المهمين
          filteredList = allUsers.where((user) {
            return doctors.containsKey(user.fullName.trim());
          }).toList();
          newTitle = "المهمين - حضروا";
          break;

        case 2:
          final attendedNames = allUsers.map((u) => u.fullName.trim()).toSet();

          // نبحث في الخريطة المحلية عن أي طبيب اسمه ليس في الـ Set
          final List<UserModel> missingImportant = [];

          doctors.forEach((name, docModel) {
            if (!attendedNames.contains(name.trim())) {
              // نقوم بتحويل DoctorsModel إلى UserModel ليقبل العرض في القائمة
              missingImportant.add(
                UserModel(
                  docModel.id ?? 0,
                  name,
                  "",
                  "",
                  docModel.region,
                  UserType.pharmacist,
                  // أضف أي حقول أخرى يحتاجها الـ UserModel هنا
                ),
              );
            }
          });
          print("objectddd");
          filteredList = missingImportant;

          newTitle = "المهمين - غائبين";

          break;
      }
      for (var user in filteredList) {
        print(
          " | اسم المستخدم: ${user.fullName} | العنوان: ${user.address}  | الرقم: ${user.phone}  | النوع: ${user.userType.name}",
        );
      }
      emit(
        GetAllUserActiveConferenceState(
          allUsers,
          newTitle,
          filteredList,

          // أضف هذا الحقل للـ State لكي تستخدمه في الـ UI
        ),
      );
    });
    on<SearchDoctorEvent>((event, emit) async {
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
      filteredList = allUsers.where((user) {
        return user.fullName.contains(event.search);
      }).toList();
      emit(
        GetAllUserActiveConferenceState(
          allUsers,
          event.filterType,
          filteredList,
        ),
      );
    });

    on<GetActiveConferenceByIdEvent>((event, emit) async {
      emit(GetActiveConferenceByIdLoadingState());
      final result = await getConferenceByIdUsecase.execute(
        event.conferenceModel,
      );
      result.fold(
        (failure) {
          emit(GetActiveConferenceByIdErrorState(failure: failure));
        },
        (data) async {
          data.surveys.sort((a, b) => a.survey_order.compareTo(b.survey_order));
          surveyModel = data.surveys;
          emit(GetActiveConferenceByIdState(data));
        },
      );
    });
    on<GetUserSurveyEvent>((event, emit) async {
      emit(GetUserSurveyLoadingState());
      // final result = await getConferenceByIdUsecase.execute(event.conferenceModel);
      // result.fold(
      //       (failure) {
      //     emit(GetUserSurveyErrorState(failure: failure));
      //   },
      //       (data) async {
      //     data.surveys.sort((a, b) => a.survey_order.compareTo(b.survey_order));
      //     emit(GetUserSurveyState(data));
      //   },
      // );

      emit(GetUserSurveyState(event.userModel, surveyModel));
    });
    on<GetCompletedSurveyEvent>((event, emit) async {
      emit(GetCompletedSurveyLoadingState());
      final result = await getUserAnswersSurveyUsecase.execute(
        event.surveyId,
        event.userId,
      );
      result.fold(
        (failure) {
          emit(GetCompletedSurveyErrorState(failure: failure));
        },
        (data) async {
          emit(GetCompletedSurveyState(data));
        },
      );
    });
  }
}
