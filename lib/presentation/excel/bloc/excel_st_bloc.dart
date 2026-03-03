import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/usecase/statistics_for_users_answers_usecase.dart';
import 'package:meta/meta.dart';

part 'excel_st_event.dart';
part 'excel_st_state.dart';

class ExcelStBloc extends Bloc<ExcelStEvent, ExcelStState> {
  final StatisticsForUsersAnswersUsecase statisticsForUsersAnswersUsecase;

  ExcelStBloc(this.statisticsForUsersAnswersUsecase) : super(ExcelStInitial()) {
    on<UsersAnswersStatisticsEvent>(_onFetch);
  }
  Future<void> _onFetch(
      UsersAnswersStatisticsEvent event,
      Emitter<ExcelStState> emit,
      ) async {
    emit(ExelLoading());
    final result = await statisticsForUsersAnswersUsecase.execute(
      event.surveyId,
    );
    result.fold(
          (failure) {
        emit(
          ExelError(
            failure: failure
          ),
        );
      },
          (data) {
          emit(ExelSuccess(data));
      },
    );
  }
  }

