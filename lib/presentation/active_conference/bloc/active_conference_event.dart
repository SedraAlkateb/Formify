part of 'active_conference_bloc.dart';

@immutable
abstract class ActiveConferenceEvent extends Equatable{}

class GetAllActiveConferenceEvent extends ActiveConferenceEvent {
  GetAllActiveConferenceEvent();
  @override
  List<Object?> get props => [];
}

class GetActiveConferenceByIdEvent extends ActiveConferenceEvent {
  final int conferenceModel;

  GetActiveConferenceByIdEvent(this.conferenceModel);

  @override
  List<Object?> get props => [conferenceModel];
}




class GetAllSurveyByActiveConferenceEvent extends ActiveConferenceEvent {
  final  int conferenceId;
  GetAllSurveyByActiveConferenceEvent(this.conferenceId);
  @override
  List<Object?> get props => [conferenceId];
}
class GetAllUserByActiveConferenceEvent extends ActiveConferenceEvent {
  final  int conferenceId;
  GetAllUserByActiveConferenceEvent(this.conferenceId);
  @override
  List<Object?> get props => [conferenceId];
}class GetUserSurveyEvent extends ActiveConferenceEvent {
  final UserModel userModel;
  GetUserSurveyEvent(this.userModel);
  @override
  List<Object?> get props => [userModel];
}