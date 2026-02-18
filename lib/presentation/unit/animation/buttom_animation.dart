import 'package:flutter/material.dart';
import 'package:formify/presentation/resources/color_manager.dart';

Widget bottomAnimation(
    BuildContext context,
    void Function()? onPressed,
    Widget widgetButton
    ) {
  return _BottomAnimation(onPressed: onPressed,widgetButton: widgetButton,);
}

class _BottomAnimation extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget widgetButton;

  const _BottomAnimation({this.onPressed,required this.widgetButton});

  @override
  State<_BottomAnimation> createState() => _BottomAnimationState();
}

class _BottomAnimationState extends State<_BottomAnimation> {
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
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                minimumSize: const Size(double.infinity, 48),
                shadowColor: ColorManager.primary.withOpacity(glowOpacity),

              ),
              child: child!,
            ),
          );
        },
        // child ثابت لا يعاد بناؤه كل فريم (أهم نقطة للأداء)
        child:widget.widgetButton
      ),
    );
  }
}
