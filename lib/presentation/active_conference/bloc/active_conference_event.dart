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
class GetCompletedSurveyEvent extends ActiveConferenceEvent {
  final int surveyId;
  final int userId;

  GetCompletedSurveyEvent(this.surveyId, this.userId);

  @override
  List<Object?> get props => [];
}

class FilterDoctorEvent extends ActiveConferenceEvent {
  final int filterType;
  final List<UserModel> users;
  FilterDoctorEvent(this.filterType,this.users);
  @override
  List<Object?> get props => [];
}
class DeleteFinishedConferenceEvent extends ActiveConferenceEvent {
  final int id;
  final int index;
  DeleteFinishedConferenceEvent(this.id, this.index);
  @override
  List<Object?> get props => [id];
}
class  ExelUserEvent extends ActiveConferenceEvent {
  final List<UserModel> users;
  ExelUserEvent(this.users);
  @override
  List<Object?> get props => [users];
}
class SearchDoctorEvent extends ActiveConferenceEvent {
  final String search;
  final List<UserModel> users;
  final String filterType;
  SearchDoctorEvent({required this.search,required this.users,required this.filterType});
  @override
  List<Object?> get props => [users];
}