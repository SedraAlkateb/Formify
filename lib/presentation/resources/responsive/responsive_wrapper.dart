import 'package:flutter/material.dart';
import 'breakpoints.dart';

class AdaptiveRowColumn extends StatelessWidget {
  final Widget left;   // المحتوى (نصوص/حقول/قائمة...)
  final Widget right;  // assets (صور/رسوم/إلخ)
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
        final isTablet = Breakpoints.isTablet(c.maxWidth) || Breakpoints.isDesktop(c.maxWidth);

        if (!isTablet) {
          // Mobile: تحت بعض
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              left,
              SizedBox(height: gap),
              right,
            ],
          );
        }

        // Tablet/Desktop: جنب بعض
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