part of 'conference_bloc.dart';

@immutable
sealed class ConferenceEvent extends Equatable {}

class CreateConferenceEvent extends ConferenceEvent {
  final ConferenceModel payload;
  CreateConferenceEvent(this.payload);

  @override
  List<Object?> get props => [payload];
}

class GetAllSurveyByConferenceEvent extends ConferenceEvent {
 final  int conferenceId;
 GetAllSurveyByConferenceEvent(this.conferenceId);
  @override
  List<Object?> get props => [conferenceId];
}

class LinkSurveyConferenceEvent extends ConferenceEvent {
  final int surveyId;
  final int index;
  final int conferenceId;
  final List<IsActiveMainSurveyModel> surveys;
  LinkSurveyConferenceEvent(this.surveyId, this.index, this.surveys,this.conferenceId);
  @override
  List<Object?> get props => [surveyId, surveys];
}


class GetConferenceByIdEvent extends ConferenceEvent {
  final int conferenceId;

  GetConferenceByIdEvent(this.conferenceId);

  @override
  List<Object?> get props => [conferenceId];
}

class GetAllNotActiveConferenceEvent extends ConferenceEvent {
  GetAllNotActiveConferenceEvent();
  @override
  List<Object?> get props => [];
}

class DeleteConferenceEvent extends ConferenceEvent {
  final int id;
  final int index;
  DeleteConferenceEvent(this.id, this.index);
  @override
  List<Object?> get props => [id];
}
class SelectEndedConferenceEvent extends ConferenceEvent {
  final int index;
  SelectEndedConferenceEvent(this.index);
  @override
  List<Object?> get props => [index];
}

