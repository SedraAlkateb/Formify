import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/app/app_preferences.dart';
import 'package:formify/app/constants.dart';
import 'package:formify/app/di.dart';
import 'package:formify/presentation/active_conference/bloc/active_conference_bloc.dart';
import 'package:formify/presentation/conference/bloc/conference_bloc.dart';
import 'package:formify/presentation/excel/bloc/excel_st_bloc.dart';
import 'package:formify/presentation/onboarding/bloc/onboarding_bloc.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/responsive/breakpoints.dart';
import 'package:formify/presentation/resources/responsive/sizer_responseve.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/resources/them_manager.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:formify/presentation/resources/theme_bloc/theme_bloc.dart';
import 'package:formify/presentation/survey/bloc/survey_bloc.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    final appPreferences = instance<AppPreferences>();
    Constants.isLogin = appPreferences.routLogin();
    Constants.password=appPreferences.getPassword()??"";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Breakpoints.isMobileOrTablet(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => instance<OnboardingBloc>()),
        BlocProvider(create: (_) => instance<ActiveConferenceBloc>()),
        BlocProvider(create: (_) => instance<SyncBloc>()..add(CheckEvent(Constants.password))),
        BlocProvider(create: (_) => instance<ConferenceBloc>(),),

        BlocProvider(create: (_) => instance<SurveyBloc>()),
        BlocProvider(create: (_) => instance<ThemeBloc>()),
        BlocProvider(create: (_) => instance<ExcelStBloc>()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return DynamicColorBuilder(
            builder: (lightDynamic, darkDynamic) {
              return MaterialApp(
                builder: (context, child) {
                  Sizer.init(context);
                  return Breakpoints.isMobileLandscape(context)
                      ? Container(
                          color: ColorManager.white,
                          margin: EdgeInsets.symmetric(horizontal: 80),
                          child: child ?? const SizedBox.shrink(),
                        )
                      : child ?? const SizedBox.shrink();
                },
                debugShowCheckedModeBanner: false,
                theme: getApplicationTheme(
                  dynamicScheme: lightDynamic,
                  seedColor: state.seedColor,
                ),
                themeMode: ThemeMode.system,
                locale: const Locale('ar'),
                supportedLocales: const [Locale('ar'), Locale('en')],
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                onGenerateRoute: RouteGenerator.getRoute,
                initialRoute: Constants.isLogin,
                // Routes.onboarding,
              );
            },
          );
        },
      ),
    );
  }
}
