import 'package:flutter/material.dart';
import 'package:formify/domain/models/model_q.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/responsive/font_responseve.dart';

class StatWidget extends StatelessWidget {
  final QuestionsStatisticsModel q;
  final Widget widgetStat;
  const StatWidget({super.key, required this.q, required this.widgetStat});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outline.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Icon(
                q.question.groupType == 1
                    ? Icons.mode_comment_outlined
                    : q.question.type == QuestionType.switchField
                    ? Icons.toggle_on_outlined
                    : q.question.type == QuestionType.slider
                    ? Icons.linear_scale
                    : q.question.groupType == 2
                    ?  Icons.bar_chart_outlined
                    : Icons.try_sms_star_outlined,
                color: ColorManager.splash1,
              ),
              SizedBox(width: 10),

              Flexible(
                child: Text(
                  q.question.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                    fontSize: FontResponsive.font(
                      context,
                      mobile: 18,
                      tablet: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "عدد الإجابات",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: colors.onSurface,
                  fontSize: FontResponsive.font(
                    context,
                    mobile: 14,
                    tablet: 18,
                  ),
                ),
              ),
              Text(
                " : ",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: colors.onSurface,
                  fontSize: FontResponsive.font(
                    context,
                    mobile: 20,
                    tablet: 24,
                  ),
                ),
              ),
              Text(
                q.statistics.length.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: colors.onSurface,
                  fontSize: FontResponsive.font(
                    context,
                    mobile: 14,
                    tablet: 18,
                  ),
                ),
              ),
              Text(
                q.userAnswers.length.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: colors.onSurface,
                  fontSize: FontResponsive.font(
                    context,
                    mobile: 14,
                    tablet: 18,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          widgetStat,
          Align(
            alignment: Alignment.bottomLeft,
            child: q.question.type.typeAnswerEnglish,
          ),
        ],
      ),
    );
  }
}
