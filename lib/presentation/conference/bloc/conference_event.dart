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
class LinkSurveyConferenceEvent extends ConferenceEvent {
final int surveyId;
final int index;
LinkSurveyConferenceEvent(this.surveyId,this.index);
  @override
  List<Object?> get props => [surveyId];
}
class GetAllActiveConferenceEvent extends ConferenceEvent {

GetAllActiveConferenceEvent();
  @override
  List<Object?> get props => [];
}
class GetAllNotActiveConferenceEvent extends ConferenceEvent {
  GetAllNotActiveConferenceEvent();
  @override
  List<Object?> get props => [];
}