part of 'sync_bloc.dart';

@immutable
sealed class SyncEvent extends Equatable {}

class AsyncDataEvent extends SyncEvent {
  @override
  List<Object?> get props => [];
}

class InsertDataSqlEvent extends SyncEvent {
  final GetAsyncModel asyncModel;

  InsertDataSqlEvent(this.asyncModel);

  @override
  List<Object?> get props => [];
}
class InputUserSqlEvent extends SyncEvent {
  final UserSqlModel userSqlModel;

  InputUserSqlEvent(this.userSqlModel);

  @override
  List<Object?> get props => [userSqlModel];
}
class DeleteDataEvent extends SyncEvent {
  DeleteDataEvent();
  @override
  List<Object?> get props => [];
}

class UploadDataEvent extends SyncEvent {
  final AllUserModel userRequest;
  UploadDataEvent(this.userRequest);
  @override
  List<Object?> get props => [userRequest];
}

class GetDataEvent extends SyncEvent {
  final int conferenceId;
  GetDataEvent(this.conferenceId);
  @override
  List<Object?> get props => [conferenceId];
}

class GetConferenceAsyncEvent extends SyncEvent {
  GetConferenceAsyncEvent();
  @override
  List<Object?> get props => [];
}
class GetSurveyAsyncEvent extends SyncEvent {
  GetSurveyAsyncEvent();
  @override
  List<Object?> get props => [];
}