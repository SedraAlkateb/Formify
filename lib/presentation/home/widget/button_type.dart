import 'package:flutter/material.dart';

// class ButtonType extends StatelessWidget {
//   const ButtonType({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return  Container(
//       child:
//     Column(
//       children: [
//         Text(""),
//
//       ],
//     )
//     );
//
//   }
// }
import 'package:flutter/material.dart';

class ButtonType extends StatelessWidget {
  final String title;          // النص الأساسي
  final String? subtitle;      // رقم أو كلمة تحتها (اختياري)
  final Widget? icon;          // صورة أو أي Widget (اختياري)
  final double size;           // حجم المربع
  final VoidCallback onTap;    // الفعل عند الضغط

  const ButtonType({
    super.key,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.icon,
    this.size = 90, // يمكنك التكبير لاحقاً
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary; // Primary ديناميكي

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: primary.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 6, // ميزة Flutter 3.24+
          children: [

            if (icon != null) icon!, // صورة *اختيارية*

            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
            ),

            if (subtitle != null)
              Text(
                subtitle!,
                style: TextStyle(color: Colors.white.withOpacity(.9), fontSize: 14),
              ),
          ],
        ),
      ),
    );
  }
}
