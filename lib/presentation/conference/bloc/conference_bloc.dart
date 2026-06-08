import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/request.dart';
import 'package:formify/domain/usecase/add_spec_usecase.dart';
import 'package:formify/domain/usecase/create_conference_usecase.dart';
import 'package:formify/domain/usecase/delete_conference_usecase.dart';
import 'package:formify/domain/usecase/get_all_conference_usecase.dart';
import 'package:formify/domain/usecase/get_all_spec_usecase.dart';
import 'package:formify/domain/usecase/get_all_survey_and_active_usecase.dart';
import 'package:formify/domain/usecase/get_all_survey_usecase.dart';
import 'package:formify/domain/usecase/get_conference_by_id_usecase.dart';
import 'package:formify/domain/usecase/link_survey_conference_usecase.dart';
import 'package:formify/domain/usecase/update_conference_usecase.dart';
import 'package:meta/meta.dart';

part 'conference_event.dart';
part 'conference_state.dart';

class ConferenceBloc extends Bloc<ConferenceEvent, ConferenceState> {
  // --- تعريف الـ UseCases (حقن التبعيات) ---
  final CreateConferenceUsecase createConferenceUsecase;
  final GetAllSurveyUsecase getAllSurveyUsecase;
  final GetAllConferenceUsecase getAllConferenceUsecase;
  final LinkSurveyConferenceUsecase linkSurveyConferenceUsecase;
  final DeleteConferenceUsecase deleteConferenceUsecase;
  final GetConferenceByIdUsecase getConferenceByIdUsecase;
  final GetAllSurveyAndActiveUsecase getAllSurveyAndActiveUsecase;
  final UpdateConferenceUsecase updateConferenceUsecase;
  final GetAllSpecUsecase getAllSpecUsecase;
  final AddSpecUsecase createSpecUsecase;

  // --- تخزين البيانات المؤقتة (State Variables) ---
  List<GetAllConferenceModel> allNotActiveConference = [];
  List<IsActiveMainSurveyModel> surveys = [];
  List<SpecModel> _localSelectedSpecs = [];
  int? selectConferenceId;
  int conferenceId = 0;

  ConferenceBloc(
      this.createConferenceUsecase,
      this.getAllSurveyUsecase,
      this.getAllConferenceUsecase,
      this.linkSurveyConferenceUsecase,
      this.deleteConferenceUsecase,
      this.getConferenceByIdUsecase,
      this.getAllSurveyAndActiveUsecase,
      this.updateConferenceUsecase,
      this.getAllSpecUsecase,
      this.createSpecUsecase,
      ) : super(ConferenceInitial()) {

    // --- تسجيل معالجات الأحداث (Event Registration) ---
    on<AddSpecialtyToLocalListEvent>(_onAddSpecialtyToLocal);
    on<RemoveSpecialtyFromLocalListEvent>(_onRemoveSpecialtyFromLocal);
    on<CreateConferenceEvent>(_onCreateConference);
    on<GetAllSurveyByConferenceEvent>(_onGetAllSurveyByConference);
    on<GetConferenceByIdEvent>(_onGetConferenceById);
    on<UpdateInfoConferenceEvent>(_onUpdateInfoConference);
    on<GetAllNotActiveConferenceEvent>(_onGetAllNotActiveConference);
    on<DeleteConferenceEvent>(_onDeleteConference);
    on<GetAllSpecEvent>(_onGetAllSpec);
    on<LinkSurveyConferenceEvent>(_onLinkSurveyConference);
    on<SelectEndedConferenceEvent>(_onSelectEndedConference);
    on<UpdateConferenceEvent>(_onUpdateConferenceUI);
    on<CreateSpecEvent>(_onCreateSpecification);
  }

  // --- دوال معالجة الأحداث (Handlers) ---

  // 1. إدارة قائمة الاختصاصات محلياً
  void _onAddSpecialtyToLocal(AddSpecialtyToLocalListEvent event, Emitter<ConferenceState> emit) {
    if (!_localSelectedSpecs.any((s) => s.id == event.specialty.id)) {
      _localSelectedSpecs.add(event.specialty);
    }
    emit(SelectedSpecialtiesUpdatedState(List.from(_localSelectedSpecs)));
  }

  void _onRemoveSpecialtyFromLocal(RemoveSpecialtyFromLocalListEvent event, Emitter<ConferenceState> emit) {
    _localSelectedSpecs.removeWhere((s) => s.id == event.specialtyId);
    emit(SelectedSpecialtiesUpdatedState(List.from(_localSelectedSpecs)));
  }

  // 2. العمليات المرتبطة بالسيرفر
  Future<void> _onCreateConference(CreateConferenceEvent event, Emitter<ConferenceState> emit) async {
    emit(CreateConferenceLoadingState());
    // استخراج الـ IDs من القائمة المحلية وتمريرها للـ Payload
    event.payload.specification_ids = _localSelectedSpecs.map((spec) => spec.id??0).toList();

    final result = await createConferenceUsecase.execute(event.payload);
    result.fold(
          (failure) => emit(CreateConferenceErrorState(failure: failure)),
          (data) {
        conferenceId = data;
        _localSelectedSpecs = []; // تنظيف القائمة بعد النجاح
        emit(CreateConferenceState(conferenceId));
      },
    );
  }

  Future<void> _onGetAllSurveyByConference(GetAllSurveyByConferenceEvent event, Emitter<ConferenceState> emit) async {
    emit(GetAllSurveyConferenceLoadingState());
    final result = event.conferenceId == -1
        ? await getAllSurveyUsecase.execute()
        : await getAllSurveyAndActiveUsecase.execute(event.conferenceId);

    result.fold(
          (failure) => emit(GetAllSurveyConferenceErrorState(failure: failure)),
          (data) {
        if (event.conferenceId == -1) {
          surveys = (data as List).map((e) => e.toDomain()).cast<IsActiveMainSurveyModel>().toList();
        } else {
          surveys = data as List<IsActiveMainSurveyModel>;
        }
        surveys.isEmpty ? emit(GetAllSurveyConferenceEmptyState()) : emit(GetAllSurveyConferenceState(surveys));
      },
    );
  }

  Future<void> _onGetConferenceById(GetConferenceByIdEvent event, Emitter<ConferenceState> emit) async {
    emit(GetConferenceByIdLoadingState());
    (await getConferenceByIdUsecase.execute(event.conferenceId)).fold(
          (failure) => emit(GetConferenceByIdErrorState(failure: failure)),
          (data) {
        data.surveys.sort((a, b) => a.survey_order.compareTo(b.survey_order)); // ترتيب البيانات
        emit(GetConferenceByIdState(data));
      },
    );
  }

  Future<void> _onUpdateInfoConference(UpdateInfoConferenceEvent event, Emitter<ConferenceState> emit) async {
    emit(UpdateConferenceLoadingState());
    (await updateConferenceUsecase.execute(
      event.conferenceModel.id,
      ConferenceModel(
        event.conferenceModel.name,
        event.conferenceModel.description,
        event.conferenceModel.address,
        event.conferenceModel.startDate,
        event.conferenceModel.endDate,
        0,
      ),
    )).fold(
          (failure) => emit(UpdateConferenceErrorState(failure: failure)),
          (data) => emit(UpdateConferenceState()),
    );
  }

  Future<void> _onGetAllNotActiveConference(GetAllNotActiveConferenceEvent event, Emitter<ConferenceState> emit) async {
    emit(GetAllConferenceLoadingState());
    (await getAllConferenceUsecase.execute(0)).fold(
          (failure) => emit(GetAllConferenceErrorState(failure: failure)),
          (data) {
        allNotActiveConference = data;
        allNotActiveConference.isEmpty ? emit(GetAllEmptyConferenceState()) : emit(GetAllConferenceState(data, 0));
      },
    );
  }

  Future<void> _onDeleteConference(DeleteConferenceEvent event, Emitter<ConferenceState> emit) async {
    emit(DeleteConferenceLoadingState());
    (await deleteConferenceUsecase.execute(event.id)).fold(
          (failure) => emit(DeleteConferenceErrorState(failure: failure)),
          (data) {
        allNotActiveConference.removeAt(event.index);
        emit(GetAllConferenceState(List.from(allNotActiveConference), 0));
      },
    );
  }

  Future<void> _onLinkSurveyConference(LinkSurveyConferenceEvent event, Emitter<ConferenceState> emit) async {
    emit(LinkSurveyConferenceLoadingState(event.index));
    (await linkSurveyConferenceUsecase.execute(
      SurveyConference(event.surveyId, event.conferenceId, 1, !event.surveys[event.index].isActive),
    )).fold(
          (failure) => emit(LinkSurveyConferenceErrorState(failure: failure)),
          (data) {
        event.surveys[event.index].isActive = !event.surveys[event.index].isActive;
        emit(GetAllSurveyConferenceState(List.from(event.surveys)));
      },
    );
  }

  Future<void> _onGetAllSpec(GetAllSpecEvent event, Emitter<ConferenceState> emit) async {
    emit(GetAllSpecLoadingState());
    (await getAllSpecUsecase.execute()).fold(
          (failure) => emit(GetAllSpecErrorState(failure: failure)),
          (data) => emit(GetAllSpecState(data)),
    );
  }

  Future<void> _onCreateSpecification(CreateSpecEvent event, Emitter<ConferenceState> emit) async {
    emit(GetAllSpecLoadingState());
    (await createSpecUsecase.execute(event.name)).fold(
          (failure) => emit(GetAllSpecErrorState(failure: failure)),
          (data) {
        List<SpecModel> copy = List.from(event.spec)..add(data);
        emit(GetAllSpecState(copy));
      },
    );
  }

  void _onSelectEndedConference(SelectEndedConferenceEvent event, Emitter<ConferenceState> emit) {
    selectConferenceId = event.index;
    emit(SelectEndedConferenceState(selectConferenceId));
  }

  void _onUpdateConferenceUI(UpdateConferenceEvent event, Emitter<ConferenceState> emit) {
    emit(GetAllConferenceState(List.from(allNotActiveConference), event.refreshId));
  }
}