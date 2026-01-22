part of 'sync_bloc.dart';

@immutable
sealed class SyncState extends Equatable{}

final class SyncInitial extends SyncState {
  @override
  List<Object?> get props =>  [];
}
final class AsyncConferenceState extends SyncState {
final GetAsyncModel asyncModel;
AsyncConferenceState(this.asyncModel);
  List<Object?> get props => [];
}
final class AsyncConferenceErrorState extends SyncState {
  final Failure failure;
  AsyncConferenceErrorState({required this.failure});
  @override
  List<Object?> get props =>[failure];
}
final class AsyncConferenceLoadingState extends SyncState {
  @override
  List<Object?> get props => [];
}

final class DeleteDataState extends SyncState {
  List<Object?> get props => [];
}
final class DataErrorState extends SyncState {
  final Failure failure;
  DataErrorState({required this.failure});
  @override
  List<Object?> get props =>[failure];
}
final class DeleteDataLoadingState extends SyncState {
  @override
  List<Object?> get props => [];
}

final class InsertSucState extends SyncState {
  @override
  List<Object?> get props => [];
}
final class UploadDataState extends SyncState {
  List<Object?> get props => [];
}
final class UploadDataErrorState extends SyncState {
  final Failure failure;
  UploadDataErrorState({required this.failure});
  @override
  List<Object?> get props =>[failure];
}
final class UploadDataLoadingState extends SyncState {
  @override
  List<Object?> get props => [];
}


final class GetDataState extends SyncState {
 final List<UserRequest> users;
  GetDataState(this.users);
  List<Object?> get props => [];
}
final class GetDataErrorState extends SyncState {
  final Failure failure;
  GetDataErrorState({required this.failure});
  @override
  List<Object?> get props =>[failure];
}
final class DataLoadingState extends SyncState {
  @override
  List<Object?> get props => [];
}