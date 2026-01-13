import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/domain/usecase/get_all_async_info_usecase.dart';
import 'package:meta/meta.dart';

part 'sync_event.dart';
part 'sync_state.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  GetAllAsyncInfoUsecase getAllAsyncInfoUsecase;
  SyncBloc(
      this.getAllAsyncInfoUsecase
      ) : super(SyncInitial()) {
    on<SyncEvent>((event, emit) {

    });
  }
}
