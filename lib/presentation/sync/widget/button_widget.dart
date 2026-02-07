import 'package:flutter/material.dart';
import 'package:formify/presentation/resources/color_manager.dart';

Widget animatedButton(BuildContext context, void Function()? onPressed,String text) {
  return _AnimatedButton(onPressed: onPressed,text:text ,);
}

class _AnimatedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  const _AnimatedButton({this.onPressed,required this.text});

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;

  late final AnimationController _glowController;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _glow = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  void _setPressed(bool v) {
    if (_pressed == v) return;
    setState(() => _pressed = v);
    v ? _glowController.repeat(reverse: true) : _glowController.stop();
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: AnimatedBuilder(
        animation: _glowController,
        builder: (context, _) {
          return ElevatedButton(
            onPressed: widget.onPressed,
            style: ButtonStyle(
              backgroundColor:
              MaterialStateProperty.all(ColorManager.primary),
              minimumSize: MaterialStateProperty.all(
                const Size(double.infinity, 48), // 👈 زر أقصر
              ),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(vertical: 12),
              ),
              elevation: MaterialStateProperty.all(_pressed ? 8 : 2),
              shadowColor: MaterialStateProperty.all(
                ColorManager.primary.withOpacity(_glow.value),
              ),
            ),
            child: AnimatedScale(
              scale: _pressed ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.text,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18, // 👈 أصغر
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward_ios, size: 18),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
