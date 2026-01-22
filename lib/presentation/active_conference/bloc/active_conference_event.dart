part of 'active_conference_bloc.dart';

@immutable
sealed class ActiveConferenceEvent extends Equatable{}

class GetAllActiveConferenceEvent extends ActiveConferenceEvent {
  GetAllActiveConferenceEvent();
  @override
  List<Object?> get props => [];
}

class GetActiveConferenceByIdEvent extends ActiveConferenceEvent {
  final GetAllConferenceModel conferenceModel;

  GetActiveConferenceByIdEvent(this.conferenceModel);

  @override
  List<Object?> get props => [conferenceModel];
}
