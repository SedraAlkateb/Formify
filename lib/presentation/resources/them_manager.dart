import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:formify/app/constants.dart';
import 'color_manager.dart';
import 'font_manager.dart';
import 'style_manage.dart';
import 'values_manager.dart';

ThemeData getApplicationTheme({
  Color? seedColor,
  required bool isLight,
  ColorScheme? dynamicScheme,
}) {
  // ===========================
  // COLOR SCHEME (Seed أولاً، ثم Dynamic)
  // ===========================
  late final ColorScheme colorScheme;

  if (seedColor != null) {
    // إذا عندي seedColor من الـ BLoC -> استخدمه وأتجاهل dynamicScheme
    colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: isLight ? Brightness.light : Brightness.dark,
    );
  } else if (dynamicScheme != null) {
    // إذا ما في seedColor لكن في dynamicScheme -> استخدمه
    colorScheme = dynamicScheme.harmonized().copyWith(
      brightness: isLight ? Brightness.light : Brightness.dark,
    );
  } else {
    // لا seedColor ولا dynamicScheme -> استخدم اللون الافتراضي
    colorScheme = ColorScheme.fromSeed(
      seedColor: ColorManager.primary,
      brightness: isLight ? Brightness.light : Brightness.dark,
    );
  }

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    fontFamily: FontConstants.fontFamily1,

    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.primary,
      elevation: 0,
      iconTheme: IconThemeData(color: colorScheme.onPrimary),
      titleTextStyle: getBoldStyle(
        fontSize: FontSize.s20,
        color: colorScheme.onPrimary,
      ),
    ),

    tabBarTheme: TabBarThemeData(
      labelColor: colorScheme.onPrimary,
      unselectedLabelColor: colorScheme.primary.withOpacity(0.6),
      indicatorColor: colorScheme.secondary,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding:  EdgeInsets.symmetric(
          horizontal: AppPadding.p20,
          vertical: AppPadding.p12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s14),
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: colorScheme.surface,

      elevation: 4,

      shadowColor: Colors.grey.withOpacity(0.04),

      surfaceTintColor: Colors.transparent, // مهم لمنع dark overlay

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s18),
      ),

      clipBehavior: Clip.antiAlias,
    ),

    textTheme: TextTheme(
      titleLarge: getBoldStyle(
        color: colorScheme.onBackground,
        fontSize: FontSize.s25,
      ),
      titleMedium: getSemiBoldStyle(
        color: colorScheme.onBackground,
        fontSize: FontSize.s18,
      ),
      bodyLarge: getRegularStyle(
        color: colorScheme.onBackground,
        fontSize: FontSize.s18,
      ),
      bodyMedium: getRegularStyle(
        color: colorScheme.onBackground,
        fontSize: FontSize.s14,
      ),
      labelLarge: getMediumStyle(
        color: colorScheme.onPrimary,
        fontSize: FontSize.s16,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isLight
          ? ColorManager.fieldBackground
          : ColorManager.darkFieldBackground,
      contentPadding:  EdgeInsets.all(AppPadding.p12),
      labelStyle: getMediumStyle(color: colorScheme.primary),
      hintStyle: getRegularStyle(
        fontSize: Constants.isTablet?20:16,
        color: isLight ? ColorManager.textHint : ColorManager.darkTextSecondary,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: isLight ? ColorManager.border : ColorManager.darkBorder,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(AppSize.s12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
        borderRadius: BorderRadius.circular(AppSize.s12),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorManager.error),
        borderRadius: BorderRadius.circular(AppSize.s12),
      ),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: TextStyle(color: ColorManager.black),
    ),

    // dropdownButtonTheme: DropdownButtonThemeData(
    //   textStyle: TextStyle(
    //     color: isLight ? ColorManager.black : Colors.white,
    //     fontSize: FontSize.s14,
    //   ),
    // ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: colorScheme.primary,
    ),
  );
}
