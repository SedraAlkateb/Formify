part of 'manager_user_bloc.dart';

@immutable
sealed class ManagerUserEvent  extends Equatable{
  @override
  List<Object?> get props => [];
}

class GetAllUsersEvent extends ManagerUserEvent{

  @override
  List<Object?> get props => [];
}
class SearchUsersEvent extends ManagerUserEvent {
  final String searchText;
  SearchUsersEvent(this.searchText);
}

class FilterBySpecialityEvent extends ManagerUserEvent {
  final SpecModel? speciality;
  FilterBySpecialityEvent(this.speciality);
}

class FilterByAreaEvent extends ManagerUserEvent {
  final String? area;
  FilterByAreaEvent(this.area);
}

class FilterByUserTypeEvent extends ManagerUserEvent {
  final UserType userType;
  FilterByUserTypeEvent(this.userType);
}

class ResetUsersFiltersEvent extends ManagerUserEvent {}
class EditUserMEvent extends ManagerUserEvent {
  final UserModel user;
  EditUserMEvent(this.user);

  @override
  List<Object?> get props => [user];
}class InsertMEvent extends ManagerUserEvent {
  final UserModel doctorsModel;
   InsertMEvent(this.doctorsModel);

  @override
  List<Object?> get props => [doctorsModel];
}