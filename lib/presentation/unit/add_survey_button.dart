import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formify/app/constants.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/responsive/font_responseve.dart';
import 'package:formify/presentation/resources/routes_manager.dart';

Widget surveyButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: SizedBox(
      height: Constants.isTablet ? 62 : 58,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.home,
                  (route) => false,
                );
              },
              icon: const Icon(Icons.add_rounded,),
              label: Text(
                "تمت العملية",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: FontResponsive.font(
                    context,
                    mobile: 14,
                    tablet: 18,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primary, // لون الخلفية
                foregroundColor: Colors.white, // لون النص
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, Routes.createSurvey);
              },
              icon: const Icon(Icons.add_rounded),
              label:  Text(
                "استبيان جديد",

                style: TextStyle(
                    fontSize: FontResponsive.font(
                      context,
                      mobile: 14,
                      tablet: 18,
                    ),
                    fontWeight: FontWeight.w800),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
