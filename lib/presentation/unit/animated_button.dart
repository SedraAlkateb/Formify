import 'package:flutter/material.dart';
import 'package:formify/presentation/resources/color_manager.dart';

class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const AnimatedButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  double _scale = 1.0;

  void _animateDown() {
    setState(() => _scale = 0.9); // يصغر بشكل واضح
  }

  void _animateUp() {
    setState(() => _scale = 1.05); // تكبير خفيف مثل “بوم”
    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) {
        setState(() => _scale = 1.0); // رجوع طبيعي
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _animateDown(),
      onTapUp: (_) {
        _animateUp();
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutBack,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(MediaQuery.of(context).size.width * 0.7, 45),
            backgroundColor: ColorManager.primary, // لون الخلفية
            foregroundColor: Colors.white,          // لون النص
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
          ),
          onPressed: widget.onPressed,
          child: Text(widget.text, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
