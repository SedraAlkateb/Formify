import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // تضمين حزمة الـ Responsive
import 'package:formify/presentation/resources/color_manager.dart';

class ButtonAnimationWithText extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const ButtonAnimationWithText({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity, // يأخذ كامل العرض المتاح للكارد
        height: 50.h, // ارتفاع متجاوب عمودياً
        decoration: BoxDecoration(
          color: ColorManager.primary,
          borderRadius: BorderRadius.circular(15.r), // حواف دائرية متجاوبة
          boxShadow: [
            BoxShadow(
              color: ColorManager.primary.withOpacity(0.3),
              blurRadius: 8.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp, // خط متكيف تلقائياً مع حجم الشاشة عبر .sp
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}