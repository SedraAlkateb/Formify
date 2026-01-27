part of 'sync_bloc.dart';

@immutable
sealed class SyncState extends Equatable{}

final class SyncInitial extends SyncState {
  @override
  List<Object?> get props =>  [];
}
final class AsyncConferenceState extends SyncState {
  final   GetAsyncModel asyncModel;
AsyncConferenceState(this.asyncModel);
  List<Object?> get props => [asyncModel];
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
 final AllUserModel users;
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
final class GetConferenceAsyncState extends SyncState {
  final GetAllConferenceModel conferenceModel;
  GetConferenceAsyncState(this.conferenceModel);
  List<Object?> get props => [conferenceModel];
}
final class GetConferenceAsyncErrorState extends SyncState {
  final Failure failure;
  GetConferenceAsyncErrorState({required this.failure});
  @override
  List<Object?> get props =>[failure];
}
final class GetConferenceAsyncLoadingState extends SyncState {
  @override
  List<Object?> get props => [];
}

final class GetSurveyAsyncState extends SyncState {
  final List<MainSurveyModel> surveys;
  GetSurveyAsyncState(this.surveys);
  List<Object?> get props => [surveys];
}
final class GetSurveyAsyncErrorState extends SyncState {
  final Failure failure;
  GetSurveyAsyncErrorState({required this.failure});
  @override
  List<Object?> get props =>[failure];
}
final class GetSurveyAsyncLoadingState extends SyncState {
  @override
  List<Object?> get props => [];
}

final class GetQuestionAnswersState extends SyncState {
  final List<QuestionModel> questions;
  final String surveyName;
  GetQuestionAnswersState(this.questions,this.surveyName);
  List<Object?> get props => [questions,surveyName];
}
final class GetQuestionAnswersErrorState extends SyncState {
  final Failure failure;
  GetQuestionAnswersErrorState({required this.failure});
  @override
  List<Object?> get props =>[failure];
}
final class GetQuestionAnswersLoadingState extends SyncState {
  @override
  List<Object?> get props => [];
}
