import 'package:flutter/material.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/responsive/font_responseve.dart';
import 'package:formify/presentation/resources/values_manager.dart';

class HeaderCard extends StatelessWidget {
  const HeaderCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.all(AppPadding.p14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: AppSize.s45,
            height:  AppSize.s45,
            decoration: BoxDecoration(
              color: ColorManager.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.link_rounded, color: ColorManager.primary),
          ),
           SizedBox(width: AppSize.s12),
           Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "اختر الاستبيانات",
                  style: TextStyle(  fontSize: FontResponsive.font(
                    context,
                    mobile: 16,
                    tablet: 20,
                  ), fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 4),
                Text(
                  "فعّل السويتش لربط الاستبيان مع المؤتمر.",
                  style: TextStyle(  fontSize: FontResponsive.font(
                    context,
                    mobile: 13,
                    tablet: 17,
                  ), color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(

            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(

              color: ColorManager.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.add_rounded, color: ColorManager.primary),
          ),
        ],
      ),
    );
  }
}
