import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/resources/them_manager.dart';
import 'package:dynamic_color/dynamic_color.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider(create: (_) => instance<AuthBloc>()),
      ],

      child: DynamicColorBuilder(
        builder: (lightDynamic, darkDynamic) {
          return MaterialApp(
            locale: const Locale('ar'),
            supportedLocales: const [
              Locale('ar'),
              Locale('en'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              return const Locale('ar');
            },

            debugShowCheckedModeBanner: false,

            // ----------- 🔥 THEMES WITH DYNAMIC COLOR -------------
            theme: getApplicationTheme(lightDynamic, isLight: true),
            darkTheme: getApplicationTheme(darkDynamic, isLight: false),
            themeMode: ThemeMode.system,
            // -------------------------------------------------------

            onGenerateRoute: RouteGenerator.getRoute,
            initialRoute: Routes.login,
          );
        },
      ),
    );
  }
}

