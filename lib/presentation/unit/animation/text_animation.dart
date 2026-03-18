import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class TextAnimation extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final Duration speed;

  const TextAnimation({
    super.key,
    required this.text,
    this.fontSize = 22,
    this.color = Colors.white,
    this.speed = const Duration(milliseconds: 50),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      isRepeatingAnimation: false,
      animatedTexts: [
        TypewriterAnimatedText(
          text,
          textAlign: TextAlign.center,
          textStyle: TextStyle(
            fontSize: fontSize,
            color: color,
            fontWeight: FontWeight.w600,
          ),
          speed: speed,
        ),
      ],
    );
  }
}

class SmoothSideText extends StatefulWidget {
  final String text;
  final double fontSize;
  final Color color;
  final Duration duration;

  const SmoothSideText({
    super.key,
    required this.text,
    this.fontSize = 22,
    this.color = Colors.black,
    this.duration = const Duration(milliseconds: 250),
  });

  @override
  State<SmoothSideText> createState() => _SmoothSideTextState();
}

class _SmoothSideTextState extends State<SmoothSideText>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // from left (-0.3) to center (0)
    _slide = Tween<Offset>(
      begin: const Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant SmoothSideText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.text != widget.text) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: Text(
        widget.text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: widget.fontSize,
          color: widget.color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
class SmoothBottomText extends StatefulWidget {
  final String text;
  final double fontSize;
  final Color color;
  final Duration duration;
  final Duration delay;
final FontWeight fontWeight;
  const SmoothBottomText({
    super.key,
    required this.text,
    this.fontSize = 22,
    this.color = Colors.black,
    this.duration = const Duration(milliseconds: 450),
    this.delay = Duration.zero,
    this.fontWeight=FontWeight.w300
  });

  @override
  State<SmoothBottomText> createState() => _SmoothBottomTextState();
}

class _SmoothBottomTextState extends State<SmoothBottomText>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.26), // من تحت لفوق
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Text(
          widget.text,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: widget.fontSize,
            color: widget.color,
            fontWeight:widget.fontWeight ,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
