import 'package:flutter/material.dart';

class FontResponsive {

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static bool isMobile(BuildContext context) =>
      screenWidth(context) < 600;

  static bool isTablet(BuildContext context) =>
      screenWidth(context) >= 600 && screenWidth(context) < 1024;

  static bool isDesktop(BuildContext context) =>
      screenWidth(context) >= 1024;

  /// scale font based on device
  static double font(
      BuildContext context, {
        required double mobile,
        double? tablet,
        double? desktop,
      }) {

    if (isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    }

    if (isTablet(context)) {
      return tablet ?? mobile;
    }

    return mobile;
  }
}