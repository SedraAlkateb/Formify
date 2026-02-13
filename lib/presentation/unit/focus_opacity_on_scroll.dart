import 'package:flutter/material.dart';

class FocusOpacityOnScroll extends StatelessWidget {
  final Widget child;
  final int index;
  final ValueNotifier<double> scrollOffset;

  const FocusOpacityOnScroll({
    super.key,
    required this.child,
    required this.index,
    required this.scrollOffset,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: scrollOffset,
      builder: (_, offset, __) {

        double difference = (offset / 200 - index).abs();

        double opacity = 1 - (difference * 0.3);
        opacity = opacity.clamp(0.5, 1.0);

        double elevation = 2 + (1 - difference.clamp(0, 1)) * 6;

        return Opacity(
          opacity: opacity,
          child: Material(
            elevation: elevation,
            borderRadius: BorderRadius.circular(12),
            child: child,
          ),
        );
      },
    );
  }
}
