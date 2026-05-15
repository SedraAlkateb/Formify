part of 'conference_bloc.dart';

@immutable
abstract class ConferenceEvent extends Equatable {}

class CreateConferenceEvent extends ConferenceEvent {
  final ConferenceModel payload;
  CreateConferenceEvent(this.payload);

  @override
  List<Object?> get props => [payload];
}

class GetAllSurveyByConferenceEvent extends ConferenceEvent {
  final int conferenceId;
  GetAllSurveyByConferenceEvent(this.conferenceId);
  @override
  List<Object?> get props => [conferenceId];
}

class LinkSurveyConferenceEvent extends ConferenceEvent {
  final int surveyId;
  final int index;
  final int conferenceId;
  final List<IsActiveMainSurveyModel> surveys;
  LinkSurveyConferenceEvent(
    this.surveyId,
    this.index,
    this.surveys,
    this.conferenceId,
  );
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

class UpdateConferenceEvent extends ConferenceEvent {
  final int refreshId;

  UpdateConferenceEvent(this.refreshId);

  @override
  List<Object?> get props => [refreshId];
}
class UpdateInfoConferenceEvent extends ConferenceEvent {
  final GetAllConferenceByIdModel conferenceModel;
  UpdateInfoConferenceEvent(this.conferenceModel);

  @override
  List<Object?> get props => [conferenceModel];
}
class GetAllSpecEvent extends ConferenceEvent {
  @override
  List<Object?> get props => [];
}

// حدث لإضافة اختصاص مختار إلى القائمة المحلية
class AddSpecialtyToLocalListEvent extends ConferenceEvent {
  final SpecModel specialty;
  AddSpecialtyToLocalListEvent(this.specialty);

  @override
  List<Object?> get props =>[specialty];
}

// حدث لحذف اختصاص من القائمة المحلية
class RemoveSpecialtyFromLocalListEvent extends ConferenceEvent {
  final int specialtyId;
  RemoveSpecialtyFromLocalListEvent(this.specialtyId);
  @override
  List<Object?> get props =>[specialtyId];
}

class CreateSpecEvent extends ConferenceEvent {
  final String name;
  final List<SpecModel> spec;
  CreateSpecEvent(this.name,this.spec);
  @override
  List<Object?> get props =>[name,spec];
}
