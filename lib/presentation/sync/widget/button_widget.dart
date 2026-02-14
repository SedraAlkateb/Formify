import 'package:flutter/material.dart';
import 'package:formify/presentation/resources/color_manager.dart';

Widget animatedButton(
    BuildContext context,
    void Function()? onPressed,
    String text,
    ) {
  return _AnimatedButton(onPressed: onPressed, text: text);
}

class _AnimatedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  const _AnimatedButton({this.onPressed, required this.text});

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton> {
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
          final elev = 2.0 + (6.0 * t);
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text(
              widget.text,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_forward_ios, size: 18),


          ],
        ),
      ),
    );
  }
}
