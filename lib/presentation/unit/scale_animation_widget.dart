import 'package:flutter/material.dart';

class ScaleOnScroll extends StatelessWidget {
  final Widget child;
  final int index;
  final ValueNotifier<double> scrollOffset;

  const ScaleOnScroll({
    super.key,
    required this.child,
    required this.index,
    required this.scrollOffset,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: scrollOffset,
      builder: (context, offset, _) {

        double difference = (offset / 180 - index).abs();

        double scale = 1 - (difference * 0.06);
        scale = scale.clamp(0.93, 1.05);

        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
    );
  }
}
