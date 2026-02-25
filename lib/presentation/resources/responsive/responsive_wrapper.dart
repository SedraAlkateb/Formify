import 'package:flutter/material.dart';
import 'breakpoints.dart';

class AdaptiveRowColumn extends StatelessWidget {
  final Widget left;
  final Widget right;
  final double gap;

  const AdaptiveRowColumn({
    super.key,
    required this.left,
    required this.right,
    this.gap = 16,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        final isMobile = Breakpoints.isMobileLandscape(context);
        final isTabletPortrait = Breakpoints.isTabletLandscape(context);

        if (isTabletPortrait ) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              left,
              SizedBox(height: gap),
              right,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(flex: 7, child: left),
            SizedBox(width: gap),
            Expanded(flex: 5, child: right),
          ],
        );
      },
    );
  }
}
