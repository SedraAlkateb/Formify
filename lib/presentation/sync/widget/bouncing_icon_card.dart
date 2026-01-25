import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:formify/presentation/resources/color_manager.dart';

class BouncingIconCard extends StatefulWidget {
  const BouncingIconCard({super.key});

  @override
  State<BouncingIconCard> createState() => _BouncingIconCardState();
}

class _BouncingIconCardState extends State<BouncingIconCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _angle;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400), // بطيء
    )..repeat(reverse: true);

    // من -6 درجات إلى +6 درجات
    _angle = Tween<double>(begin: -5, end: 5).animate(
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
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: ColorManager.primary,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: AnimatedBuilder(
          animation: _controller,
          child: const Icon(
            Icons.event_note_outlined,
            color: Color(0xffffffff),
            size: 30,
          ),
          builder: (context, child) {
            return Transform.rotate(
              alignment: Alignment.topCenter, // كأنه معلّق من فوق
              angle: _angle.value * (math.pi / 180),
              child: child,
            );
          },
        ),
      ),
    );
  }
}
