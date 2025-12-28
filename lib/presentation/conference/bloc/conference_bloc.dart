import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/usecase/create_conference_usecase.dart';
import 'package:formify/domain/usecase/get_all_conference_usecase.dart';
import 'package:formify/domain/usecase/get_all_survey_usecase.dart';
import 'package:meta/meta.dart';

part 'conference_event.dart';
part 'conference_state.dart';

class ConferenceBloc extends Bloc<ConferenceEvent, ConferenceState> {
  CreateConferenceUsecase createConferenceUsecase;
  GetAllSurveyUsecase getAllSurveyUsecase;
  GetAllConferenceUsecase getAllConferenceUsecase;
  List<GetAllConferenceModel> allActiveConference=[];
  List<GetAllConferenceModel> allNotActiveConference=[];

  ConferenceBloc(
    this.createConferenceUsecase,
    this.getAllSurveyUsecase,
    this.getAllConferenceUsecase,
  ) : super(ConferenceInitial()) {
    on<ConferenceEvent>((event, emit) async {
      if (event is CreateConferenceEvent) {
        emit(CreateConferenceLoadingState());
        (await createConferenceUsecase.execute(event.payload)).fold(
          (failure) {
            emit(CreateConferenceErrorState(failure: failure));
          },
          (data) async {
            emit(CreateConferenceState());
          },
        );
      }
      if (event is GetAllSurveyEvent) {
        emit(GetAllSurveyLoadingState());
        (await getAllSurveyUsecase.execute()).fold(
          (failure) {
            emit(GetAllSurveyErrorState(failure: failure));
          },
          (data) async {
            emit(GetAllSurveyState(data));
          },
        );
      }

      /////////////// Active in AllConferencePage = 0 Not Active in home = 1
      if (event is GetAllActiveConferenceEvent) {
        emit(GetAllConferenceLoadingState());
        (await getAllConferenceUsecase.execute(0)).fold(
              (failure) {
            emit(GetAllConferenceErrorState(failure: failure));
          },
              (data) async {
                allActiveConference=data;
            emit(GetAllConferenceState(data));
          },
        );
      }

      if (event is GetAllNotActiveConferenceEvent) {
        emit(GetAllConferenceLoadingState());
        (await getAllConferenceUsecase.execute(1)).fold(
              (failure) {
            emit(GetAllConferenceErrorState(failure: failure));
          },
              (data) async {
                allNotActiveConference=data;
            emit(GetAllConferenceState(data));
          },
        );
      }
    });
  }
}
