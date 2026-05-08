import 'package:flutter/material.dart';

// ignore: unused_element
double _getSlideOffset(int index) => (index + 1) * 0.2;

// توقيت بداية الحقل: نضمن أنها لا تتجاوز 1.0
double _getStart(int index) => (index * 0.1).clamp(0.0, 1.0);

Widget buildAnimatedField({
  required Widget child,
  required int index,
  required AnimationController controller
}) {
  // حساب نقطة البداية والنهاية مع التأكد من بقائهما ضمن النطاق [0.0 - 1.0]
  final double start = _getStart(index);
  final double end = (start + 0.3).clamp(0.0, 1.0);

  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          start,
          end,
          curve: Curves.easeOut,
        ),
      ),
    ),
    child: FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(
            start,
            end,
            curve: Curves.easeOut,
          ),
        ),
      ),
      child: child,
    ),
  );
}