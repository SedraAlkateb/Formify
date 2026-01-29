import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:formify/domain/models/model_q.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/question/page/view_Question.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/survey/bloc/survey_bloc.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';

class ViewSurvey extends StatelessWidget {
  ViewSurvey({super.key});

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text("add other question"),
        backgroundColor: colors.primary,
        leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () async {
            Navigator.pushNamed(context, Routes.createQuesSurvey);
          },
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: FormBuilder(
          key: _formKey,
          child: BlocBuilder<SurveyBloc, SurveyState>(
            buildWhen: (previous, current) =>
                current is ViewSurveyErrorState ||
                current is ViewSurveyLoadingState ||
                current is ViewSurveyState,
            builder: (context, state) {
              if (state is ViewSurveyState) {
                final SurveyModel surveyModel = state.surveyModel;
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
                          const Text(
                            "Survey Title",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            surveyModel.title,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Survey Description",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            surveyModel.description,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    // ============ بلوك الأسئلة داخل Container أبيض =============
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: ColorManager.border),
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
                          const Text(
                            "Questions",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),

                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: surveyModel.questions.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final q = surveyModel.questions[index];
                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: colors.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: colors.outline.withOpacity(0.2),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 16,
                                          backgroundColor: colors.primary
                                              .withOpacity(0.1),
                                          child: Text(
                                            "${q.order}",
                                            style: TextStyle(
                                              color: colors.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        q.type.title == "Switch"
                                            ? SizedBox()
                                            : Expanded(
                                                child: Text(
                                                  q.title,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: colors.onSurface,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    QuestionPreviewBuilder(question: q),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: BlocListener<SurveyBloc, SurveyState>(
                        listener: (context, state) {
                          if (state is CreateSurveyWithQuestionErrorState) {
                            error(
                              context,
                              state.failure.massage,
                              state.failure.code,
                            );
                          } else if (state
                              is CreateSurveyWithQuestionLoadingState) {
                            loading(context);
                          } else if (state is CreateSurveyWithQuestionState) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              Routes.home,
                              (route) => false,
                            );
                          }
                        },
                        child: ElevatedButton(
                          onPressed: () {
                            // final isValid =
                            //     _formKey.currentState?.saveAndValidate() ?? false;
                            //
                            // if (!isValid) {
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(
                            //       content: Text(
                            //         "Please fix validation errors before submitting.",
                            //       ),
                            //     ),
                            //   );
                            //   return;
                            // }
                            //    final values = _formKey.currentState!.value;

                            BlocProvider.of<SurveyBloc>(
                              context,
                            ).add(CreateSurveyWithQuestionEvent());
                          },
                          child: const Text("Submit"),
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is ViewSurveyErrorState) {
                return errorFullScreen(context);
              } else if (state is ViewSurveyLoadingState) {
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
