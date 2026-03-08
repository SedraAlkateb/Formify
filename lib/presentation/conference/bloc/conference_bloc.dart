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
import 'package:formify/domain/usecase/update_conference_usecase.dart';
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
  UpdateConferenceUsecase updateConferenceUsecase;
  List<GetAllConferenceModel> allNotActiveConference = [];
  int? selectConferenceId;
  int conferenceId = 0;
  List<IsActiveMainSurveyModel> surveys = [];
  ConferenceBloc(
    this.createConferenceUsecase,
    this.getAllSurveyUsecase,
    this.getAllConferenceUsecase,
    this.linkSurveyConferenceUsecase,
    this.deleteConferenceUsecase,
    this.getConferenceByIdUsecase,
    this.getAllSurveyAndActiveUsecase,
    this.updateConferenceUsecase,
  ) : super(ConferenceInitial()) {
    on<ConferenceEvent>((event, emit) async {
      if (event is GetAllSurveyByConferenceEvent) {
        emit(GetAllSurveyConferenceLoadingState());
        event.conferenceId == -1
            ? (await getAllSurveyUsecase.execute()).fold(
                (failure) {
                  emit(GetAllSurveyConferenceErrorState(failure: failure));
                },
                (data) async {
                  surveys = data.toDomain();
                  if (surveys.isEmpty) {
                    emit(GetAllSurveyConferenceEmptyState());
                  } else {
                    emit(GetAllSurveyConferenceState(data.toDomain()));
                  }
                },
              )
            : (await getAllSurveyAndActiveUsecase.execute(
                event.conferenceId,
              )).fold(
                (failure) {
                  emit(GetAllSurveyConferenceErrorState(failure: failure));
                },
                (data) async {
                  surveys = data;
                  if (surveys.isEmpty) {
                    emit(GetAllSurveyConferenceEmptyState());
                  } else {
                    emit(GetAllSurveyConferenceState(data));
                  }
                },
              );
      }
      if (event is GetConferenceByIdEvent) {
        emit(GetConferenceByIdLoadingState());
        (await getConferenceByIdUsecase.execute(event.conferenceId)).fold(
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

      /////////////// Active in AllConferencePage = 0 Not Active in home = 1

      if (event is CreateConferenceEvent) {
        emit(CreateConferenceLoadingState());
        (await createConferenceUsecase.execute(event.payload)).fold(
          (failure) {
            emit(CreateConferenceErrorState(failure: failure));
          },
          (data) async {
            conferenceId = data;
            emit(CreateConferenceState(conferenceId));
          },
        );
      }
      if (event is UpdateInfoConferenceEvent) {
        emit(UpdateConferenceLoadingState());
        (await updateConferenceUsecase.execute(
          event.conferenceModel.id,
          ConferenceModel(
            event.conferenceModel.name,
            event.conferenceModel.description,
            event.conferenceModel.address,
            event.conferenceModel.startDate,
            event.conferenceModel.endDate,
            0),
        )).fold(
          (failure) {
            emit(UpdateConferenceErrorState(failure: failure));
          },
          (data) async {
            emit(UpdateConferenceState());
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
              emit(GetAllConferenceState(data, 0));
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
            emit(GetAllConferenceState(allNotActiveConference, 0));
          },
        );
      }
      if (event is LinkSurveyConferenceEvent) {
        emit(LinkSurveyConferenceLoadingState(event.index));
        (await linkSurveyConferenceUsecase.execute(
          SurveyConference(
            event.surveyId,
            event.conferenceId,
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
            emit(GetAllSurveyConferenceState(event.surveys));
          },
        );
      }
      if (event is SelectEndedConferenceEvent) {
        selectConferenceId = event.index;
        emit(SelectEndedConferenceState(selectConferenceId));
      } else if (event is UpdateConferenceEvent) {
        List<GetAllConferenceModel> copy = List<GetAllConferenceModel>.from(
          allNotActiveConference,
        );
        emit(GetAllConferenceState(copy, event.refreshId));
      }
    });
  }
}
