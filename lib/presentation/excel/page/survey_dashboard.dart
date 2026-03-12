import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:formify/domain/models/model_q.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/excel/bloc/excel_st_bloc.dart';
import 'package:formify/presentation/excel/widget/chart_widget.dart';
import 'package:formify/presentation/excel/widget/stat_widget.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/responsive/font_responseve.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';

class SurveyDashboardPage extends StatelessWidget {
  SurveyDashboardPage({super.key});

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          "احصائيات الاستبيان",
          style: TextStyle(
            fontSize: FontResponsive.font(context, mobile: 20, tablet: 24),
          ),
        ),
        backgroundColor: colors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: FormBuilder(
          key: _formKey,
          child: BlocBuilder<ExcelStBloc, ExcelStState>(
            builder: (context, state) {
              if (state is SurveyStatisticsSuccess) {
                final List<QuestionsStatisticsModel> surveyStatistics =
                    state.surveyStatistics;
                final MainSurveyModel surveyModel = state.surveyModel;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: ColorManager.border),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "عنوان الاستبيان",
                            style: TextStyle(
                              fontSize: FontResponsive.font(
                                context,
                                mobile: 16,
                                tablet: 20,
                              ),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            surveyModel.title,
                            style: TextStyle(
                              fontSize: FontResponsive.font(
                                context,
                                mobile: 16,
                                tablet: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "وصف الاستبيان",
                            style: TextStyle(
                              fontSize: FontResponsive.font(
                                context,
                                mobile: 16,
                                tablet: 20,
                              ),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            surveyModel.description,
                            style: TextStyle(
                              fontSize: FontResponsive.font(
                                context,
                                mobile: 14,
                                tablet: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    // ============ بلوك الأسئلة داخل Container أبيض =============
                    Text(
                      "الأسئلة",
                      style: TextStyle(
                        fontSize: FontResponsive.font(
                          context,
                          mobile: 20,
                          tablet: 24,
                        ),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: surveyStatistics.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 20),
                      itemBuilder: (context, index) {
                        final q = surveyStatistics[index];
                        return
                          q.question.type == QuestionType.generic?
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 20),

                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: colors.outline.withOpacity(0.1)),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                Icons.generating_tokens_outlined,
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
                          ):
                          StatWidget(
                                q: q,
                            widgetStat:

                                q.question.groupType == 1?
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
                                )
                                    : q.question.type == QuestionType.switchField
                                    ?StatisticsCountBoxes(
                                  data: q.statistics,
                                ): q.question.type == QuestionType.slider
                                    ?StatisticsCountBoxes(
                                  data: q.statistics,
                                ): q.question.groupType == 2?Statistics2ChartCard(
                                  data: q.statistics,
                                ):Statistics3ChartCard( data: q.statistics),
                          );
                      },
                    ),
                  ],
                );
              } else if (state is SurveyStatisticsError) {
                return errorFullScreen(context);
              } else if (state is SurveyStatisticsLoading) {
                return loadingFullScreen(context);
              }
              return SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
