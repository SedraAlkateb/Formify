import 'package:flutter/material.dart';
import 'package:formify/presentation/resources/color_manager.dart';

class BouncingIconCard extends StatefulWidget {
  const BouncingIconCard({super.key});

  @override
  _BouncingIconCardState createState() => _BouncingIconCardState();
}

class _BouncingIconCardState extends State<BouncingIconCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // مدة الحركة بطيئة
      vsync: this,
    )..repeat(reverse: true); // الحركة تتكرر للأمام والخلف

    // زيادة المسافة بحيث تكون الحركة واضحة
    _animation = Tween<Offset>(begin: Offset(0, 0), end: Offset(0.2, 0)) // حركة على المحور الأفقي
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)); // حركة سريعة وبطيئة
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: ColorManager.primary,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: _animation.value, // تطبيق الحركة من اليمين لليسار
              child: Icon(
                Icons.sticky_note_2_outlined,
                color: Color(0xffffffff),
                size: 30,
              ),
            );
          },
        ),
      ),
    );
  }
}
