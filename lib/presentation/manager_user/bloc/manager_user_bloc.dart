import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/user_type.dart';
import 'package:formify/domain/usecase/get_all_users_specs_sql_for_all_conferences_usecase.dart';
import 'package:formify/domain/usecase/insert_doctor_sql_usecase.dart';
import 'package:formify/domain/usecase/update_user_sql_usecase.dart';
import 'package:meta/meta.dart';

part 'manager_user_event.dart';
part 'manager_user_state.dart';

class ManagerUserBloc extends Bloc<ManagerUserEvent, ManagerUserState> {
  final GetAllUsersSpecsSqlForAllConferencesUsecase
  allUsersSpecsSqlForAllConferencesUsecase;
  final UpdateUserSqlUsecase updateUserSqlUsecase;
  final InsertDoctorSqlUsecase insertDoctorSqlUsecase;

  ManagerUserBloc(
    this.allUsersSpecsSqlForAllConferencesUsecase,
    this.updateUserSqlUsecase,
      this.insertDoctorSqlUsecase
  ) : super(ManagerUserInitial()) {
    on<GetAllUsersEvent>(_getAllUser);
    on<SearchUsersEvent>(_searchUsers);
    on<FilterBySpecialityEvent>(_filterBySpeciality);
    on<FilterByAreaEvent>(_filterByArea);
    on<FilterByUserTypeEvent>(_filterByUserType);
    on<ResetUsersFiltersEvent>(_resetFilters);
    on<EditUserMEvent>(_onEditUser);
    on<InsertMEvent>(_onInsertDoctors);

  }

  Future<void> _onInsertDoctors(
      InsertMEvent event,
      Emitter<ManagerUserState> emit,
      ) async {
    if (state is! GetAllUsersState) return;

    final currentState = state as GetAllUsersState;

    // 1. Loading
    emit(InsertDoctorMLoadingState());

    // 2. DB insert
    final result =
    await insertDoctorSqlUsecase.execute(event.doctorsModel);

    result.fold(
          (failure) => emit(InsertDoctorMErrorState(failure: failure)),
          (data) {
        // 3. تحديث allUsers (source of truth)
        final updatedAllUsers = [
          ...currentState.allUsers,
          event.doctorsModel,
        ];

        // 4. إعادة تطبيق الفلترة
        final updatedFiltered = _applyFilters(
          currentState.copyWith(allUsers: updatedAllUsers),
        );

        // 5. Emit state جديد
        emit(currentState.copyWith(
          allUsers: updatedAllUsers,
          filteredUsers: updatedFiltered,
        ));
      },
    );
  }
  Future<void> _getAllUser(
    GetAllUsersEvent event,
    Emitter<ManagerUserState> emit,
  ) async {
    emit(GetAllUsersLoadingState());

    final result = await allUsersSpecsSqlForAllConferencesUsecase.execute();

    result.fold((failure) => emit(GetAllUsersErrorState(failure: failure)), (
      data,
    ) {
      if (data.users.isNotEmpty) {
        emit(GetAllUsersState.fromPageData(data));
      } else {
        emit(GetAllUsersEmptyState());
      }
    });
  }

  Future<void> _onEditUser(
    EditUserMEvent event,
    Emitter<ManagerUserState> emit,
  ) async {
    if (state is! GetAllUsersState) return;

    final currentState = state as GetAllUsersState;

    // 1. تحديث قاعدة البيانات
    final result = await updateUserSqlUsecase.execute(event.user);

    await result.fold(
      (failure) async {
        emit(EditUserMErrorState(failure: failure));
      },
      (success) async {
        List<UserModel> updatedAllUsers = List.from(currentState.allUsers);

        final index = updatedAllUsers.indexWhere((u) => u.id == event.user.id);

        if (index != -1) {
          updatedAllUsers[index] = event.user;
        }
        // final updatedAllUsers = currentState.allUsers.map((user) {
        //   return user.id == event.user.id ? event.user : user;
        // }).toList();

        // 3. إنشاء state جديد مع البيانات المحدثة
        final newState = currentState.copyWith(allUsers: updatedAllUsers);

        // 4. إعادة تطبيق الفلاتر على البيانات الجديدة
        final updatedFiltered = _applyFilters(newState);

        // 5. emit النهائي
        emit(newState.copyWith(filteredUsers: updatedFiltered));
      },
    );
  }

  void _searchUsers(SearchUsersEvent event, Emitter<ManagerUserState> emit) {
    if (state is! GetAllUsersState) return;

    final currentState = state as GetAllUsersState;

    final newState = currentState.copyWith(searchText: event.searchText);

    emit(newState.copyWith(filteredUsers: _applyFilters(newState)));
  }

  void _filterBySpeciality(
    FilterBySpecialityEvent event,
    Emitter<ManagerUserState> emit,
  ) {
    if (state is! GetAllUsersState) return;

    final currentState = state as GetAllUsersState;

    final newState = currentState.copyWith(
      selectedSpeciality: event.speciality,
      clearSpeciality: event.speciality == null,
    );

    emit(newState.copyWith(filteredUsers: _applyFilters(newState)));
  }

  void _filterByArea(FilterByAreaEvent event, Emitter<ManagerUserState> emit) {
    if (state is! GetAllUsersState) return;

    final currentState = state as GetAllUsersState;

    final newState = currentState.copyWith(
      selectedArea: event.area,
      clearArea: event.area == null,
    );

    emit(newState.copyWith(filteredUsers: _applyFilters(newState)));
  }

  void _filterByUserType(
    FilterByUserTypeEvent event,
    Emitter<ManagerUserState> emit,
  ) {
    if (state is! GetAllUsersState) return;

    final currentState = state as GetAllUsersState;

    final newState = currentState.copyWith(selectedUserType: event.userType);

    emit(newState.copyWith(filteredUsers: _applyFilters(newState)));
  }

  void _resetFilters(
    ResetUsersFiltersEvent event,
    Emitter<ManagerUserState> emit,
  ) {
    if (state is! GetAllUsersState) return;

    final currentState = state as GetAllUsersState;

    emit(
      currentState.copyWith(
        filteredUsers: currentState.allUsers,
        searchText: '',
        clearSpeciality: true,
        clearArea: true,
        selectedUserType: UserType.all,
      ),
    );
  }
}

List<UserModel> _applyFilters(GetAllUsersState state) {
  var result = state.allUsers;

  if (state.searchText.trim().isNotEmpty) {
    final query = state.searchText.trim().toLowerCase();

    result = result.where((user) {
      return user.fullName.toLowerCase().contains(query) ||
          user.phone.toLowerCase().contains(query) ||
          user.id.toString().contains(query);
    }).toList();
  }

  if (state.selectedSpeciality != null) {
    result = result.where((user) {
      return user.spec?.id == state.selectedSpeciality!.id;
    }).toList();
  }

  if (state.selectedArea != null && state.selectedArea!.trim().isNotEmpty) {
    result = result.where((user) {
      return user.address?.trim() == state.selectedArea!.trim();
    }).toList();
  }

  if (state.selectedUserType != UserType.all) {
    result = result.where((user) {
      return user.userType.id == state.selectedUserType.id;
    }).toList();
  }

  return result;
}
