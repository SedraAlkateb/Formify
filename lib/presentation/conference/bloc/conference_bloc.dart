import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/mapper/mapper.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/request.dart';
import 'package:formify/domain/usecase/create_conference_usecase.dart';
import 'package:formify/domain/usecase/delete_conference_usecase.dart';
import 'package:formify/domain/usecase/get_all_conference_usecase.dart';
import 'package:formify/domain/usecase/get_all_survey_and_active_usecase.dart';
import 'package:formify/domain/usecase/get_all_survey_usecase.dart';
import 'package:formify/domain/usecase/get_conference_by_id_usecase.dart';
import 'package:formify/domain/usecase/link_survey_conference_usecase.dart';
import 'package:meta/meta.dart';

part 'conference_event.dart';
part 'conference_state.dart';

class ConferenceBloc extends Bloc<ConferenceEvent, ConferenceState> {
  CreateConferenceUsecase createConferenceUsecase;
  GetAllSurveyUsecase getAllSurveyUsecase;
  GetAllConferenceUsecase getAllConferenceUsecase;
  LinkSurveyConferenceUsecase linkSurveyConferenceUsecase;
  DeleteConferenceUsecase deleteConferenceUsecase;
  GetAllSurveyAndActiveUsecase getAllSurveyAndActiveUsecase;
  GetConferenceByIdUsecase getConferenceByIdUsecase;
  List<GetAllConferenceModel> allActiveConference = [];
  List<GetAllConferenceModel> allNotActiveConference = [];
  int conferenceId = 0;
  ConferenceBloc(
    this.createConferenceUsecase,
    this.getAllSurveyUsecase,
    this.getAllConferenceUsecase,
    this.linkSurveyConferenceUsecase,
    this.deleteConferenceUsecase,
    this.getConferenceByIdUsecase,
      this.getAllSurveyAndActiveUsecase
  ) : super(ConferenceInitial()) {
    on<ConferenceEvent>((event, emit) async {
      if (event is CreateConferenceEvent) {
        emit(CreateConferenceLoadingState());
        (await createConferenceUsecase.execute(event.payload)).fold(
          (failure) {
            emit(CreateConferenceErrorState(failure: failure));
          },
          (data) async {
            conferenceId = data;

            emit(CreateConferenceState());
          },
        );
      }
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
      if (event is LinkSurveyConferenceEvent) {
        emit(LinkSurveyConferenceLoadingState());
        (await linkSurveyConferenceUsecase.execute(
          SurveyConference(
            event.surveyId,
           event. conferenceId,
            1,
            !event.surveys[event.index].isActive,
          ),
        )).fold(
          (failure) {
            emit(LinkSurveyConferenceErrorState(failure: failure));
          },
          (data) async {
            event.surveys[event.index].isActive =
                !event.surveys[event.index].isActive;
            emit(GetAllSurveyState(event.surveys));
          },
        );
      }

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
      if (event is GetConferenceByIdEvent) {
        emit(GetConferenceByIdLoadingState());
        (await getConferenceByIdUsecase.execute(event.conferenceModel.id)).fold(
          (failure) {
            emit(GetConferenceByIdErrorState(failure: failure));
          },
          (data) async {
            data.surveys.sort(
              (a, b) => a.survey_order.compareTo(b.survey_order),
            );
            emit(GetConferenceByIdState(data));
          },
        );
      }

      if (event is GetAllNotActiveConferenceEvent) {
        emit(GetAllConferenceLoadingState());
        (await getAllConferenceUsecase.execute(0)).fold(
          (failure) {
            emit(GetAllConferenceErrorState(failure: failure));
          },
          (data) async {
            allNotActiveConference = data;
            if (allNotActiveConference.isEmpty) {
              emit(GetAllEmptyConferenceState());
            } else {
              emit(GetAllConferenceState(data));
            }
          },
        );
      }
      if (event is DeleteConferenceEvent) {
        emit(DeleteConferenceLoadingState());
        (await deleteConferenceUsecase.execute(event.id)).fold(
          (failure) {
            emit(DeleteConferenceErrorState(failure: failure));
          },
          (data) async {
            allNotActiveConference.removeAt(event.index);
            emit(GetAllConferenceState(allNotActiveConference));
          },
        );
      }
    });
  }
}
