import 'package:dio/dio.dart';
import 'package:formify/app/app_preferences.dart';
import 'package:formify/data/data_source/remote_data_source.dart';
import 'package:formify/data/network/app_api.dart';
import 'package:formify/data/network/dio_factory.dart';
import 'package:formify/data/network/network_info.dart';
import 'package:formify/data/repository/repository.dart';
import 'package:formify/domain/repostitory/repository.dart';
import 'package:formify/domain/usecase/create_conference_usecase.dart';
import 'package:formify/domain/usecase/create_survey_question_usecase.dart';
import 'package:formify/domain/usecase/create_survey_usecase.dart';
import 'package:formify/domain/usecase/get_all_conference_usecase.dart';
import 'package:formify/domain/usecase/get_all_survey_usecase.dart';
import 'package:formify/domain/usecase/link_survey_conference_usecase.dart';
import 'package:formify/presentation/conference/bloc/conference_bloc.dart';
import 'package:formify/presentation/onboarding/bloc/onboarding_bloc.dart';
import 'package:formify/presentation/resources/theme_bloc/theme_bloc.dart';
import 'package:formify/presentation/survey/bloc/survey_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt instance = GetIt.instance;
Future<void> initAppModule() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  //app prefs instance
  instance
      .registerLazySingleton<AppPreferences>(() => AppPreferences(instance()));
  //network info instance

  instance.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl());
  instance.registerLazySingleton<DioFactory>(() => DioFactory());
  Dio dio = await instance<DioFactory>().getDio();
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));
  instance.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(instance<AppServiceClient>()));
  //repository
  instance.registerLazySingleton<Repository>(
      () => RepositoryImp(instance(), instance()));
  instance.registerLazySingleton<ThemeBloc>(
          () => ThemeBloc());
}

Future<void> initOnBoardingModule() async {
  if (!GetIt.I.isRegistered<OnboardingBloc>()) {
    instance.registerFactory<OnboardingBloc>(() => OnboardingBloc());

  }
}
Future<void> initConferenceModule() async {
  if (!GetIt.I.isRegistered<ConferenceBloc>()) {
    instance.registerFactory<CreateConferenceUsecase>(() => CreateConferenceUsecase(instance()));
    instance.registerFactory<GetAllConferenceUsecase>(() =>
        GetAllConferenceUsecase(instance()));
    instance.registerFactory<LinkSurveyConferenceUsecase>(() =>
        LinkSurveyConferenceUsecase(instance()));
    instance.registerFactory<GetAllSurveyUsecase>(() =>
        GetAllSurveyUsecase(instance()));
    instance.registerFactory<ConferenceBloc>(() => ConferenceBloc(instance(),instance(),instance(),instance()));
  }
}
Future<void> initSurveyModule() async {
  if (!GetIt.I.isRegistered<GetAllSurveyUsecase>()) {
    instance.registerFactory<GetAllSurveyUsecase>(() =>
        GetAllSurveyUsecase(instance()));
  }
  if (!GetIt.I.isRegistered<SurveyBloc>()) {
    instance.registerFactory<CreateSurveyUsecase>(() => CreateSurveyUsecase(instance()));
    instance.registerFactory<CreateSurveyQuestionUsecase>(() => CreateSurveyQuestionUsecase(instance()));

    instance.registerFactory<SurveyBloc>(() => SurveyBloc(instance(),instance(),instance()));

  }
}