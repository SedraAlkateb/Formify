part of 'active_conference_bloc.dart';

@immutable
abstract class ActiveConferenceState extends Equatable{}

final class ActiveConferenceInitial extends ActiveConferenceState {
  @override
  List<Object?> get props =>  [];
}
///////////////////////////AllActiveConference////////////////////
final class GetAllActiveConferenceState extends ActiveConferenceState {
  final List<GetAllConferenceModel> allActiveConference;
  GetAllActiveConferenceState(this.allActiveConference);
  List<Object?> get props => [allActiveConference];
}
final class GetAllActiveEmptyConferenceState extends ActiveConferenceState {

  List<Object?> get props => [];
}
final class GetAllActiveConferenceErrorState extends ActiveConferenceState {
  final Failure failure;
  GetAllActiveConferenceErrorState({required this.failure});
  @override
  List<Object?> get props =>[failure];
}
final class GetAllActiveConferenceLoadingState extends ActiveConferenceState {
  @override
  List<Object?> get props => [];
}

///////////Active conference by id
final class GetActiveConferenceByIdState extends ActiveConferenceState {
  final GetAllConferenceByIdModel conferenceModel;

  GetActiveConferenceByIdState(this.conferenceModel);

  @override
  List<Object?> get props => [conferenceModel];
}
final class GetActiveConferenceByIdErrorState extends ActiveConferenceState {
  final Failure failure;
  GetActiveConferenceByIdErrorState({required this.failure});
  @override
  List<Object?> get props =>[failure];
}
final class GetActiveConferenceByIdLoadingState extends ActiveConferenceState {
  @override
  List<Object?> get props => [];
}


///////////////////////////AllUserActiveConference////////////////////
final class GetAllUserActiveConferenceState extends ActiveConferenceState {
  final List<UserModel> users;
  GetAllUserActiveConferenceState(this.users);
  List<Object?> get props => [users];
}
final class GetAllUserActiveEmptyConferenceState extends ActiveConferenceState {

  List<Object?> get props => [];
}
final class GetAllUserActiveConferenceErrorState extends ActiveConferenceState {
  final Failure failure;
  GetAllUserActiveConferenceErrorState({required this.failure});
  @override
  List<Object?> get props =>[failure];
}
final class GetAllUserActiveConferenceLoadingState extends ActiveConferenceState {
  @override
  List<Object?> get props => [];
}
final class GetUserSurveyState extends ActiveConferenceState {
  final UserModel userModel;
  final List<SurveyToConferenceModel> surveys;

  GetUserSurveyState(this.userModel,this.surveys);

  @override
  List<Object?> get props => [userModel];
}
final class GetUserSurveyErrorState extends ActiveConferenceState {
  final Failure failure;
  GetUserSurveyErrorState({required this.failure});
  @override
  List<Object?> get props =>[failure];
}
final class GetUserSurveyLoadingState extends ActiveConferenceState {
  @override
  List<Object?> get props => [];
}
