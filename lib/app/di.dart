import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:formify/app/app_preferences.dart';
import 'package:formify/data/data_source/remote_data_source.dart';
import 'package:formify/data/network/app_api.dart';
import 'package:formify/data/network/dio_factory.dart';
import 'package:formify/data/network/network_info.dart';
import 'package:formify/data/repository/repository.dart';
import 'package:formify/domain/repostitory/repository.dart';
import 'package:formify/presentation/onboarding/bloc/onboarding_bloc.dart';
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
      () => NetworkInfoImpl(Connectivity()));
  instance.registerLazySingleton<DioFactory>(() => DioFactory());
  Dio dio = await instance<DioFactory>().getDio();
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));
  instance.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(instance<AppServiceClient>()));
  //repository
  instance.registerLazySingleton<Repository>(
      () => RepositoryImp(instance(), instance()));
}

Future<void> initOnBoardingModule() async {
  if (!GetIt.I.isRegistered<OnboardingBloc>()) {
    instance.registerFactory<OnboardingBloc>(() => OnboardingBloc());

  }
}
