part of 'conference_bloc.dart';

@immutable
sealed class ConferenceState extends Equatable{}

final class ConferenceInitial extends ConferenceState {
  @override
  List<Object?> get props => [];
}
////////////////////////////////////////
final class CreateConferenceState extends ConferenceState {
  CreateConferenceState();
  List<Object?> get props => [];
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
final class GetAllSurveyState extends ConferenceState {
 final List<MainSurveyModel> allSurvey;
  GetAllSurveyState(this.allSurvey);
  List<Object?> get props => [allSurvey];
}
final class GetAllSurveyErrorState extends ConferenceState {
  final Failure failure;
  GetAllSurveyErrorState({required this.failure});
  @override
  List<Object?> get props =>[failure];
}
final class GetAllSurveyLoadingState extends ConferenceState {
  @override
  List<Object?> get props => [];
}