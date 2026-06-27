import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/usecase/add_spec_usecase.dart';
import 'package:formify/domain/usecase/get_all_spec_usecase.dart';
import 'package:meta/meta.dart';

part 'spec_manager_event.dart';
part 'spec_manager_state.dart';

class SpecManagerBloc extends Bloc<SpecManagerEvent, SpecManagerState> {
  final GetAllSpecUsecase getAllSpecUsecase;
  final AddSpecUsecase createSpecUsecase;

  SpecManagerBloc(
      this.getAllSpecUsecase,this.createSpecUsecase
      ) : super(SpecManagerInitial()) {
    on<GetAllSpecsEvent>(_getAllSpecs);
    on<CreateSpecEvent>(_onCreateSpecification);

  }

  Future<void> _getAllSpecs(
      GetAllSpecsEvent event,
      Emitter<SpecManagerState> emit,
      ) async {
    emit(GetAllSpecLoadingState());

    final result = await getAllSpecUsecase.execute();

    result.fold((failure) => emit(GetAllSpecErrorState(failure: failure)), (
        data,
        ) {
      if (data.isNotEmpty) {
        emit(GetAllSpecState.fromPageData(data));
      } else {
        emit(GetAllSpecEmptyState());
      }
    });
  }
  Future<void> _onCreateSpecification(CreateSpecEvent event, Emitter<SpecManagerState> emit) async {
    emit(GetAllSpecLoadingState());
    (await createSpecUsecase.execute(event.name)).fold(
          (failure) => emit(GetAllSpecErrorState(failure: failure)),
          (data) {
        List<SpecModel> copy = List.from(event.spec)..add(data);
        emit(GetAllSpecState(allSpec: copy));
      },
    );
  }
}

