import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/usecase/get_all_conference_usecase.dart';
import 'package:formify/domain/usecase/get_all_user_usecase.dart';
import 'package:formify/domain/usecase/get_conference_by_id_usecase.dart';
import 'package:meta/meta.dart';

part 'active_conference_event.dart';
part 'active_conference_state.dart';
class ActiveConferenceBloc extends Bloc<ActiveConferenceEvent, ActiveConferenceState> {
  GetAllConferenceUsecase getAllConferenceUsecase;
  GetConferenceByIdUsecase getConferenceByIdUsecase;
  GetAllUserUsecase getAllUserUsecase;

  ActiveConferenceBloc(
      this.getAllConferenceUsecase,
      this.getConferenceByIdUsecase,
      this.getAllUserUsecase,
      ) : super(ActiveConferenceInitial()) {
    on<GetAllActiveConferenceEvent>((event, emit) async {
      emit(GetAllActiveConferenceLoadingState());
      final result = await getAllConferenceUsecase.execute(1);
      result.fold(
            (failure) {
          emit(GetAllActiveConferenceErrorState(failure: failure));
        },
            (data) async {
          if (data.isEmpty) {
            emit(GetAllActiveEmptyConferenceState());
          } else {
            emit(GetAllActiveConferenceState(data));
          }
        },
      );
    });
    on<GetAllUserByActiveConferenceEvent>((event, emit) async {
      emit(GetAllUserActiveConferenceLoadingState());
      final result = await getAllUserUsecase.execute(event.conferenceId);
      result.fold(
            (failure) {
          emit(GetAllUserActiveConferenceErrorState(failure: failure));
        },
            (data) async {
              if(data.isEmpty){
                emit(GetAllUserActiveEmptyConferenceState());
              }else{
                emit(GetAllUserActiveConferenceState(data));
              }

        },
      );
    });

    on<GetActiveConferenceByIdEvent>((event, emit) async {
      emit(GetActiveConferenceByIdLoadingState());
      final result = await getConferenceByIdUsecase.execute(event.conferenceModel);
      result.fold(
            (failure) {
          emit(GetActiveConferenceByIdErrorState(failure: failure));
        },
            (data) async {
          data.surveys.sort((a, b) => a.survey_order.compareTo(b.survey_order));
          emit(GetActiveConferenceByIdState(data));
        },
      );
    });
  }
}

