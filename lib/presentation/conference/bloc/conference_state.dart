part of 'conference_bloc.dart';

@immutable
sealed class ConferenceState extends Equatable{}

final class ConferenceInitial extends ConferenceState {
  @override
  List<Object?> get props => [];
}
////////////////////////////////////////
final class CreateConferenceState extends ConferenceState {
  final int conferenceId ;
  CreateConferenceState(this.conferenceId);
  List<Object?> get props => [conferenceId];
}
final class CreateConferenceErrorState extends ConferenceState {
  final Failure failure;
  CreateConferenceErrorState({required this.failure});
  @override
  List<Object?> get props =>[failure];
}
final class CreateConferenceLoadingState extends ConferenceState {
  @override
  List<Object?> get props => [];
}
/////////////////////////////////////////
final class GetAllSurveyConferenceState extends ConferenceState {
 final List<IsActiveMainSurveyModel> allSurvey;
  GetAllSurveyConferenceState(this.allSurvey);
  List<Object?> get props => [allSurvey];
}
final class GetAllSurveyConferenceErrorState extends ConferenceState {
  final Failure failure;
  GetAllSurveyConferenceErrorState({required this.failure});
  @override
  List<Object?> get props =>[failure];
}
final class GetAllSurveyConferenceLoadingState extends ConferenceState {
  @override
  List<Object?> get props => [];
}
final class LinkSurveyConferenceState extends ConferenceState {
  List<Object?> get props => [];
}
final class LinkSurveyConferenceErrorState extends ConferenceState {
  final Failure failure;
  LinkSurveyConferenceErrorState({required this.failure});
  @override
  List<Object?> get props =>[failure];
}
final class LinkSurveyConferenceLoadingState extends ConferenceState {
  final int index;
  LinkSurveyConferenceLoadingState(this.index);
  @override
  List<Object?> get props => [];
}

///////////////////////////AllConference////////////////////
final class GetAllConferenceState extends ConferenceState {
  final List<GetAllConferenceModel> allConference;
  GetAllConferenceState(this.allConference);
  List<Object?> get props => [allConference];
}
final class GetAllEmptyConferenceState extends ConferenceState {

  List<Object?> get props => [];
}
final class GetAllConferenceErrorState extends ConferenceState {
  final Failure failure;
  GetAllConferenceErrorState({required this.failure});
  @override
  List<Object?> get props =>[failure];
}
final class GetAllConferenceLoadingState extends ConferenceState {
  @override
  List<Object?> get props => [];
}

//////////////////////Delete
final class DeleteConferenceState extends ConferenceState {

  List<Object?> get props => [];
}
final class DeleteConferenceErrorState extends ConferenceState {
  final Failure failure;
  DeleteConferenceErrorState({required this.failure});
  @override
  List<Object?> get props =>[failure];
}
final class DeleteConferenceLoadingState extends ConferenceState {
  @override
  List<Object?> get props => [];
}
final class GetConferenceByIdState extends ConferenceState {
  final GetAllConferenceByIdModel conferenceModel;

  GetConferenceByIdState(this.conferenceModel);

  @override
  List<Object?> get props => [conferenceModel];
}
final class GetConferenceByIdErrorState extends ConferenceState {
  final Failure failure;
  GetConferenceByIdErrorState({required this.failure});
  @override
  List<Object?> get props =>[failure];
}
final class GetConferenceByIdLoadingState extends ConferenceState {
  @override
  List<Object?> get props => [];
}
final class SelectEndedConferenceState extends ConferenceState {

  final int ?index;
  SelectEndedConferenceState(this.index);
  @override
  List<Object?> get props => [index];
}