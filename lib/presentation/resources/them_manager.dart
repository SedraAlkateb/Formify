import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
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
  // COLOR SCHEME (Dynamic or Seed)
  // ===========================
  final ColorScheme colorScheme = (dynamicScheme != null)
      ? dynamicScheme.harmonized().copyWith(
    brightness: isLight ? Brightness.light : Brightness.dark,
  )
      : ColorScheme.fromSeed(
    seedColor: seedColor ?? ColorManager.primary,
    brightness: isLight ? Brightness.light : Brightness.dark,
  );

  // ===========================
  // FULL THEME
  // ===========================
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    fontFamily: FontConstants.fontFamily1,

    // ================= APP BAR =================
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.primary,
      elevation: 0,
      iconTheme: IconThemeData(color: colorScheme.onPrimary),
      titleTextStyle: getBoldStyle(
        fontSize: FontSize.s20,
        color: colorScheme.onPrimary,
      ),
    ),

    // ================= TAB BAR =================
    tabBarTheme: TabBarThemeData(
      labelColor: colorScheme.onPrimary,
      unselectedLabelColor: colorScheme.primary.withOpacity(0.6),
      indicatorColor: colorScheme.secondary,
    ),

    // ================= BUTTONS =================
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p20, vertical: AppPadding.p12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s14),
        ),
      ),
    ),

    // ================= CARDS ===================
    cardTheme: CardThemeData(
      color: colorScheme.surface,
      shadowColor: Colors.black12,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s18),
      ),
    ),

    // ================= TEXT STYLES ==============
    textTheme: TextTheme(
      titleLarge: getBoldStyle(
          color: colorScheme.onBackground, fontSize: FontSize.s25),
      titleMedium: getSemiBoldStyle(
          color: colorScheme.onBackground, fontSize: FontSize.s18),
      bodyLarge:
      getRegularStyle(color: colorScheme.onBackground, fontSize: FontSize.s18),
      bodyMedium:
      getRegularStyle(color: colorScheme.onBackground, fontSize: FontSize.s14),
      labelLarge:
      getMediumStyle(color: colorScheme.onPrimary, fontSize: FontSize.s16),
    ),

    // ================= INPUTS ==================
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isLight
          ? ColorManager.fieldBackground
          : ColorManager.darkFieldBackground,
      contentPadding: const EdgeInsets.all(AppPadding.p12),
      labelStyle: getMediumStyle(color: colorScheme.primary),
      hintStyle: getRegularStyle(
          color: isLight
              ? ColorManager.textHint
              : ColorManager.darkTextSecondary),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: isLight ? ColorManager.border : ColorManager.darkBorder,
            width: 1.5),
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

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: colorScheme.primary,
    ),
  );
}
