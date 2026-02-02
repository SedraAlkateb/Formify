part of 'sync_bloc.dart';

@immutable
sealed class SyncState extends Equatable {
  const SyncState();
  @override
  List<Object?> get props => [];
}

final class SyncInitial extends SyncState {
  const SyncInitial();
}

// ===== Existing states =====
final class AsyncConferenceState extends SyncState {
  final GetAsyncModel asyncModel;
  const AsyncConferenceState(this.asyncModel);

  @override
  List<Object?> get props => [asyncModel];
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

final class DeleteDataState extends SyncState {
  const DeleteDataState();
}

final class InsertSucState extends SyncState {
  const InsertSucState();
}

final class UploadDataState extends SyncState {
  const UploadDataState();
}

final class GetDataState extends SyncState {
  final AllUserModel users;
  const GetDataState(this.users);

  @override
  List<Object?> get props => [users];
}

final class GetConferenceAsyncState extends SyncState {
  final GetAllConferenceModel conferenceModel;
  const GetConferenceAsyncState(this.conferenceModel);

  @override
  List<Object?> get props => [conferenceModel];
}

final class GetConferenceAsyncLoadingState extends SyncState {
  const GetConferenceAsyncLoadingState();
}final class AsyncConferenceErrorState extends SyncState {
  final Failure failure;
  const AsyncConferenceErrorState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

final class GetConferenceAsyncErrorState extends SyncState {
  final Failure failure;
  const GetConferenceAsyncErrorState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

final class GetSurveyAsyncState extends SyncState {
  final List<MainSurveyModel> surveys;
  const GetSurveyAsyncState(this.surveys);

  @override
  List<Object?> get props => [surveys];
}

final class GetSurveyAsyncLoadingState extends SyncState {
  const GetSurveyAsyncLoadingState();
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
  final List<QuestionModel> questions;

  /// index -> answers
  final Map<int, List<AnswerUserModel>> answers;

  /// for UI header/progress only
  final int currentIndex;

  const SurveyReadyState({
    required this.surveyName,
    required this.questions,
    required this.answers,
    required this.currentIndex,
  });

  SurveyReadyState copyWith({
    Map<int, List<AnswerUserModel>>? answers,
    int? currentIndex,
  }) {
    return SurveyReadyState(
      surveyName: surveyName,
      questions: questions,
      answers: answers ?? this.answers,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object?> get props => [surveyName, questions, answers, currentIndex];
}

final class SurveySubmittingState extends SyncState {
  final SurveyReadyState snapshot;
  const SurveySubmittingState(this.snapshot);

  @override
  List<Object?> get props => [snapshot];
}

final class SurveySubmitSuccessState extends SyncState {
  const SurveySubmitSuccessState();
}

final class SurveySubmitErrorState extends SyncState {
  final Failure failure;
  const SurveySubmitErrorState({required this.failure});

  @override
  List<Object?> get props => [failure];
}
