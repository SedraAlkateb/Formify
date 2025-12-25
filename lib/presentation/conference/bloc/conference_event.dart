part of 'conference_bloc.dart';

@immutable
sealed class ConferenceEvent extends Equatable{}
class CreateConferenceEvent extends ConferenceEvent {
  final ConferenceModel payload;
  CreateConferenceEvent(this.payload);

  @override
  List<Object?> get props => [payload];
}
class GetAllSurveyEvent extends ConferenceEvent {

  @override
  List<Object?> get props => [];
}