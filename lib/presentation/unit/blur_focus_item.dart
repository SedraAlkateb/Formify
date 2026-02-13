import 'dart:ui';

import 'package:flutter/material.dart';

class BlurFocusItem extends StatelessWidget {
  final Widget child;
  final int index;
  final ScrollController controller;

  const BlurFocusItem({
    super.key,
    required this.child,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        double offset = controller.hasClients ? controller.offset : 0;
        double difference = (offset / 250 - index).abs();

        double blur = (difference * 5).clamp(0, 5);
        double scale = 1 - (difference * 0.05);
        scale = scale.clamp(0.95, 1.05);

        return Transform.scale(
          scale: scale,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: blur,
              sigmaY: blur,
            ),
            child: child,
          ),
        );
      },
    );
  }
}
