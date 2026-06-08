import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/app/app_preferences.dart';
import 'package:formify/app/di.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/usecase/add_async_data_sql_usecase.dart';
import 'package:formify/domain/usecase/add_or_modify_users_usecase.dart';
import 'package:formify/domain/usecase/add_server_id_user_sql_usecase.dart';
import 'package:formify/domain/usecase/add_sync_data_sql_usecase.dart';
import 'package:formify/domain/usecase/check_password_usecase.dart';
import 'package:formify/domain/usecase/delete_data_sql_usecase.dart';
import 'package:formify/domain/usecase/delete_sync_data_sql_usecase.dart';
import 'package:formify/domain/usecase/get_all_async_info_usecase.dart';
import 'package:formify/domain/usecase/get_all_users_for_sync_usecase.dart';
import 'package:formify/domain/usecase/get_conference_and_answers_sql_usecase.dart';
import 'package:formify/domain/usecase/get_user_add_modify_sql_usecase.dart';
import 'package:formify/domain/usecase/updated_sync_users_answers_usecase.dart';
import 'package:meta/meta.dart';

part 'offline_sync_event.dart';
part 'offline_sync_state.dart';

class OfflineSyncBloc extends Bloc<OfflineSyncEvent, OfflineSyncState> {
  final GetAllAsyncInfoUsecase getAllAsyncInfoUsecase;
  final AddAsyncDataSqlUsecase addAsyncDataSqlUsecase;
  final UpdatedSyncUsersAnswersUsecase updatedSyncUsersAnswersUsecase;
  final GetAllUsersForSyncUsecase getAllUsersForSyncUsecase;
  final AddOrModifyUsersUsecase addOrModifyUsersUsecase;
  final GetUserAddModifySqlUsecase getUserAddModifySqlUsecase;
  final AddServerIdUserSqlUsecase addServerIdUserSqlUsecase;
  final GetConferenceAndAnswersSqlUsecase getConferenceAndAnswersSqlUsecase;
  final DeleteSyncDataSqlUsecase deleteSyncDataSqlUsecase;
  final AddSyncDataSqlUsecase addSyncDataSqlUsecase;
  final DeleteDataSqlUsecase deleteDataSqlUsecase;
  final CheckPasswordUsecase checkPasswordUsecase;

  int? conferenceId;
  int type = 0;

  ///0  save < 1 upload
  OfflineSyncBloc(
    this.deleteDataSqlUsecase,
    this.getAllAsyncInfoUsecase,
    this.addAsyncDataSqlUsecase,
    this.addOrModifyUsersUsecase,
    this.getAllUsersForSyncUsecase,
    this.updatedSyncUsersAnswersUsecase,
    this.getUserAddModifySqlUsecase,
    this.addServerIdUserSqlUsecase,
    this.getConferenceAndAnswersSqlUsecase,
    this.deleteSyncDataSqlUsecase,
    this.addSyncDataSqlUsecase,
    this.checkPasswordUsecase,
  ) : super(OfflineSyncInitial()) {
    on<AddAndModifyUserEvent>(_onAddAndModifyUser);
    on<UploadUserEvent>(_onUploadUser);
    on<UpdateUserIdEvent>(_updateIdUser);
    on<GetUserAnswerAndUserConferenceEvent>(_getConferenceAndAnswerUser);
    on<UploadUserAnswerAndUserConferenceEvent>(_uploadConferenceAndAnswerUser);
    on<DeleteSyncDataEvent>(_deleteSavaData);
    on<DeleteAllDataEvent>(_onDeleteData);
    on<CheckEvent>(_onCheck);
    on<GetSaveDataEvent>(_getSaveData);
    on<AddSaveDataEvent>(_addSaveData);
    on<AsyncDataEvent>(_onAsyncData);
    on<InsertDataSqlEvent>(_onInsertSql);
  }
  Future<void> _onAsyncData(
    AsyncDataEvent event,
    Emitter<OfflineSyncState> emit,
  ) async {
    emit(const DataOfflineLoadingState());
    (await getAllAsyncInfoUsecase.execute(event.conferenceId)).fold(
      (failure) => emit(DataOfflineErrorState(failure: failure)),
      (data) {
        conferenceId = event.conferenceId;
        emit(AsyncConferenceState(data));
      },
    );
  }

  Future<void> _onInsertSql(
    InsertDataSqlEvent event,
    Emitter<OfflineSyncState> emit,
  ) async {
    (await addAsyncDataSqlUsecase.execute(event.asyncModel)).fold(
      (failure) => emit(DataOfflineErrorState(failure: failure)),
      (_) => emit(InsertSucState(event.asyncModel.conferenceModel.id)),
    );
  }

  Future<void> _onAddAndModifyUser(
    AddAndModifyUserEvent event,
    Emitter<OfflineSyncState> emit,
  ) async {
    type = event.type;
    conferenceId = event.id;
    emit(SyncLoadingState());
    (await getUserAddModifySqlUsecase.execute()).fold(
      (failure) => emit(DataOfflineErrorState(failure: failure)),
      (data) {
        emit(AddAndModifyUserSucState(data));
      },
    );
  }

  Future<void> _onUploadUser(
    UploadUserEvent event,
    Emitter<OfflineSyncState> emit,
  ) async {
    (await addOrModifyUsersUsecase.execute(event.users)).fold(
      (failure) => emit(DataOfflineErrorState(failure: failure)),
      (data) {
        emit(UploadUserSucState(data));
      },
    );
  }

  Future<void> _updateIdUser(
    UpdateUserIdEvent event,
    Emitter<OfflineSyncState> emit,
  ) async {
    (await addServerIdUserSqlUsecase.execute(event.syncedUsers)).fold(
      (failure) => emit(DataOfflineErrorState(failure: failure)),
      (data) {
        emit(UpdateIdUserSucState());
      },
    );
  }

  Future<void> _getConferenceAndAnswerUser(
    GetUserAnswerAndUserConferenceEvent event,
    Emitter<OfflineSyncState> emit,
  ) async {
    (await getConferenceAndAnswersSqlUsecase.execute(conferenceId ?? 0)).fold(
      (failure) => emit(DataOfflineErrorState(failure: failure)),
      (data) {
        emit(GetUserAnswerAndUserConferenceState(data, type));
      },
    );
  }

  Future<void> _uploadConferenceAndAnswerUser(
    UploadUserAnswerAndUserConferenceEvent event,
    Emitter<OfflineSyncState> emit,
  ) async {

    (await updatedSyncUsersAnswersUsecase.execute(event.data)).fold(
      (failure) => emit(DataOfflineErrorState(failure: failure)),
      (data) {
        emit(UploadUserAnswerAndUserConferenceState(type));
      },
    );
  }

  Future<void> _onCheck(
    CheckEvent event,
    Emitter<OfflineSyncState> emit,
  ) async {
    final checkResult = await checkPasswordUsecase.execute(event.password);
    checkResult.fold((failure) => null, (isValid) async {
      if (!isValid) {
        await deleteDataSqlUsecase.execute();
        await instance<AppPreferences>().signOut();
        if (!emit.isDone) emit(CheckoutState());
      }
    });
  }

  //////TODO
  Future<void> _deleteSavaData(
    DeleteSyncDataEvent event,
    Emitter<OfflineSyncState> emit,
  ) async {
    (await deleteSyncDataSqlUsecase.execute()).fold(
      (failure) => emit(DataOfflineErrorState(failure: failure)),
      (data) {
        emit(DeleteSyncDataState());
      },
    );
  }

  Future<void> _onDeleteData(
    DeleteAllDataEvent event,
    Emitter<OfflineSyncState> emit,
  ) async {
    (await deleteDataSqlUsecase.execute()).fold(
      (failure) => emit(DataOfflineErrorState(failure: failure)),
      (_) => emit(DeleteAllDataState(type)),
    );
  }

  Future<void> _getSaveData(
    GetSaveDataEvent event,
    Emitter<OfflineSyncState> emit,
  ) async {
    (await getAllUsersForSyncUsecase.execute(conferenceId ?? 0)).fold(
      (failure) => emit(DataOfflineErrorState(failure: failure)),
      (data) {
        emit(GetSaveDataState(data));
      },
    );
  }

  Future<void> _addSaveData(
    AddSaveDataEvent event,
    Emitter<OfflineSyncState> emit,
  ) async {
    (await addSyncDataSqlUsecase.execute(event.data)).fold(
      (failure) => emit(DataOfflineErrorState(failure: failure)),
      (data) {
        emit(AddSaveDataSqlState(type));
      },
    );
  }
}
