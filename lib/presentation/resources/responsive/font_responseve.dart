import 'package:flutter/material.dart';
import 'package:formify/app/constants.dart';
import 'package:formify/presentation/resources/responsive/breakpoints.dart';

class FontResponsive {

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static bool isMobile(BuildContext context) =>
      screenWidth(context) < 600;

  static bool isTablet(BuildContext context) =>
      screenWidth(context) >= 600 && screenWidth(context) < 1024;

  /// scale font based on device
  static double font(
      BuildContext context, {
        required double mobile,
        double? tablet,
      }) {
    final isMobileLandscape = Breakpoints.isMobileLandscape(context);

    if (Constants.isTablet) {
      return tablet ?? mobile;
    }

    return mobile;
  }
}