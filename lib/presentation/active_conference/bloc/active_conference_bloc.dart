import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/user_type.dart';
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
  List<SurveyToConferenceModel> surveyModel = [];
  final GetUserAnswersSurveyUsecase getUserAnswersSurveyUsecase;
  Map<String, DoctorsModel> doctors = {};
  ActiveConferenceBloc(
    this.getAllConferenceUsecase,
    this.getConferenceByIdUsecase,
    this.getAllUserUsecase,
    this.getUserAnswersSurveyUsecase,
    this.getDoctorsAsMapSqlUsecase,
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
            emit(GetAllActiveConferenceState(data));
          }
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
          if (data.isEmpty) {
            emit(GetAllUserActiveEmptyConferenceState());
          } else {
            emit(GetAllUserActiveConferenceState(data,"المشاركون",data));
          }
        },
      );
    });
    on<FilterDoctorEvent>((event, emit) async {
      // 1. القائمة الكاملة التي وصلت مع الـ Event
      final allUsers = event.users;

      // 2. قائمة النتائج التي سنقوم بتصفيتها
      List<UserModel> filteredList = [];
      String newTitle = "المشاركون"; // لتحديث العنوان في الـ UI

      if (allUsers.isEmpty) {
        emit(GetAllUserActiveEmptyConferenceState());
        return;
      }

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

        case 2: // المهمين (الذين لم يحضروا)
          // هم الأطباء الموجودون في الـ Map (المحلي) ولكن أسماؤهم غير موجودة في قائمة الـ API
          // نحتاج لتحويل أسماء الحاضرين لـ Set لتسريع البحث
          final attendedNames = allUsers.map((u) => u.fullName.trim()).toSet();

          // نبحث في الخريطة المحلية عن أي طبيب اسمه ليس في الـ Set
          final List<UserModel> missingImportant = [];

          doctors.forEach((name, docModel) {
            if (!attendedNames.contains(name.trim())) {
              // نقوم بتحويل DoctorsModel إلى UserModel ليقبل العرض في القائمة
              missingImportant.add(
                UserModel(
                  docModel.id,
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

          filteredList = missingImportant;
          newTitle = "المهمين - غائبين";
          break;
      }

      // 4. إرسال الحالة الجديدة (تأكد أن الـ State يقبل العنوان الجديد والقائمة)
      if (filteredList.isEmpty) {
        emit(GetAllUserActiveEmptyConferenceState());
        // ملاحظة: قد تفضل إنشاء State خاص بالفلتر الفارغ لكي لا تختفي الواجهة تماماً
      } else {
        emit(
          GetAllUserActiveConferenceState(
            allUsers,
            newTitle,
             filteredList,

                // أضف هذا الحقل للـ State لكي تستخدمه في الـ UI
          ),
        );
      }
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
