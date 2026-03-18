import 'package:flutter/material.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/unit/animation/animation_widget_in_card.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: ColorManager.white,
        boxShadow: [
          BoxShadow(
            color: ColorManager.primary,
            offset: const Offset(1, 1),
            blurStyle: BlurStyle.outer,
            blurRadius: 2,
            spreadRadius: 2,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            BouncingIconCard(animationWidget: Icon(
              Icons.event_note_outlined,
              color: Color(0xffffffff),
              size: 30,
            ),),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "الاستبيانات المتاحة",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.primary,
                  ),
                ),
                const Text("اختر الاستبيان الذي تود المشاركة فيه"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}