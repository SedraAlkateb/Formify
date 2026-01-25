part of 'sync_bloc.dart';

@immutable
sealed class SyncEvent extends Equatable{}


class AsyncDataEvent extends SyncEvent {

  @override
  List<Object?> get props => [];
}
class InsertDataSqlEvent extends SyncEvent {

  @override
  List<Object?> get props => [];
}
class DeleteDataEvent extends SyncEvent {
  DeleteDataEvent();
  @override
  List<Object?> get props => [];
}
class UploadDataEvent extends SyncEvent {
  final AllUserModel userRequest;
  UploadDataEvent( this.userRequest);
  @override
  List<Object?> get props => [userRequest];
}

class GetDataEvent extends SyncEvent {
 final  int conferenceId;
 GetDataEvent(this.conferenceId);
  @override
  List<Object?> get props => [conferenceId];
}