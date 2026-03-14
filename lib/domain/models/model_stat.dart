import 'package:flutter/material.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/resources/color_manager.dart';

enum StatType { text, statistic, count }
Widget _typeText({required List<UserAnswerStatModel> userAnswer}) {
  return  ListView.separated(
    itemBuilder: (context, index) => Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ColorManager.background,
        borderRadius: BorderRadius.circular(16),
        // border: Border.all(
        //   color: colors.outline.withOpacity(0.1),
        // ),
      ),
      child: Text(userAnswer[index].content),
    ),
    separatorBuilder: (context, index) =>
        SizedBox(height: 10),
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: userAnswer.length,
  );
}
// Widget _typeStatistic({required List<StatisticStatModel> statistic}) {
//   return  ListView.separated(
//     itemBuilder: (context, index) => Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: ColorManager.background,
//         borderRadius: BorderRadius.circular(16),
//         // border: Border.all(
//         //   color: colors.outline.withOpacity(0.1),
//         // ),
//       ),
//       child: Text(userAnswer[index].content),
//     ),
//     separatorBuilder: (context, index) =>
//         SizedBox(height: 10),
//     shrinkWrap: true,
//     physics: NeverScrollableScrollPhysics(),
//     itemCount: userAnswer.length,
//   );
// }
