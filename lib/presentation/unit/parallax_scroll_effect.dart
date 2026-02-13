import 'package:flutter/material.dart';

class ParallaxItem extends StatelessWidget {
  final Widget child;
  final int index;
  final ScrollController controller;

  const ParallaxItem({
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

        double difference = (offset / 250 - index);
        double translate = difference * 20;

        double scale = 1 - (difference.abs() * 0.05);
        scale = scale.clamp(0.94, 1.05);

        return Transform.translate(
          offset: Offset(0, translate),
          child: Transform.scale(
            scale: scale,
            child: child,
          ),
        );
      },
    );
  }
}
