import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'color_manager.dart';
import 'font_manager.dart';
import 'style_manage.dart';
import 'values_manager.dart';

ThemeData getApplicationTheme(ColorScheme? dynamicScheme, {bool isLight = true}) {
  late final ColorScheme colorScheme;

  // ============================
  //       DYNAMIC COLOR (Material You)
  // ============================
  if (dynamicScheme != null) {
    colorScheme = dynamicScheme
        .harmonized() // ينسّق scheme النظام ليتناسب مع لون تطبيقك
        .copyWith(
      brightness: isLight ? Brightness.light : Brightness.dark,
    );
  }

  // ============================
  //           FALLBACK
  // ============================
  else {
    colorScheme = ColorScheme.fromSeed(
      seedColor: ColorManager.primary,
      brightness: isLight ? Brightness.light : Brightness.dark,
    );
  }

  // ============================
  //        THEME DATA
  // ============================
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    fontFamily: FontConstants.fontFamily1,

    // ================= AppBar =================
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      elevation: 4,
      iconTheme: IconThemeData(color: colorScheme.primary),
      titleTextStyle: getBoldStyle(
        fontSize: FontSize.s20,
        color: colorScheme.primary,
      ),
    ),

    // ============= Tabs ===================
    tabBarTheme: TabBarThemeData(
      labelColor: colorScheme.onPrimary,
      unselectedLabelColor: colorScheme.primary,
      indicatorColor: colorScheme.secondary,
    ),

    // ============= Buttons =================
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p20,
          vertical: AppPadding.p10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s14),
        ),
      ),
    ),

    // ============= Cards ====================
    cardTheme: CardThemeData(
      color: colorScheme.surface,
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s18),
      ),
    ),

    // ============= Text Theme ===============
    textTheme: TextTheme(
      titleLarge:
      getBoldStyle(color: colorScheme.onBackground, fontSize: FontSize.s25),
      titleMedium: getSemiBoldStyle(
          color: colorScheme.onBackground, fontSize: FontSize.s18),

      bodyLarge: getRegularStyle(
          color: colorScheme.onBackground, fontSize: FontSize.s18),
      bodyMedium: getRegularStyle(
          color: colorScheme.onBackground, fontSize: FontSize.s14),

      labelLarge: getMediumStyle(
          color: colorScheme.onPrimary, fontSize: FontSize.s16),
    ),

    // ============= Inputs ====================
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor:
      isLight ? ColorManager.fieldBackground : ColorManager.darkFieldBackground,
      contentPadding: const EdgeInsets.all(AppPadding.p12),

      labelStyle: getMediumStyle(
          color: colorScheme.primary, fontSize: FontSize.s18),

      hintStyle: getRegularStyle(
          color: isLight
              ? ColorManager.textHint
              : ColorManager.darkTextSecondary,
          fontSize: FontSize.s16),

      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: isLight ? ColorManager.border : ColorManager.darkBorder,
          width: AppSize.s1_5,
        ),
        borderRadius: BorderRadius.circular(AppSize.s12),
      ),

      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: colorScheme.primary,
          width: AppSize.s2,
        ),
        borderRadius: BorderRadius.circular(AppSize.s12),
      ),

      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorManager.error),
        borderRadius: BorderRadius.circular(AppSize.s12),
      ),
    ),

    // ============= Cursor ====================
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: colorScheme.primary,
    ),
  );
}
