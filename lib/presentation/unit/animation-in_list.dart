import 'package:flutter/material.dart';

// ignore: unused_element
double _getSlideOffset(int index) => (index + 1) * 0.2; // قيمة offset لكل حقل
double _getStart(int index) => index * 0.1; // توقيت بداية الحقل بالنسبة للمدة

Widget buildAnimatedField({required Widget child, required int index
  ,required AnimationController controller}) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: Offset(1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(_getStart(index), _getStart(index) + 0.3,
            curve: Curves.easeOut),
      ),
    ),
    child: FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(_getStart(index), _getStart(index) + 0.3,
              curve: Curves.easeOut),
        ),
      ),
      child: child,
    ),
  );
}
