part of 'spec_manager_bloc.dart';

@immutable
sealed class SpecManagerState {}

final class SpecManagerInitial extends SpecManagerState {}

final class GetAllSpecLoadingState extends SpecManagerState {
  @override
  List<Object?> get props => [];
}

final class GetAllSpecEmptyState extends SpecManagerState {
  @override
  List<Object?> get props => [];
}

final class GetAllSpecErrorState extends SpecManagerState {
  final Failure failure;
  GetAllSpecErrorState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class GetAllSpecState extends SpecManagerState {
  final List<SpecModel> allSpec;
  final String searchText;
  GetAllSpecState({
    required this.allSpec,
    this.searchText = '',
  });
  factory GetAllSpecState.fromPageData(List<SpecModel> data) {
    return GetAllSpecState(
        allSpec: data,
        searchText: ""
    );
  }
  GetAllSpecState copyWith({
    List<SpecModel>? allSpec,
    String? searchText,
  }) {
    return GetAllSpecState(
      allSpec: allSpec ?? this.allSpec,
      searchText: searchText ?? this.searchText,
    );
  }

  @override
  List<Object?> get props => [
    allSpec,
    searchText,
  ];
}
