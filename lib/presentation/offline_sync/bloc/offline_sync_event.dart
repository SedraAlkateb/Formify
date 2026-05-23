part of 'offline_sync_bloc.dart';

@immutable
sealed class OfflineSyncEvent extends Equatable {
  const OfflineSyncEvent();
  @override
  List<Object?> get props => [];
}
final class AsyncDataEvent extends OfflineSyncEvent {
  final int conferenceId;
  const AsyncDataEvent(this.conferenceId);
}

final class InsertDataSqlEvent extends OfflineSyncEvent {
  final GetAsyncModel asyncModel;
  const InsertDataSqlEvent(this.asyncModel);

  @override
  List<Object?> get props => [asyncModel];
}

class AddAndModifyUserEvent extends OfflineSyncEvent {
final int id;
final int type;
const AddAndModifyUserEvent(this.id,this.type);
}
class UploadUserEvent extends OfflineSyncEvent {
  final AddAndModifyUsersRequest users;
  const UploadUserEvent(this.users);

}
class UpdateUserIdEvent extends OfflineSyncEvent {
  final List<AddModifyUser>syncedUsers ;
  const UpdateUserIdEvent(this.syncedUsers);

}
class UploadUserAnswerAndUserConferenceEvent extends OfflineSyncEvent {
  final SyncUsersRequest data;
  const UploadUserAnswerAndUserConferenceEvent(this.data);

}
class GetUserAnswerAndUserConferenceEvent extends OfflineSyncEvent {
  const GetUserAnswerAndUserConferenceEvent();

}
class DeleteSyncDataEvent extends OfflineSyncEvent {


}
class DeleteAllDataEvent extends OfflineSyncEvent {


}
class GetSaveDataEvent extends OfflineSyncEvent {
  @override
  List<Object?> get props => [];
}
class AddSaveDataEvent extends OfflineSyncEvent {
  final SaveDataBaseModel data;
  const AddSaveDataEvent(this.data);
  @override
  List<Object?> get props => [data];
}