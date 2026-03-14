import 'package:flutter/widgets.dart';
import 'package:formify/app/constants.dart';

class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;

  static double _shortestSide(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide;
  }
  static bool isMobileOrTablet(BuildContext context) {
    if (isMobile(context)) {
      Constants.isTablet = false;
      return true;
    } else if (isTablet(context)) {
      Constants.isTablet = true;
      return true;
    } else {
      Constants.isTablet = false;
      return false;
    }
  }

  // -----------------------
  // Device type
  // -----------------------

  static bool isMobile(BuildContext context) {
    return _shortestSide(context) < mobile;
  }

  static bool isTablet(BuildContext context) {
    final side = _shortestSide(context);
    return side >= mobile && side < tablet;
  }

  // -----------------------
  // Orientation
  // -----------------------

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  // -----------------------
  // Mobile orientation
  // -----------------------

  static bool isMobileLandscape(BuildContext context) {
    return isMobile(context) && isLandscape(context);
  }

  static bool isMobilePortrait(BuildContext context) {
    return isMobile(context) && isPortrait(context);
  }

  // -----------------------
  // Tablet orientation
  // -----------------------

  static bool isTabletLandscape(BuildContext context) {
    return isTablet(context) && isLandscape(context);
  }

  static bool isTabletPortrait(BuildContext context) {
    return isTablet(context) && isPortrait(context);
  }

  // -----------------------
  // Init device type
  // -----------------------

  static void initDeviceType(BuildContext context) {
    if (isTablet(context)) {
      Constants.isTablet = true;
    } else {
      Constants.isTablet = false;
    }
  }

}
