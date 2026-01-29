import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/usecase/add_async_data_sql_usecase.dart';
import 'package:formify/domain/usecase/delete_data_sql_usecase.dart';
import 'package:formify/domain/usecase/get_all_async_info_usecase.dart';
import 'package:formify/domain/usecase/get_conference_sql_usecase.dart';
import 'package:formify/domain/usecase/get_question_answers_usecase.dart';
import 'package:formify/domain/usecase/get_surveys_sql_usecase.dart';
import 'package:formify/domain/usecase/get_user_answer_sql_usecase.dart';
import 'package:formify/domain/usecase/insert_user_and_answer_usecase.dart';
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
  GetSurveysSqlUsecase getSurveysSqlUsecase;
  GetQuestionAnswersUsecase getQuestionAnswersUsecase;
  InsertUserAndAnswerUsecase insertUserAndAnswerUsecase;
  UserSqlModel? userSqlModel;
  int? conferenceId;
  List<QuestionModel> questions = [];
  Map<int, List<AnswerUserModel>> answers = {};
  List<AnswerUserModel> answer = [];
  SyncBloc(
    this.getAllAsyncInfoUsecase,
    this.addAsyncDataSqlUsecase,
    this.getUserAnswerSqlUsecase,
    this.deleteDataSqlUsecase,
    this.synchronizeUsersAnswersUsecase,
    this.getConferenceSqlUsecase,
    this.getSurveysSqlUsecase,
    this.getQuestionAnswersUsecase,
    this.insertUserAndAnswerUsecase,
  ) : super(SyncInitial()) {
    on<SyncEvent>((event, emit) async {
      ////////////////4
      if (event is AsyncDataEvent) {
        (await getAllAsyncInfoUsecase.execute(conferenceId ?? -1)).fold(
          (failure) {
            emit(DataErrorState(failure: failure));
          },
          (data) async {
            emit(AsyncConferenceState(data));
          },
        );
      }
      //////////////////5
      if (event is InsertDataSqlEvent) {
        (await addAsyncDataSqlUsecase.execute(event.asyncModel)).fold(
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
            conferenceId = event.conferenceId;
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
      if (event is GetQuestionAnswersEvent) {
        emit(GetQuestionAnswersLoadingState());
        (await getQuestionAnswersUsecase.execute(event.id)).fold(
          (failure) {
            emit(GetQuestionAnswersErrorState(failure: failure));
          },
          (data) async {
            questions = data;
            emit(GetQuestionAnswersState(data, event.surveyName));
          },
        );
      }
      if (event is GetSurveyAsyncEvent) {
        emit(GetSurveyAsyncLoadingState());
        (await getSurveysSqlUsecase.execute()).fold(
          (failure) {
            emit(GetSurveyAsyncErrorState(failure: failure));
          },
          (data) async {
            emit(GetSurveyAsyncState(data));
          },
        );
      }
   else   if (event is CreateUserAnswerEvent) {

        emit(GetSurveyAsyncLoadingState());
        (await getSurveysSqlUsecase.execute()).fold(
              (failure) {
            emit(GetSurveyAsyncErrorState(failure: failure));
          },
              (data) async {
            emit(GetSurveyAsyncState(data));
          },
        );
      }
      if (event is InputUserSqlEvent) {
        userSqlModel = event.userSqlModel;
      }
    });
  }
  void addUserAnswer(int key) {
    if (answers.containsKey(key)) {
      answers[key] = answer;
    } else {
      answers.putIfAbsent(key, () => answer);
    }
  }

}
