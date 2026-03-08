import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:formify/domain/models/model_q.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/active_conference/bloc/active_conference_bloc.dart';
import 'package:formify/presentation/question/page/view_answer_question.dart';
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
          child: BlocBuilder<ActiveConferenceBloc, ActiveConferenceState>(
            buildWhen: (previous, current) =>
                current is GetCompletedSurveyLoadingState ||
                current is GetCompletedSurveyErrorState ||
                current is GetCompletedSurveyState,
            builder: (context, state) {
              if (state is GetCompletedSurveyState) {
                final SurveyModel surveyModel =
                    state.surveyUserModel.surveyModel;
                final Map<int, List<AnswerUserSurveyModel>> answer =
                    state.surveyUserModel.answerUser;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ============ بلوك معلومات الاستبيان =============
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 4,
                      ),
                      child:  Text(
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
                    ),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: surveyModel.questions.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 20),
                      itemBuilder: (context, index) {
                        final q = surveyModel.questions[index];
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    q.type.typeAnswerEnglish,
                                    Text(
                                      "${q.order}#",
                                      style: TextStyle(
                                        fontSize: FontResponsive.font(
                                          context,
                                          mobile: 15,
                                          tablet: 19,
                                        ),
                                        color: colors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    q.type.title == "Switch"
                                        ? SizedBox()
                                        : Expanded(
                                            child: Text(
                                              q.title,
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
                              ),
                              const SizedBox(height: 10),
                              answer.containsKey(index)
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: QuestionAnswerPreviewBuilder(
                                        question: q,
                                        initValue: answer[index],
                                      ),
                                    )
                                  : (q.type == QuestionType.switchField)
                                  ? FormBuilderSwitch(
                                      name: "${q.id}02000",
                                      enabled:
                                          false, // الـ switch غير قابل للتغيير
                                      initialValue:
                                          false, // القيمة الأساسية هي false
                                      inactiveThumbColor: ColorManager
                                          .white, // اللون الأحمر عندما تكون false
                                      inactiveTrackColor: ColorManager
                                          .error, // اللون الأحمر للـ track (الخلفية) عندما تكون false
                                      title: Text(
                                        "",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.block_outlined,
                                            color: ColorManager.success,
                                          ),
                                          SizedBox(width: 12),
                                          Text(
                                            "لا يوجد إجابة",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: FontResponsive.font(
                                                context,
                                                mobile: 16,
                                                tablet: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              } else if (state is GetCompletedSurveyErrorState) {
                return errorFullScreen(context);
              } else if (state is GetCompletedSurveyLoadingState) {
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
