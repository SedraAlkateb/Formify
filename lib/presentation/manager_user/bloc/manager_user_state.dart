part of 'manager_user_bloc.dart';

@immutable
sealed class ManagerUserState extends Equatable {}

final class ManagerUserInitial extends ManagerUserState {
  @override
  List<Object?> get props => [];
}

// final class GetAllUsersState extends ManagerUserState {
//   final List<UserModel> users;
//    GetAllUsersState(this.users);
//
//   @override
//   List<Object?> get props => [users];
// }
final class GetAllUsersLoadingState extends ManagerUserState {
  @override
  List<Object?> get props => [];
}

final class GetAllUsersEmptyState extends ManagerUserState {
  @override
  List<Object?> get props => [];
}

final class GetAllUsersErrorState extends ManagerUserState {
  final Failure failure;
  GetAllUsersErrorState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class GetAllUsersState extends ManagerUserState {
  final List<UserModel> allUsers;
  final List<UserModel> filteredUsers;
  final List<SpecModel> specialities;
  final List<String> areas;

  final String searchText;
  final SpecModel? selectedSpeciality;
  final String? selectedArea;
  final UserType selectedUserType;

  GetAllUsersState({
    required this.allUsers,
    required this.filteredUsers,
    required this.specialities,
    required this.areas,
    this.searchText = '',
    this.selectedSpeciality,
    this.selectedArea,
    this.selectedUserType = UserType.all,
  });

  factory GetAllUsersState.fromPageData(ManagerUsersPageDataModel data) {
    return GetAllUsersState(
      allUsers: data.users,
      filteredUsers: data.users,
      specialities: data.specialities,
      areas: data.areas,
    );
  }

  GetAllUsersState copyWith({
    List<UserModel>? allUsers,
    List<UserModel>? filteredUsers,
    List<SpecModel>? specialities,
    List<String>? areas,
    String? searchText,
    SpecModel? selectedSpeciality,
    String? selectedArea,
    UserType? selectedUserType,
    bool clearSpeciality = false,
    bool clearArea = false,
  }) {
    return GetAllUsersState(
      allUsers: allUsers ?? this.allUsers,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      specialities: specialities ?? this.specialities,
      areas: areas ?? this.areas,
      searchText: searchText ?? this.searchText,
      selectedSpeciality:
      clearSpeciality ? null : selectedSpeciality ?? this.selectedSpeciality,
      selectedArea: clearArea ? null : selectedArea ?? this.selectedArea,
      selectedUserType: selectedUserType ?? this.selectedUserType,
    );
  }

  @override
  List<Object?> get props => [
    allUsers,
    filteredUsers,
    specialities,
    areas,
    searchText,
    selectedSpeciality,
    selectedArea,
    selectedUserType,
  ];
}
final class EditUserMState extends ManagerUserState {
   EditUserMState();

  @override
  List<Object?> get props => [];
}
final class EditUserMErrorState extends ManagerUserState {
  final Failure failure;
   EditUserMErrorState({required this.failure});

  @override
  List<Object?> get props => [failure];
}


final class InsertDoctorMErrorState extends ManagerUserState {
  final Failure failure;
   InsertDoctorMErrorState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

final class InsertDoctorMSucState extends ManagerUserState {
   InsertDoctorMSucState();

  @override
  List<Object?> get props => [];
}

final class InsertDoctorMLoadingState extends ManagerUserState {
   InsertDoctorMLoadingState();

  @override
  List<Object?> get props => [];
}

