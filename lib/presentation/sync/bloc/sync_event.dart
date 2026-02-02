part of 'sync_bloc.dart';

@immutable
abstract class SyncEvent extends Equatable {
  const SyncEvent();
  @override
  List<Object?> get props => [];
}

// ===== Existing app events =====
final class AsyncDataEvent extends SyncEvent {
  const AsyncDataEvent();
}

final class InsertDataSqlEvent extends SyncEvent {
  final GetAsyncModel asyncModel;
  const InsertDataSqlEvent(this.asyncModel);

  @override
  List<Object?> get props => [asyncModel];
}

final class InputUserSqlEvent extends SyncEvent {
  final UserSqlModel userSqlModel;
  const InputUserSqlEvent(this.userSqlModel);

  @override
  List<Object?> get props => [userSqlModel];
}

final class DeleteDataEvent extends SyncEvent {
  const DeleteDataEvent();
}

final class UploadDataEvent extends SyncEvent {
  final AllUserModel userRequest;
  const UploadDataEvent(this.userRequest);

  @override
  List<Object?> get props => [userRequest];
}

final class GetDataEvent extends SyncEvent {
  final int conferenceId;
  const GetDataEvent(this.conferenceId);

  @override
  List<Object?> get props => [conferenceId];
}

final class GetConferenceAsyncEvent extends SyncEvent {
  const GetConferenceAsyncEvent();
}

final class GetSurveyAsyncEvent extends SyncEvent {
  const GetSurveyAsyncEvent();
}

final class CreateUserAnswerEvent extends SyncEvent {
  const CreateUserAnswerEvent();
}

// ===== Survey Flow events (professional) =====
/// fetch questions from server/db
final class GetQuestionAnswersEvent extends SyncEvent {
  final int id;
  final String surveyName;
  const GetQuestionAnswersEvent(this.id, this.surveyName);

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
