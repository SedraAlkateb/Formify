part of 'excel_st_bloc.dart';

@immutable
sealed class ExcelStState {}

final class ExcelStInitial extends ExcelStState {}
final class ExelLoading extends ExcelStState {}

final class ExelSuccess extends ExcelStState {
 final ExelModel exelModel;
  ExelSuccess(this.exelModel);
}

final class ExelError extends ExcelStState {
final Failure failure;
  ExelError({required this.failure});
}