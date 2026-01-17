import 'package:flutter/material.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/resources/color_manager.dart';

Widget surveyListWidget(MainSurveyModel survey) {
  return Card(
    shadowColor: ColorManager.white,
    color: ColorManager.white,
    shape: RoundedRectangleBorder(
      side: BorderSide(color: ColorManager.fieldBackground, width: 2),
      borderRadius: BorderRadius.circular(12),
    ),
   // margin: const EdgeInsets.symmetric(vertical: 8),
    elevation: 1,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
         Row(
           children: [
             Card(
               margin: const EdgeInsets.all(4),
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
               elevation: 4,
               color:survey.color.contains("0x")? Color(int.parse(survey.color)):Colors.pinkAccent,
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Icon(Icons.description_outlined, color: Color(0xffffffff)),
               ),
             ),
             const SizedBox(width: 10),
             Column(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(
                   survey.title,
                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                 ),
                 Text(
                   survey.description,
                   style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                   maxLines: 2, // تحديد عدد الأسطر المسموح بها
                   overflow: TextOverflow
                       .ellipsis, // إضافة نقاط في نهاية النص إذا كان طويلًا
                 ),
               ],
             ),
           ],
         ),
          Icon(

              Icons.arrow_forward_ios,color: ColorManager.black.withOpacity(0.2),size: 20,)
        ],
      ),
    ),
  );
}
