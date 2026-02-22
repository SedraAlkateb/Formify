import 'package:flutter/material.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/responsive/font_responseve.dart';
import 'package:formify/presentation/resources/responsive/sizer_responseve.dart';

Widget buttonAnimationWithText(
    BuildContext context,
    void Function()? onPressed,
    String text,

    ) {
  return _ButtonAnimationWithText(onPressed: onPressed, text: text);
}

class _ButtonAnimationWithText extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  const _ButtonAnimationWithText({this.onPressed, required this.text});

  @override
  State<_ButtonAnimationWithText> createState() => _ButtonAnimationWithTextState();
}

class _ButtonAnimationWithTextState extends State<_ButtonAnimationWithText> {
  bool _pressed = false;

  void _setPressed(bool v) {
    if (_pressed == v) return;
    setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    // سرعة أعلى + انتقال أخف
    const d = Duration(milliseconds: 110);

    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: _pressed ? 1 : 0),
        duration: d,
        curve: Curves.easeOut,
        builder: (context, t, child) {
          final scale = 1.0 + (0.06 * t); // بدل 1.1 (أخف)
          final glowOpacity = 0.15 + (0.35 * t);

          return Transform.scale(
            scale: scale,
            child: ElevatedButton(
              onPressed: widget.onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primary, // لون الخلفية
                foregroundColor: Colors.white,          // لون النص
                padding:  EdgeInsets.symmetric(vertical: 14.sp),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                minimumSize:  Size(double.infinity, 48.sp),
                shadowColor: ColorManager.primary.withOpacity(glowOpacity),

              ),
              child: child!,
            ),
          );
        },
        // child ثابت لا يعاد بناؤه كل فريم (أهم نقطة للأداء)
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text(
              widget.text,
              style:  TextStyle(fontWeight: FontWeight.bold
                  ,
                fontSize: FontResponsive.font(
                  context,
                  mobile: 18,
                  tablet: 24,
                  desktop: 26,
                ),

              ),
            ),
             SizedBox(width: 6.sp),
             Icon(Icons.arrow_forward_ios, size: 18.sp),


          ],
        ),
      ),
    );
  }
}
