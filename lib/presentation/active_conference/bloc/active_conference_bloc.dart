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

class ActiveConferenceBloc
    extends Bloc<ActiveConferenceEvent, ActiveConferenceState> {
  List<GetAllConferenceModel> allActiveConference = [];
  GetAllConferenceUsecase getAllConferenceUsecase;
  GetConferenceByIdUsecase getConferenceByIdUsecase;
  GetAllUserUsecase getAllUserUsecase;
  ///GetAllConferenceUsecase if di
  ActiveConferenceBloc(this.getAllConferenceUsecase,this.getConferenceByIdUsecase,this.getAllUserUsecase)
    : super(ActiveConferenceInitial()) {
    on<ActiveConferenceEvent>((event, emit) async {
      /////////////// Active in AllConferencePage = 0 Not Active in home = 1
      if (event is GetAllActiveConferenceEvent) {
        emit(GetAllActiveConferenceLoadingState());
        (await getAllConferenceUsecase.execute(1)).fold(
          (failure) {
            emit(GetAllActiveConferenceErrorState(failure: failure));
          },
          (data) async {
            allActiveConference = data;
            if (allActiveConference.isEmpty) {
              emit(GetAllActiveEmptyConferenceState());
            }
            emit(GetAllActiveConferenceState(data));
          },
        );
      }
      if (event is GetActiveConferenceByIdEvent) {
        emit(GetActiveConferenceByIdLoadingState());
        (await getConferenceByIdUsecase.execute(event.conferenceModel)).fold(
              (failure) {
            emit(GetActiveConferenceByIdErrorState(failure: failure));
          },
              (data) async {
            data.surveys.sort(
                  (a, b) => a.survey_order.compareTo(b.survey_order),
            );
            emit(GetActiveConferenceByIdState(data));
          },
        );
      }
      /*


  if (event is GetAllSurveyByConferenceEvent) {
        emit(GetAllSurveyLoadingState());
        event.conferenceId==-1?
        (await getAllSurveyUsecase.execute()).fold(
          (failure) {
            emit(GetAllSurveyErrorState(failure: failure));
          },
          (data) async {
            emit(GetAllSurveyState(data.toDomain()));
          },
        ): (await getAllSurveyAndActiveUsecase.execute(event.conferenceId)).fold(
              (failure) {
            emit(GetAllSurveyErrorState(failure: failure));
          },
              (data) async {
            emit(GetAllSurveyState(data));
          },
        );
      }
       */
    });
  }
}
