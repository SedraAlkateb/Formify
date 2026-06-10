part of 'sync_bloc.dart';

@immutable
abstract class SyncState extends Equatable {
  const SyncState();
  @override
  List<Object?> get props => [];
}

final class SyncInitial extends SyncState {
  const SyncInitial();
}

// ===== Existing states =====


class DoctorsState extends SyncState {
  final List<UserModel> data;
  final UserModel? selectedDoctor; // الطبيب المختار حالياً

  const DoctorsState(this.data, {this.selectedDoctor});
}
class SpecState extends SyncState {
  final List<SpecModel> data;

  const SpecState(this.data);
}
final class DataErrorState extends SyncState {
  final Failure failure;
  const DataErrorState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

final class DataLoadingState extends SyncState {
  const DataLoadingState();
}



final class DeleteUserState extends SyncState {
  const DeleteUserState();
}


final class UploadDataState extends SyncState {
  final int isUpload;
  const UploadDataState(this.isUpload);
  @override
  List<Object?> get props => [isUpload];
}



final class AsyncConferenceErrorState extends SyncState {
  final Failure failure;
  const AsyncConferenceErrorState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

final class GetConferenceAsyncState extends SyncState {
  final GetAllConferenceModel conferenceModel;
  const GetConferenceAsyncState(this.conferenceModel);

  @override
  List<Object?> get props => [conferenceModel];
}

final class GetConferenceAsyncEmptyState extends SyncState {
  @override
  List<Object?> get props => [];
}

final class GetConferenceAsyncLoadingState extends SyncState {
  const GetConferenceAsyncLoadingState();
}

final class GetConferenceAsyncErrorState extends SyncState {
  final Failure failure;
  const GetConferenceAsyncErrorState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

final class GetSurveyAsyncState extends SyncState {
  final List<IsActiveMainSurveyModel> surveys;
  const GetSurveyAsyncState(this.surveys);

  @override
  List<Object?> get props => [surveys];
}

final class GetSurveyAsyncLoadingState extends SyncState {
  const GetSurveyAsyncLoadingState();
}

final class GetSurveyAsyncEmptyState extends SyncState {
  const GetSurveyAsyncEmptyState();
}

final class GetSurveyAsyncErrorState extends SyncState {
  final Failure failure;
  const GetSurveyAsyncErrorState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

// ===== Survey states (new) =====
final class SurveyLoadingState extends SyncState {
  const SurveyLoadingState();
}

final class SurveyErrorState extends SyncState {
  final Failure failure;
  const SurveyErrorState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

/// Ready survey (single source of truth for UI)
final class SurveyReadyState extends SyncState {
  final String surveyName;

  final String surveyDescription;

  final List<QuestionModel> questions;

  /// index -> answers
  final Map<int, List<AnswerUserModel>> answers;

  /// for UI header/progress only
  final int currentIndex;
  final int index;
  final String? time;

  const SurveyReadyState({
    required this.surveyName,
    required this.surveyDescription,
    required this.questions,
    required this.answers,
    required this.currentIndex,
    required this.index,
    required this.time,
  });

  SurveyReadyState copyWith({
    Map<int, List<AnswerUserModel>>? answers,
    int? currentIndex,
  }) {
    return SurveyReadyState(
      surveyName: surveyName,
      surveyDescription: surveyDescription,
      questions: questions,
      answers: answers ?? this.answers,
      currentIndex: currentIndex ?? this.currentIndex,
      index: index,
      time: time,
    );
  }

  @override
  List<Object?> get props => [
    surveyName,
    questions,
    answers,
    currentIndex,
    time,
  ];
}

final class SurveySubmittingState extends SyncState {
  final SurveyReadyState snapshot;
  const SurveySubmittingState(this.snapshot);

  @override
  List<Object?> get props => [snapshot];
}

final class SurveySubmitSuccessState extends SyncState {
  final List<IsActiveMainSurveyModel> surveys;
  const SurveySubmitSuccessState(this.surveys);

  @override
  List<Object?> get props => [surveys];
}

final class SurveySubmitErrorState extends SyncState {
  final Failure failure;
  const SurveySubmitErrorState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

final class InsertUserSuccessState extends SyncState {
  const InsertUserSuccessState();
}

final class InsertUserErrorState extends SyncState {
  final Failure failure;
  const InsertUserErrorState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

final class InsertUserLoadingState extends SyncState {
  const InsertUserLoadingState();
}

final class FinishedSurveyState extends SyncState {
  const FinishedSurveyState();
}

final class GetInfoConferenceSuccessState extends SyncState {
  final InfoConference infoConference;
  const GetInfoConferenceSuccessState(this.infoConference);
  @override
  List<Object?> get props => [infoConference];
}

final class GetInfoConferenceErrorState extends SyncState {
  final Failure failure;
  const GetInfoConferenceErrorState({required this.failure});

  @override
  List<Object?> get props => [failure];
}



final class InsertDoctorErrorState extends SyncState {
  final Failure failure;
  const InsertDoctorErrorState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

final class InsertDoctorSucState extends SyncState {
  const InsertDoctorSucState();

  @override
  List<Object?> get props => [];
}

final class InsertDoctorLoadingState extends SyncState {
  const InsertDoctorLoadingState();

  @override
  List<Object?> get props => [];
}


final class GetUserConferenceEmptyState extends SyncState {
  @override
  List<Object?> get props => [];
}

final class GetUserConferenceErrorState extends SyncState {
  final Failure failure;
  const GetUserConferenceErrorState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

final class NavigateToSurveyState extends SyncState {
  @override
  List<Object?> get props => [];
}

final class NavigateToConferenceState extends SyncState {
  @override
  List<Object?> get props => [];
}

final class EditUserState extends SyncState {
  const EditUserState();

  @override
  List<Object?> get props => [];
}

final class EditUserLoadingState extends SyncState {
  const EditUserLoadingState();
}

final class EditUserEmptyState extends SyncState {
  const EditUserEmptyState();
}

final class EditUserErrorState extends SyncState {
  final Failure failure;
  const EditUserErrorState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

final class DoctorsAttendanceState extends SyncState {
  final List<DoctorMockItem> users;
  const DoctorsAttendanceState(this.users);

  @override
  List<Object?> get props => [users];
}
final class DoctorsAttendanceLoadingState extends SyncState {
  const DoctorsAttendanceLoadingState();
}
final class DoctorsAttendanceEmptyState extends SyncState {
  const DoctorsAttendanceEmptyState();
}
final class DoctorsAttendanceErrorState extends SyncState {
  final Failure failure;
  const DoctorsAttendanceErrorState({required this.failure});

  @override
  List<Object?> get props => [failure];
}
class UserFilterState extends SyncState {
  final List<UserModel> data;

  const UserFilterState(this.data);

  @override
  List<Object?> get props => [data];
}
final class GetAllUserWithFilterState extends SyncState {
  final List<UserModel> users;
  final List<UserModel> userFilter;
  final String newTitle;
  GetAllUserWithFilterState(this.users, this.newTitle, this.userFilter);
  List<Object?> get props => [userFilter];
}
final class GetUserConferenceState extends SyncState {
  final List<UserModel> users;
  final List<UserModel> filterUsers;
  final String newTitle;
  const GetUserConferenceState(this.users, this.filterUsers,this.newTitle);
  @override
  List<Object?> get props => [filterUsers];
}
final class DoctorsBySpsState extends SyncState {
  final List<UserModel> users;
  const DoctorsBySpsState(this.users);

  @override
  List<Object?> get props => [users];
}
final class DoctorsBySpsLoadingState extends SyncState {
  const DoctorsBySpsLoadingState();
}
final class DoctorsBySpsEmptyState extends SyncState {
  const DoctorsBySpsEmptyState();
}
final class DoctorsBySpsErrorState extends SyncState {
  final Failure failure;
  const DoctorsBySpsErrorState({required this.failure});

  @override
  List<Object?> get props => [failure];
}