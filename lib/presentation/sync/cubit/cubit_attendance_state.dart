import 'package:equatable/equatable.dart';
import 'package:formify/domain/models/models.dart';

enum DoctorFilterStatus { all, notAttended, attended }

class DoctorFilterState extends Equatable{
  final List<UserDoneModel> allDoctors;
  final List<UserDoneModel> filteredDoctors;
  final String searchText;
  final DoctorFilterStatus selectedFilter;
  final int? selectedSpecId;
  final GetAllConferenceModel conference; // لن يكون nullable

  const DoctorFilterState({
    this.allDoctors = const [],
    this.filteredDoctors = const [],
    this.searchText = '',
    this.selectedFilter = DoctorFilterStatus.all,
    this.selectedSpecId=-1,
    required this.conference, // نجبر على تمرير قيمة عند الإنشاء
  });

  DoctorFilterState copyWith({
    List<UserDoneModel>? allDoctors,
    List<UserDoneModel>? filteredDoctors,
    String? searchText,
    DoctorFilterStatus? selectedFilter,
    int? selectedSpecId,
    GetAllConferenceModel? conference,
  }) {
    return DoctorFilterState(
      allDoctors: allDoctors ?? this.allDoctors,
      filteredDoctors: filteredDoctors ?? this.filteredDoctors,
      searchText: searchText ?? this.searchText,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      selectedSpecId: selectedSpecId ?? this.selectedSpecId,
      conference: conference ?? this.conference,
    );
  }

  @override
  List<Object?> get props => [
    allDoctors,
    filteredDoctors,
    searchText,
    selectedFilter,
    selectedSpecId,
    conference, // بمجرد تغير المؤتمر سيحدث التحديث فوراً
  ];
}