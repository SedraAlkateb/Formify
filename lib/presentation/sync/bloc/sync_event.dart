part of 'sync_bloc.dart';

@immutable
abstract class SyncEvent extends Equatable {
  const SyncEvent();
  @override
  List<Object?> get props => [];
}

// ===== Existing app events =====


final class InsertUserSqlEvent extends SyncEvent {

  @override
  List<Object?> get props => [];
}
final class InputUserSqlEvent extends SyncEvent {
  final UserSqlModel userSqlModel;
  const InputUserSqlEvent(this.userSqlModel);

  @override
  List<Object?> get props => [userSqlModel];
}





final class GetInfoConferenceEvent extends SyncEvent {
  @override
  List<Object?> get props => [];
}



final class GetConferenceAsyncEvent extends SyncEvent {
  const GetConferenceAsyncEvent();
}

final class GetSurveyAsyncEvent extends SyncEvent {
  const GetSurveyAsyncEvent();
}


// ===== Survey Flow events (professional) =====
/// fetch questions from server/db
final class GetQuestionAnswersEvent extends SyncEvent {
  final int id;
  final String surveyName;
  final String surveyDescription;
  final int index;
  final String? time;

  const GetQuestionAnswersEvent(
      this.id, this.surveyName, this.surveyDescription, this.index, this.time);

  @override
  List<Object?> get props => [id, surveyName];
}

/// UI tells bloc that page changed (for header/progress only)
final class SurveyPageChangedEvent extends SyncEvent {
  final int index;
  const SurveyPageChangedEvent(this.index);

  @override
  List<Object?> get props => [index];
}

/// UI sends raw value of current page after save/saveAndValidate
final class SurveySaveAnswerEvent extends SyncEvent {
  final int index; // question index in list
  final QuestionModel question;
  final dynamic rawValue;
  const SurveySaveAnswerEvent({
    required this.index,
    required this.question,
    required this.rawValue,
  });

  @override
  List<Object?> get props => [index, rawValue];
}

/// submit survey
final class SurveySubmitEvent extends SyncEvent {
  const SurveySubmitEvent();
}


class EditUserEvent extends SyncEvent {
  final UserModel user;
  EditUserEvent(this.user);

  @override
  List<Object?> get props => [user];
}
// ===== Doctor Management Events =====

/// جلب قائمة الأطباء من قاعدة البيانات
class DoctorEvent extends SyncEvent {
  const DoctorEvent();

  @override
  List<Object?> get props => [];
}
class InsertEvent extends SyncEvent {
 final UserModel doctorsModel;
  const InsertEvent(this.doctorsModel);

  @override
  List<Object?> get props => [doctorsModel];
}

/// البحث في قائمة الأطباء (Memory-based search)
class SearchDoctorEvent extends SyncEvent {
  final String query;
  const SearchDoctorEvent(this.query);

  @override
  List<Object?> get props => [query];
}

/// اختيار طبيب محدد من القائمة (لتخزين الـ ID)
final class SelectDoctorEvent extends SyncEvent {
  final UserModel doctor;
  const SelectDoctorEvent(this.doctor);

  @override
  List<Object?> get props => [doctor];
}

/// تصفير الاختيار عند التعديل اليدوي في حقل النص
final class ClearDoctorSelectionEvent extends SyncEvent {
  const ClearDoctorSelectionEvent();
}
final class GetAllUserEvent extends SyncEvent {
  const GetAllUserEvent();
}
final class SearchInUsersEvent extends SyncEvent {
  final List<UserModel> users;
  final String search;
  const SearchInUsersEvent(this.users,this.search);
}
final class DoctorsAttendanceEvent extends SyncEvent {

}
// حدث تحديث حالة طبيب واحد في قاعدة البيانات
class UpdateDoneDoctorEvent extends SyncEvent {
  final DoctorMockItem doctorMockItem;
  final List<DoctorMockItem> doctors;
 // List<DoctorMockItem> doctors;
  const UpdateDoneDoctorEvent({required this.doctorMockItem, required this.doctors
    //,required this.doctors
  });
}
/// جلب قائمة الأطباء من قاعدة البيانات
class SpecEvent extends SyncEvent {
  const SpecEvent();

  @override
  List<Object?> get props => [];
}
class FilterDoctorBySpecAndNameEvent extends SyncEvent {
 final String doctorName;
 final int spId;
  const FilterDoctorBySpecAndNameEvent(this.doctorName,this.spId);

  @override
  List<Object?> get props => [];
}