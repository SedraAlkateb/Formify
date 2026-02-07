import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:formify/app/di.dart';
import 'package:formify/presentation/active_conference/bloc/active_conference_bloc.dart';
import 'package:formify/presentation/conference/bloc/conference_bloc.dart';
import 'package:formify/presentation/onboarding/bloc/onboarding_bloc.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/resources/them_manager.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:formify/presentation/resources/theme_bloc/theme_bloc.dart';
import 'package:formify/presentation/survey/bloc/survey_bloc.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => instance<OnboardingBloc>()),
      BlocProvider(create: (_) => instance<ActiveConferenceBloc>()),
        BlocProvider(create: (_) => instance<SyncBloc>()),
        BlocProvider(create: (_) => instance<ThemeBloc>()),
        BlocProvider(create: (_) => instance<ConferenceBloc>()),
        BlocProvider(create: (_) => instance<SurveyBloc>()),
        BlocProvider<ConferenceBloc>(
          create: (context) {
            final bloc = instance<ConferenceBloc>();
         //   bloc.add(GetAllNotActiveConferenceEvent());
            return bloc;
          },
        ),
      ],
      child: DynamicColorBuilder(
        builder: (lightDynamic, darkDynamic) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: getApplicationTheme(
                  dynamicScheme: lightDynamic,
                  isLight: true,
                  seedColor: BlocProvider.of<ThemeBloc>(context).seedColor,
                ),
                darkTheme: getApplicationTheme(
                  dynamicScheme: darkDynamic,
                  isLight: false,
                  seedColor: BlocProvider.of<ThemeBloc>(context).seedColor,
                ),
                themeMode: ThemeMode.system,
                locale: const Locale('en'),
                supportedLocales: const [Locale('en'), Locale('ar')],
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                onGenerateRoute: RouteGenerator.getRoute,
                initialRoute:Routes.onboarding,
               // Routes.onboarding,
              );
            },
          );
        },
      ),
    );
  }
}


