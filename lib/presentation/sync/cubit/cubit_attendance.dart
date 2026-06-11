import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/sync/cubit/cubit_attendance_state.dart';


class DoctorFilterCubit extends Cubit<DoctorFilterState> {
  DoctorFilterCubit() : super( DoctorFilterState(conference: GetAllConferenceModel.create(),));

  void setDoctors(List<UserDoneModel> doctors) {
    emit(
      state.copyWith(
        allDoctors: doctors,
        filteredDoctors: _applyFilter(
          doctors,
          state.searchText,
          state.selectedFilter,
            state.selectedSpecId
        ),
      ),
    );
  }

  void search(String value) {
    emit(
      state.copyWith(
        searchText: value,
        filteredDoctors: _applyFilter(
          state.allDoctors,
          value,
          state.selectedFilter,
            state.selectedSpecId
        ),
      ),
    );
  }

  void changeFilter(DoctorFilterStatus filter) {
    emit(
      state.copyWith(
        selectedFilter: filter,
        filteredDoctors: _applyFilter(
          state.allDoctors,
          state.searchText,
          filter,
            state.selectedSpecId
        ),
      ),
    );
  }

  void toggleDoctor(UserDoneModel doctor, bool value) {
    final updatedDoctors = state.allDoctors.map((item) {
      if (item.userModel.id == doctor.userModel.id) {
        item.isDone = value ? 1 : 0;
      }
      return item;
    }).toList();

    emit(
      state.copyWith(
        allDoctors: updatedDoctors,
        filteredDoctors: _applyFilter(
          updatedDoctors,
          state.searchText,
          state.selectedFilter,
          state.selectedSpecId
        ),
      ),
    );
  }

  List<UserDoneModel> _applyFilter(
      List<UserDoneModel> doctors,
      String searchText,
      DoctorFilterStatus filter,
      int? specId,
      ) {
    print(specId);
    final query = searchText.trim().toLowerCase();

    return doctors.where((doctor) {
      final matchesSearch =
      doctor.userModel.fullName.toLowerCase().contains(query);

      final matchesFilter = switch (filter) {
        DoctorFilterStatus.all => true,
        DoctorFilterStatus.notAttended => doctor.isDone == 0,
        DoctorFilterStatus.attended => doctor.isDone == 1,
      };

      // ⚡ تعديل هنا ليشمل "الكل" بشكل صحيح
      final matchesSpec = specId == -1
          ? true // إذا اخترت "الكل" نعرض جميع الأطباء
          : (doctor.userModel.spec?.id ?? 0) == specId; // وإذا لديهم spec مطابق

      return matchesSearch && matchesFilter && matchesSpec;
    }).toList();
  }
  void changeSpecFilter(int? specId) {
    emit(
      state.copyWith(
        selectedSpecId: specId,

        filteredDoctors: _applyFilter(
          state.allDoctors,
          state.searchText,
          state.selectedFilter,
          specId,

        ),
      ),
    );
  }
  void setConferenceSpecs(GetAllConferenceModel conference) {
    emit(
      state.copyWith(conference: conference),
    );
  }
}