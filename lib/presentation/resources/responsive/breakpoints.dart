import 'package:flutter/widgets.dart';

class Breakpoints {
  static const double mobile = 600;
  static const double desktop = 1440;

  static bool isMobile(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    // ✅ إذا الجهاز Tablet لكن عمودي -> اعتبره Mobile
    if (isPortrait && size.width < 900) return true;

    return size.width < mobile;
  }

  static bool isTablet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    // ✅ Tablet عمودي -> ليس Tablet
    if (isPortrait) return false;

    return size.width >= mobile && size.width < desktop;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktop;
  }
}