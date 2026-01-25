import 'package:flutter/material.dart';
import 'package:formify/presentation/resources/color_manager.dart';

class CardListUpDown extends StatefulWidget {
  const CardListUpDown({super.key});

  @override
  State<CardListUpDown> createState() => _CardListUpDownState();
}

class _CardListUpDownState extends State<CardListUpDown>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _offsetY;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600), // بطيئة وناعمة
    )..repeat(reverse: true);

    _offsetY = Tween<double>(
      begin: -6, // لفوق
      end: 6,    // لتحت
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _offsetY.value), // ↑ ↓
          child: child,
        );
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: ColorManager.primary,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 15),
          child: const Icon(
            Icons.event_note_outlined,
            color: Color(0xffffffff),
            size: 30,
          ),
        ),
      ),
    );
  }
}
