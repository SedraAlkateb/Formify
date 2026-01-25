import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';

Widget surveyButton(BuildContext context){
  return  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: SizedBox(

      height: 52,
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
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                "تمت العملية",
                style: TextStyle(fontWeight: FontWeight.w800),
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
          SizedBox(width: 10,),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, Routes.createSurvey);
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                "استبيان جديد",
                style: TextStyle(fontWeight: FontWeight.w800),
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