import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:formify/domain/models/model_q.dart';
import 'package:formify/presentation/question/page/view_Question_network.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';

class SurveyInputPage extends StatelessWidget {
  SurveyInputPage({super.key});

  final _formKey = GlobalKey<FormBuilderState>();

  void _submit(BuildContext context, SurveyReadyState s) {
    final fs = _formKey.currentState;
    if (fs == null) return;

    final ok = fs.saveAndValidate(); // <-- validation + save
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى تعبئة الحقول المطلوبة")),
      );
      return;
    }

    // 1) اقرأ قيم الفورم لكل سؤال وارسله للـBloc (SurveySaveAnswerEvent)
    for (int i = 0; i < s.questions.length; i++) {
      final q = s.questions[i];
      final raw = fs.value["q_${q.order}"]; // <-- نفس name داخل FormBuilderField

      context.read<SyncBloc>().add(
        SurveySaveAnswerEvent(index: i, question: q, rawValue: raw),
      );
    }

    // 2) بعد ما خزّنت الإجابات بالـ state.answers، اعمل Submit
    context.read<SyncBloc>().add(const SurveySubmitEvent());
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<SyncBloc, SyncState>(
          listener: (context, state) {
            if (state is SurveySubmitSuccessState) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("تم إرسال الإجابات بنجاح")),
              );
            }
            if (state is SurveySubmitErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("فشل الإرسال: ${state.failure}")),
              );
            }
          },
          builder: (context, state) {
            if (state is SurveyLoadingState || state is SurveySubmittingState) {
              return loadingFullScreen(context);
            }
            if (state is SurveyErrorState) {
              return errorFullScreen(context);
            }

            if (state is SurveyReadyState) {
              return SafeArea(
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ====== معلومات الاستبيان ======
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
                              "عنوان الاستبيان",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(state.surveyName, style: const TextStyle(fontSize: 16)),
                            const SizedBox(height: 20),
                            const Text(
                              "وصف الاستبيان",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(state.surveyDescription, style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),

                      // ====== الأسئلة ======
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
                              "الأسئلة",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: state.questions.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final q = state.questions[index];

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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: 16,
                                            backgroundColor: colors.primary.withOpacity(0.1),
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
                                              ? const SizedBox.shrink()
                                              : Expanded(
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    q.title,
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                if (q.isRequired == true)
                                                  const Text(
                                                    "•",
                                                    style: TextStyle(color: Colors.red, fontSize: 22),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),

                                      // مهم جداً: لازم يبني FormBuilderField
                                      // وباسم: name: "q_${q.order}"
                                      // ويفضل تمرير required لتطبيق validator داخل البيلدر
                                      QuestionPreviewNetworkBuilder(
                                        question: q,

                                      ),

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
                        child: ElevatedButton(
                          onPressed: () => _submit(context, state),
                          child: const Text("إرسال"),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}