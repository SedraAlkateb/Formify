part of 'offline_sync_bloc.dart';

@immutable
abstract class OfflineSyncState extends Equatable{
  const OfflineSyncState();
  @override
  List<Object?> get props => [];
}

final class OfflineSyncInitial extends OfflineSyncState {
  const  OfflineSyncInitial();
}

final class AddAndModifyUserSucState extends OfflineSyncState {
  final AddAndModifyUsersRequest users;
  const AddAndModifyUserSucState(this.users);

  @override
  List<Object?> get props => [users];
}

final class UploadUserSucState extends OfflineSyncState {
  final List<AddModifyUser> users;
  const UploadUserSucState(this.users);

  @override
  List<Object?> get props => [users];
}

final class UpdateIdUserSucState extends OfflineSyncState {
  @override
  List<Object?> get props => [];
}

final class GetUserAnswerAndUserConferenceState extends OfflineSyncState {
  final SyncUsersRequest data;
  final int type;
  const GetUserAnswerAndUserConferenceState(this.data,this.type);

  @override
  List<Object?> get props => [
    //users
  ];
}

final class UploadUserAnswerAndUserConferenceState extends OfflineSyncState {
  final int type;
  const UploadUserAnswerAndUserConferenceState(this.type);
  @override
  List<Object?> get props => [
    type
  ];
}

final class DeleteSyncDataState extends OfflineSyncState {}
final class DeleteAllDataState extends OfflineSyncState {
  final int type;
  const DeleteAllDataState(this.type);


}

final class GetSaveDataState extends OfflineSyncState {
  final SaveDataBaseModel data;
  const GetSaveDataState(this.data);
  @override
  List<Object?> get props => [data];
}
final class AddSaveDataSqlState extends OfflineSyncState {
  final int type;
  const AddSaveDataSqlState(this.type);
  @override
  List<Object?> get props => [];
}

final class DataOfflineErrorState extends OfflineSyncState {
  final Failure failure;
  const DataOfflineErrorState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

final class DataOfflineLoadingState extends OfflineSyncState {
  const DataOfflineLoadingState();
}
final class AsyncConferenceState extends OfflineSyncState {
  final GetAsyncModel asyncModel;
  const AsyncConferenceState(this.asyncModel);

  @override
  List<Object?> get props => [asyncModel];
}
final class InsertSucState extends OfflineSyncState {
  final int conferenceId;
  const InsertSucState(this.conferenceId);
}
final class SyncLoadingState extends OfflineSyncState {
  const SyncLoadingState();
}
final class CheckoutState extends OfflineSyncState {
  CheckoutState();
  List<Object?> get props => [];
}