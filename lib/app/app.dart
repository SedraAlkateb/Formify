import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// استيرادات ملفات تطبيق DoForm (formify) الخاصة بك لإدارة البيانات والثيمات والمسارات
import 'package:formify/app/app_preferences.dart';
import 'package:formify/app/constants.dart';
import 'package:formify/app/di.dart';
import 'package:formify/presentation/active_conference/bloc/active_conference_bloc.dart';
import 'package:formify/presentation/ai_desc/bloc/ai_bloc.dart';
import 'package:formify/presentation/conference/bloc/conference_bloc.dart';
import 'package:formify/presentation/excel/bloc/excel_st_bloc.dart';
import 'package:formify/presentation/offline_sync/bloc/offline_sync_bloc.dart';
import 'package:formify/presentation/onboarding/bloc/onboarding_bloc.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/responsive/breakpoints.dart';
import 'package:formify/presentation/resources/responsive/sizer_responseve.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/resources/them_manager.dart';
import 'package:formify/presentation/resources/theme_bloc/theme_bloc.dart';
import 'package:formify/presentation/survey/bloc/survey_bloc.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // 💡 الحفاظ الكامل على منطق الـ Logic والـ Preferences لفحص تسجيل الدخول وكلمة المرور
    final appPreferences = instance<AppPreferences>();
    Constants.isLogin = appPreferences.routLogin();
    Constants.password = appPreferences.getPassword() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    // 1. حقن وتجهيز قائمة الـ MultiBlocProvider بكافة الـ Blocs الخاصة بـ DoForm
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => instance<OnboardingBloc>()),
        BlocProvider(
          create: (_) => instance<OfflineSyncBloc>()..add(CheckEvent(Constants.password)),
        ),
        BlocProvider(create: (_) => instance<AiBloc>()),
        BlocProvider(create: (_) => instance<ActiveConferenceBloc>()),
        BlocProvider(
          create: (_) => instance<SyncBloc>()..add(DoctorEvent()),
        ),
        BlocProvider(create: (_) => instance<ConferenceBloc>()),
        BlocProvider(create: (_) => instance<SurveyBloc>()),
        BlocProvider(create: (_) => instance<ThemeBloc>()),
        BlocProvider(create: (_) => instance<ExcelStBloc>()),
      ],
      // 2. الاستماع لتغييرات الـ ThemeBloc لتحديث ألوان الـ SeedColor حياً
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          // 3. بناء الألوان الديناميكية المستوحاة من النظام إن وجدت
          return DynamicColorBuilder(
            builder: (lightDynamic, darkDynamic) {
              // 4. تهيئة حزمة الـ ScreenUtil وتثبيت أبعاد التصميم المرجعية (جوال وتابلت) لتجربة Responsive مستقرة
              return ScreenUtilInit(
                designSize: const Size(360, 690), // مقاس التصميم القياسي للموبايل
                minTextAdapt: true,
                splitScreenMode: true,
                builder: (context, child) {
                  return MaterialApp(
                    // 5. تخصيص الـ Builder لحماية الشاشات عند تدوير الجهاز أفقياً وضبط الـ Sizer
                    builder: (context, materialChild) {
                      // تهيئة الـ Sizer وفحص الأجهزة اللوحية بناءً على السياق الحالي لـ DoForm
                      Sizer.init(context);
                      Breakpoints.isMobileOrTablet(context);

                      // فحص منطق حالة الـ Landscape لحماية أبعاد واجهات الاستمارات من التمدد الزائد
                      return Breakpoints.isMobileLandscape(context)
                          ? Container(
                        color: ColorManager.white,
                        margin: const EdgeInsets.symmetric(horizontal: 80),
                        child: materialChild ?? const SizedBox.shrink(),
                      )
                          : materialChild ?? const SizedBox.shrink();
                    },
                    debugShowCheckedModeBanner: false,
                    // 6. إعدادات الثيم واللغة والمسارات المعتمدة في اللوجيك الخاص بك
                    theme: getApplicationTheme(
                      dynamicScheme: lightDynamic,
                      seedColor: themeState.seedColor,
                    ),
                    themeMode: ThemeMode.system,
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
                    onGenerateRoute: RouteGenerator.getRoute,
                    initialRoute: Constants.isLogin, // المسار الابتدائي الديناميكي للتطبيق بعد فحص السجل محلياً
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}