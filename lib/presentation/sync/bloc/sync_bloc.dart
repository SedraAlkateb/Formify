import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/domain/usecase/add_async_data_sql_usecase.dart';
import 'package:formify/domain/usecase/get_all_async_info_usecase.dart';
import 'package:meta/meta.dart';

part 'sync_event.dart';
part 'sync_state.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  GetAllAsyncInfoUsecase getAllAsyncInfoUsecase;
  AddAsyncDataSqlUsecase addAsyncDataSqlUsecase;
  SyncBloc(
      this.getAllAsyncInfoUsecase,
      this.addAsyncDataSqlUsecase
      ) : super(SyncInitial()) {
    on<SyncEvent>((event, emit) {

    });
  }
}
