import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:formify/domain/models/model_q.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/survey/bloc/survey_bloc.dart';

Widget viewAnswerWidget(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: colorScheme.outline.withOpacity(0.25)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.list_alt, color: colorScheme.primary),
            const SizedBox(width: 8),
            const Text(
              "الإجابات",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 10),
        BlocBuilder<SurveyBloc, SurveyState>(
          builder: (context, state) {
            if (state is ViewQuestionState) {
              QuestionModel questionModel = state.questionModel;

              return questionModel.answers.isEmpty
                  ? const Text(
                'لا توجد إجابات بعد. اضغط على "إضافة إجابة" لإضافة واحدة.',
              )
                  : ListView.separated(
                itemCount: questionModel.answers.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final answerModel = questionModel.answers[index];

                  return Column(
                    children: [
                      Row(
                        children: [
                          // ✅ Radio لاختيار الإجابة
                          Radio<int>(
                            value: index,
                            groupValue: questionModel.value,
                            onChanged: (v) {
                              if (v == null) return;

                              // ✅ إرسال الإيفنت (أنت قلت إنك ضفته)
                              context
                                  .read<SurveyBloc>()
                                  .add(SelectValueAnswerEvent(v));

                              // ✅ هنا تحصل على AnswerModel المختار
                              final selectedAnswerModel =
                              questionModel.answers[v];
                              // استخدمه كما تريد (تخزين/عرض/ارسال...)
                              // print(selectedAnswerModel.title);
                            },
                          ),

                          Expanded(
                            child: FormBuilderTextField(
                              name: "answer_$index",
                              initialValue: answerModel.title,
                              textDirection: TextDirection.rtl,
                              decoration: InputDecoration(
                                labelText: "الإجابة ${index + 1}",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onChanged: (val) {
                                context.read<SurveyBloc>().add(
                                  CreateAnswerSurveyEvent(
                                    index,
                                    val ?? "",
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () {
                                  context.read<SurveyBloc>().add(
                                    RemoveAnswerAtEvent(index),
                                  );
                                },
                              ),

                              // ✅ الزر الثاني صار "اختيار" بدل حذف
                              IconButton(
                                icon: Icon(
                                  questionModel.value ==
                                      index
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                ),
                                onPressed: () {
                                  context
                                      .read<SurveyBloc>()
                                      .add(SelectValueAnswerEvent(index));

                                  final selectedAnswerModel =
                                  questionModel.answers[index];
                                  // استخدمه كما تريد
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      ((questionModel.type ==
                          QuestionType.multipleChoice) ||
                          questionModel.type == QuestionType.checkbox)
                          ? TextButton(
                        onPressed: () {
                          BlocProvider.of<SurveyBloc>(
                            context,
                          ).add(PickAnswerImageEvent(index));
                        },
                        child: const Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            Text("إضافة صورة"),
                            Icon(Icons.add),
                          ],
                        ),
                      )
                          : const SizedBox(),
                    ],
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ],
    ),
  );
}