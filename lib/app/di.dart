import 'package:dio/dio.dart';
import 'package:formify/app/app_preferences.dart';
import 'package:formify/data/data_source/remote_data_source.dart';
import 'package:formify/data/network/app_api.dart';
import 'package:formify/data/network/app_sql_api.dart';
import 'package:formify/data/network/dio_factory.dart';
import 'package:formify/data/network/network_info.dart';
import 'package:formify/data/network/sqlite_factory.dart';
import 'package:formify/data/repository/repository.dart';
import 'package:formify/data/repository/repositroy_sql.dart';
import 'package:formify/domain/repostitory/repository.dart';
import 'package:formify/domain/repostitory/repository_sql.dart';
import 'package:formify/domain/usecase/add_async_data_sql_usecase.dart';
import 'package:formify/domain/usecase/create_conference_usecase.dart';
import 'package:formify/domain/usecase/create_survey_question_usecase.dart';
import 'package:formify/domain/usecase/create_survey_usecase.dart';
import 'package:formify/domain/usecase/delete_conference_usecase.dart';
import 'package:formify/domain/usecase/delete_data_sql_usecase.dart';
import 'package:formify/domain/usecase/delete_user_sql_usecase.dart';
import 'package:formify/domain/usecase/get_all_async_info_usecase.dart';
import 'package:formify/domain/usecase/get_all_conference_usecase.dart';
import 'package:formify/domain/usecase/get_all_survey_and_active_usecase.dart';
import 'package:formify/domain/usecase/get_all_survey_usecase.dart';
import 'package:formify/domain/usecase/get_all_user_usecase.dart';
import 'package:formify/domain/usecase/get_conference_by_id_usecase.dart';
import 'package:formify/domain/usecase/get_conference_info_sql_usecase.dart';
import 'package:formify/domain/usecase/get_conference_sql_usecase.dart';
import 'package:formify/domain/usecase/get_question_answers_usecase.dart';
import 'package:formify/domain/usecase/get_survey_question_id_usecase.dart';
import 'package:formify/domain/usecase/get_surveys_sql_usecase.dart';
import 'package:formify/domain/usecase/get_user_answer_sql_usecase.dart';
import 'package:formify/domain/usecase/get_user_answers_survey_usecase.dart';
import 'package:formify/domain/usecase/insert_user_and_answer_usecase.dart';
import 'package:formify/domain/usecase/link_survey_conference_usecase.dart';
import 'package:formify/domain/usecase/login_usecase.dart';
import 'package:formify/domain/usecase/statistics_for_users_answers_usecase.dart';
import 'package:formify/domain/usecase/synchronize_users_answers_usecase.dart';
import 'package:formify/domain/usecase/update_conference_usecase.dart';
import 'package:formify/domain/usecase/update_survey_usecase.dart';
import 'package:formify/presentation/active_conference/bloc/active_conference_bloc.dart';
import 'package:formify/presentation/conference/bloc/conference_bloc.dart';
import 'package:formify/presentation/excel/bloc/excel_st_bloc.dart';
import 'package:formify/presentation/onboarding/bloc/onboarding_bloc.dart';
import 'package:formify/presentation/resources/theme_bloc/theme_bloc.dart';
import 'package:formify/presentation/survey/bloc/survey_bloc.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt instance = GetIt.instance;
Future<void> initAppModule() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  //app prefs instance
  instance.registerLazySingleton<AppPreferences>(
    () => AppPreferences(instance()),
  );
  //network info instance

  instance.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  instance.registerLazySingleton<DioFactory>(() => DioFactory());
  Dio dio = await instance<DioFactory>().getDio();
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));
  instance.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceImpl(instance<AppServiceClient>()),
  );
  DatabaseHelper databaseHelper = DatabaseHelper();
  instance.registerLazySingleton<AppSqlApi>(() => AppSqlApi(databaseHelper));
  await instance<AppSqlApi>().initializeDatabase();

  instance.registerLazySingleton<RepositorySql>(
    () => RepositroySqlImp(instance()),
  );
  //repository
  instance.registerLazySingleton<Repository>(
    () => RepositoryImp(instance(), instance()),
  );
  instance.registerLazySingleton<ThemeBloc>(() => ThemeBloc());
}

Future<void> initOnBoardingModule() async {
  if (!GetIt.I.isRegistered<LoginUsecase>()) {
    instance.registerFactory<LoginUsecase>(() => LoginUsecase(instance()));
    instance.registerFactory<OnboardingBloc>(() => OnboardingBloc(instance()));
  }
}
Future<void> initExcelModule() async {
  if (!GetIt.I.isRegistered<StatisticsForUsersAnswersUsecase>()) {
    instance.registerFactory<StatisticsForUsersAnswersUsecase>(() => StatisticsForUsersAnswersUsecase(instance()));
    instance.registerFactory<ExcelStBloc>(() => ExcelStBloc(instance()));
  }
}
Future<void> initConferenceModule() async {
  if (!GetIt.I.isRegistered<ConferenceBloc>()) {
    instance.registerFactory<CreateConferenceUsecase>(
      () => CreateConferenceUsecase(instance()),
    );
    instance.registerFactory<GetAllConferenceUsecase>(
      () => GetAllConferenceUsecase(instance()),
    );
    instance.registerFactory<LinkSurveyConferenceUsecase>(
      () => LinkSurveyConferenceUsecase(instance()),
    );
    instance.registerFactory<DeleteConferenceUsecase>(
      () => DeleteConferenceUsecase(instance()),
    );
    instance.registerFactory<GetAllSurveyUsecase>(
      () => GetAllSurveyUsecase(instance()),
    );
    instance.registerFactory<GetConferenceByIdUsecase>(
      () => GetConferenceByIdUsecase(instance()),
    );
    instance.registerFactory<GetAllSurveyAndActiveUsecase>(
      () => GetAllSurveyAndActiveUsecase(instance()),
    );
    instance.registerFactory<UpdateConferenceUsecase>(
          () => UpdateConferenceUsecase(instance()),
    );
    instance.registerFactory<ConferenceBloc>(
      () => ConferenceBloc(
        instance(),
        instance(),
        instance(),
        instance(),
        instance(),
        instance(),
        instance(),
        instance()
      ),
    );
  }
}

Future<void> initActiveConferenceModule() async {
  if (!GetIt.I.isRegistered<GetAllSurveyUsecase>()) {
    instance.registerFactory<GetAllSurveyUsecase>(
      () => GetAllSurveyUsecase(instance()),
    );
  }
  if (!GetIt.I.isRegistered<GetConferenceByIdUsecase>()) {
    instance.registerFactory<GetConferenceByIdUsecase>(
      () => GetConferenceByIdUsecase(instance()),
    );
  }
  if (!GetIt.I.isRegistered<GetAllConferenceUsecase>()) {
    instance.registerFactory<GetAllConferenceUsecase>(
      () => GetAllConferenceUsecase(instance()),
    );
  }
  if (!GetIt.I.isRegistered<GetAllUserUsecase>()) {
    instance.registerFactory<GetAllUserUsecase>(
      () => GetAllUserUsecase(instance()),
    );
  }
  if (!GetIt.I.isRegistered<GetUserAnswersSurveyUsecase>()) {
    instance.registerFactory<GetUserAnswersSurveyUsecase>(
      () => GetUserAnswersSurveyUsecase(instance()),
    );
  }
  if (!GetIt.I.isRegistered<ActiveConferenceBloc>()) {
    instance.registerFactory<ActiveConferenceBloc>(
      () =>
          ActiveConferenceBloc(instance(), instance(), instance(), instance()),
    );
  }
}

Future<void> initSurveyModule() async {
  if (!GetIt.I.isRegistered<GetAllSurveyUsecase>()) {
    instance.registerFactory<GetAllSurveyUsecase>(
      () => GetAllSurveyUsecase(instance()),
    );
  }
  if (!GetIt.I.isRegistered<SurveyBloc>()) {
    instance.registerFactory<CreateSurveyUsecase>(
      () => CreateSurveyUsecase(instance()),
    );
    instance.registerFactory<CreateSurveyQuestionUsecase>(
      () => CreateSurveyQuestionUsecase(instance()),
    );
    instance.registerFactory<GetSurveyQuestionIdUsecase>(
      () => GetSurveyQuestionIdUsecase(instance()),
    );
    instance.registerFactory<UpdateSurveyUsecase>(
      () => UpdateSurveyUsecase(instance()),
    );

    instance.registerFactory<SurveyBloc>(
      () => SurveyBloc(
        instance(),
        instance(),
        instance(),
        instance(),
        instance(),
      ),
    );
  }
}

Future<void> initSyncModule() async {
  if (!GetIt.I.isRegistered<GetUserAnswerSqlUsecase>()) {
    instance.registerFactory<GetUserAnswerSqlUsecase>(
      () => GetUserAnswerSqlUsecase(instance()),
    );
    instance.registerFactory<AddAsyncDataSqlUsecase>(
      () => AddAsyncDataSqlUsecase(instance()),
    );
    instance.registerFactory<GetAllAsyncInfoUsecase>(
      () => GetAllAsyncInfoUsecase(instance()),
    );
    instance.registerFactory<SynchronizeUsersAnswersUsecase>(
      () => SynchronizeUsersAnswersUsecase(instance()),
    );
    instance.registerFactory<DeleteDataSqlUsecase>(
      () => DeleteDataSqlUsecase(instance()),
    );
    instance.registerFactory<DeleteUserSqlUsecase>(
      () => DeleteUserSqlUsecase(instance()),
    );
    instance.registerFactory<GetConferenceSqlUsecase>(
      () => GetConferenceSqlUsecase(instance()),
    );
    instance.registerFactory<GetSurveysSqlUsecase>(
      () => GetSurveysSqlUsecase(instance()),
    );
    instance.registerFactory<GetQuestionAnswersUsecase>(
      () => GetQuestionAnswersUsecase(instance()),
    );
    instance.registerFactory<InsertUserAndAnswerUsecase>(
      () => InsertUserAndAnswerUsecase(instance()),
    );
    instance.registerFactory<GetConferenceInfoSqlUsecase>(
      () => GetConferenceInfoSqlUsecase(instance()),
    );
    instance.registerFactory<SyncBloc>(
      () => SyncBloc(
        instance(),
        instance(),
        instance(),
        instance(),
        instance(),
        instance(),
        instance(),
        instance(),
        instance(),
        instance(),
        instance(),
      ),
    );
  }
}
