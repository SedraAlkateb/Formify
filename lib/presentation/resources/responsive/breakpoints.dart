import 'package:flutter/widgets.dart';
import 'package:formify/app/constants.dart';

class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;

  // موبايل أفقي
  static bool isMobileLandscape(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // موبايل أفقي: الشاشة أصغر من 600px ويكون الاتجاه أفقي
    return size.width < mobile && isLandscape;
  }

  // موبايل عمودي (Portrait)
  static bool isMobilePortrait(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    // موبايل عمودي: الشاشة أصغر من 600px ويكون الاتجاه عمودي
    return size.width < mobile && isPortrait;
  }

  // تاب عمودي (Portrait)
  static bool isTabletPortrait(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    // تاب عمودي: العرض بين 600 و 900
    return isPortrait && size.width >= mobile && size.width < tablet;
  }

  // تاب أفقي (Landscape)
  static bool isTabletLandscape(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    print(size.width);
    // تاب أفقي: العرض بين 600 و 900
    return isLandscape && size.width >= mobile && size.height < tablet ;
  }

  // دالة تحقق مما إذا كان الجهاز موبايل أو تاب في الوضع الأفقي أو العمودي
  static bool getDeviceOrientation(BuildContext context) {
    if (isMobileLandscape(context) || isMobilePortrait(context)) {
      // إذا كان الموبايل في الوضع الأفقي أو العمودي
      return true;
    } else if (isTabletPortrait(context) || isTabletLandscape(context)) {
      // إذا كان التاب في الوضع العمودي أو الأفقي
      return false;
    } else {
      // إذا كانت الشاشة أكبر من التاب أو الموبايل
      return false;
    }
  }

  // التحقق إذا كان الجهاز موبايل بغض النظر عن الاتجاه
  static bool isMobile(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // موبايل: عرض الشاشة أصغر من 600px
    return size.width < mobile;
  }

  // التحقق إذا كان الجهاز تاب بغض النظر عن الاتجاه
  static bool isTablet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // تاب: عرض الشاشة بين 600 و 900px
    return size.width >= mobile && size.width < tablet;
  }

  // التحقق إذا كان الجهاز Desktop (أكبر من 900px)
  static bool isDesktop(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // ديسكتوب: عرض الشاشة أكبر من 900px
    return size.width >= tablet;
  }

  // دالة للتحقق مما إذا كان الجهاز موبايل أو تاب (بدون اعتبار الاتجاه)
  static bool isMobileOrTablet(BuildContext context) {
    if (isMobile(context)) {
      Constants.isTablet=false;
      return true;
    } else if (isTablet(context)) {
      Constants.isTablet=true;
      return true;
    } else {
      Constants.isTablet=true;
      return false;
    }
  }
}
