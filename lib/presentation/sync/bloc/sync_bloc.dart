import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/request.dart';
import 'package:formify/domain/usecase/add_async_data_sql_usecase.dart';
import 'package:formify/domain/usecase/delete_data_sql_usecase.dart';
import 'package:formify/domain/usecase/get_all_async_info_usecase.dart';
import 'package:formify/domain/usecase/get_conference_sql_usecase.dart';
import 'package:formify/domain/usecase/get_user_answer_sql_usecase.dart';
import 'package:formify/domain/usecase/synchronize_users_answers_usecase.dart';
import 'package:meta/meta.dart';

part 'sync_event.dart';
part 'sync_state.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  GetAllAsyncInfoUsecase getAllAsyncInfoUsecase;
  AddAsyncDataSqlUsecase addAsyncDataSqlUsecase;
  GetUserAnswerSqlUsecase getUserAnswerSqlUsecase;
  DeleteDataSqlUsecase deleteDataSqlUsecase;
  SynchronizeUsersAnswersUsecase synchronizeUsersAnswersUsecase;
  GetConferenceSqlUsecase getConferenceSqlUsecase;
  GetAsyncModel asyncModel= GetAsyncModel.create();

  int ?conferenceId;

  SyncBloc(
    this.getAllAsyncInfoUsecase,
    this.addAsyncDataSqlUsecase,
    this.getUserAnswerSqlUsecase,
    this.deleteDataSqlUsecase,
    this.synchronizeUsersAnswersUsecase,
      this.getConferenceSqlUsecase
  ) : super(SyncInitial()) {
    on<SyncEvent>((event, emit) async {
      ////////////////4
      if (event is AsyncDataEvent) {

        (await getAllAsyncInfoUsecase.execute(conferenceId??-1)).fold(
          (failure) {
            emit(DataErrorState(failure: failure));
          },
          (data) async {
            emit(AsyncConferenceState());
          },
        );
      }
      //////////////////5
      if (event is InsertDataSqlEvent) {

        (await addAsyncDataSqlUsecase.execute(asyncModel)).fold(
          (failure) {
            emit(DataErrorState(failure: failure));
          },
          (data) async {
                emit(InsertSucState());
          },
        );
      }
 //////////////3
      if (event is DeleteDataEvent) {
        (await deleteDataSqlUsecase.execute()).fold(
              (failure) {
            emit(DataErrorState(failure: failure));
          },
              (data) async {
            emit(DeleteDataState());
          },
        );
      }
      //////1
      if (event is GetDataEvent) {
        emit(DataLoadingState());
        (await getUserAnswerSqlUsecase.execute()).fold(
              (failure) {
            emit(DataErrorState(failure: failure));
          },
              (data) async {
                conferenceId=event.conferenceId;
            emit(GetDataState(data));
          },
        );
      }
      /////////2
      if (event is UploadDataEvent) {
        (await synchronizeUsersAnswersUsecase.execute(event.userRequest)).fold(
              (failure) {
            emit(DataErrorState(failure: failure));
          },
              (data) async {
            emit(UploadDataState());
          },
        );
      }
      //////////////////
      if (event is GetConferenceAsyncEvent) {
        emit(GetConferenceAsyncLoadingState());
        (await getConferenceSqlUsecase.execute()).fold(
              (failure) {
            emit(GetConferenceAsyncErrorState(failure: failure));
          },
              (data) async {
            emit(GetConferenceAsyncState(data));
          },
        );
      }
    });
  }
}
