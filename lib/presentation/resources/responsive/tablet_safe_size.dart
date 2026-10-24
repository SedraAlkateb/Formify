import 'package:flutter_screenutil/flutter_screenutil.dart' as su;

/// ScreenUtil مصمَّم على 360dp فيتضخم على التابلت؛ هنا نعتمد القياس الفعلي
/// (1:1) على الشاشات العريضة ونبقي التحجيم على الموبايل كما هو.
/// للاستخدام بدل ScreenUtil: استورد هذا الملف وأخفِ SizeExtension من الحزمة.
extension SizeExtension on num {
  bool get _isTablet {
    final util = su.ScreenUtil();
    final shortest = util.screenWidth < util.screenHeight
        ? util.screenWidth
        : util.screenHeight;
    return shortest >= 600;
  }

  double get w => _isTablet ? toDouble() : su.ScreenUtil().setWidth(this);
  double get h => _isTablet ? toDouble() : su.ScreenUtil().setHeight(this);
  double get r => _isTablet ? toDouble() : su.ScreenUtil().radius(this);
  double get sp => _isTablet ? toDouble() : su.ScreenUtil().setSp(this);
}
