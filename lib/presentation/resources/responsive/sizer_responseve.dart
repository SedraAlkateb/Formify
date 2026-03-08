import 'package:flutter/material.dart';

class Sizer {
  static late double _w;
  static late double _h;
  static late bool _isTabletOrDesktop;

  static void init(BuildContext context) {
    final s = MediaQuery.of(context).size;
    _w = s.width;
    _h = s.height;

    // اعتبر tablet من 600 وفوق (عدّل الرقم حسب مشروعك)
    _isTabletOrDesktop = _w >= 600;
  }

  /// % من عرض الشاشة (ثابت للموبايل)
  static double w(double percent) =>
      _w * (percent / 100);

  /// % من ارتفاع الشاشة (ثابت للموبايل)
  static double h(double percent) =>
      _h * (percent / 100);

  /// ✅ Mobile: لا تغيّر شيء
  /// ✅ Tablet/Desktop: كبّر بشكل محسوب
  static double sp(double value) {
    if (!_isTabletOrDesktop) return value; // Mobile -> نفس الرقم

    final shortest = (_w < _h) ? _w : _h;

    // baseline للتابلت (مثلاً 768) لتكون الزيادة منطقية
    final scale = (shortest / 768.0).clamp(1.0, 1.35);

    return value * scale;
  }

  static double r(double value) => sp(value);

  static EdgeInsets p(double all) => EdgeInsets.all(sp(all));
  static EdgeInsets px(double x) => EdgeInsets.symmetric(horizontal: sp(x));
  static EdgeInsets py(double y) => EdgeInsets.symmetric(vertical: sp(y));
  static EdgeInsets pxy(double x, double y) =>
      EdgeInsets.symmetric(horizontal: sp(x), vertical: sp(y));
}

/// Extensions
extension SizerExt on num {
  double get sp => Sizer.sp(toDouble());
  double get r => Sizer.r(toDouble());
  double get vw => Sizer.w(toDouble());
  double get vh => Sizer.h(toDouble());
}