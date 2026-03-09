import 'package:flutter/material.dart';
import 'package:formify/domain/models/model_q.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/excel/widget/chart_widget.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/responsive/font_responseve.dart';

class StatWidget1 extends StatelessWidget {
  final QuestionsStatisticsModel q;
  const StatWidget1({super.key,required this.q});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Icon(
                Icons.mode_comment_outlined,
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
          const SizedBox(height: 10),
          ListView.separated(
            itemBuilder: (context, index) => Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: ColorManager.background,
                borderRadius: BorderRadius.circular(16),
                // border: Border.all(
                //   color: colors.outline.withOpacity(0.1),
                // ),
              ),
              child: Text(q.userAnswers[index].content),
            ),
            separatorBuilder: (context, index) =>
                SizedBox(height: 10),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: q.userAnswers.length,
          ),
          SizedBox(height: 15),
          Align(
            alignment: Alignment.bottomLeft,
            child: q.question.type.typeAnswerEnglish,
          ),
        ],
      ),
    );
  }
}
class StatWidget2 extends StatelessWidget {
  final QuestionsStatisticsModel q;
  const StatWidget2({super.key,required this.q});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Icon(

                Icons.bar_chart_outlined
                ,
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
            ],
          ),
          SizedBox(height: 15),
          Statistics2ChartCard( data: q.statistics),
          Align(
            alignment: Alignment.bottomLeft,
            child: q.question.type.typeAnswerEnglish,
          ),
        ],
      ),
    );
  }
}
class StatWidget3 extends StatelessWidget {
  final QuestionsStatisticsModel q;
  const StatWidget3({super.key,required this.q});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Icon(
                Icons.show_chart_rounded
                ,
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
            ],
          ),
          SizedBox(height: 15),
          q.statistics.isNotEmpty?
          Statistics3ChartCard( data: q.statistics):SizedBox(),
          Align(

            alignment: Alignment.bottomLeft,
            child: q.question.type.typeAnswerEnglish,
          ),
        ],
      ),
    );
  }
}
