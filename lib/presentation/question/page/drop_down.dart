import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/survey/bloc/survey_bloc.dart';

class DropDownQuestionPage extends StatefulWidget {
  const DropDownQuestionPage({super.key});

  @override
  State<DropDownQuestionPage> createState() => _DropDownQuestionPageState();
}

class _DropDownQuestionPageState extends State<DropDownQuestionPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _optionCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(title: const Text("DropDown Question")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<SurveyBloc, SurveyState>(

          builder: (context, state) {
            SurveyModel surveyModel=BlocProvider.of<SurveyBloc>(context).surveyModel;
            if(state is ViewSurveyState ){
              surveyModel=state.surveyModel;
            }
            return  FormBuilder(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= لوحة التحكم =================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: colorScheme.outline.withOpacity(0.25)),
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
                          Row(
                            children: [
                              Icon(Icons.tune, color: colorScheme.primary),
                              const SizedBox(width: 8),
                              const Text(
                                "Control Panel",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          const Text("Question Text", style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),

                          FormBuilderTextField(
                            name: 'question_text',
                            decoration: InputDecoration(
                              hintText: "Enter question...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onChanged: (val) {
                              context.read<SurveyBloc>().add(
                                CreateQuesNameSurveyEvent(val.toString()),
                              );
                            },
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return "Question cannot be empty";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 14),

                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    final ok = _formKey.currentState?.saveAndValidate() ?? false;
                                    if (!ok) return;
                                    context.read<SurveyBloc>().add(CreateEmptyAnswerSurveyEvent());
                                  },
                                  icon: const Icon(Icons.add),
                                  label: const Text("Add Answer"),
                                ),
                              ),
                              const SizedBox(width: 10),

                              // زر تنظيف (لازم تعمل له Event بالبلوك لو ما موجود)
                              OutlinedButton.icon(
                                onPressed: () {
                                  context.read<SurveyBloc>().add(RemoveLastAnswerEvent());
                                },
                                icon: const Icon(Icons.clear_all),
                                label: const Text("Clear"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ================= قسم الإجابات =================
                    Container(
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
                                "Answers",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          if (surveyModel.questions.isEmpty ||
                              surveyModel.questions.last.answers.isEmpty)
                            const Text("No answers yet. Tap 'Add Answer' to add one.")
                          else
                            ListView.separated(
                              itemCount: surveyModel.questions.last.answers.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (_, __) => const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                // عندك answers عندك String، بس انت ما عم تستخدمه داخل TextField.
                                // الأفضل تربطه بالعرض (initialValue) باستخدام FormBuilderTextField بدل TextField
                                final String item = surveyModel.questions.last.answers[index];

                                return Row(
                                  children: [
                                    Expanded(
                                      child: FormBuilderTextField(
                                        name: "answer_$index",
                                        initialValue: item,
                                        decoration: InputDecoration(
                                          labelText: "Answer ${index + 1}",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        onChanged: (val) {
                                           context.read<SurveyBloc>().add(CreateAnswerSurveyEvent(index, val ?? ""));
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      onPressed: () {
                                        context.read<SurveyBloc>().add(RemoveAnswerAtEvent(index));
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ================= Preview =================
                    const Text(
                      "Preview",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),

                    // ضع هنا preview تبعك (FilterChips / Dropdown ...)

                    const SizedBox(height: 14),
                    if (surveyModel.questions.isEmpty)
                      const Text("No question to preview yet.")
                    else ...[
                      Container(
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
                            // ===== السؤال بالأعلى =====
                            Text(
                              surveyModel.questions.last.title.isEmpty
                                  ? "Question will appear here"
                                  : surveyModel.questions.last.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // ===== Dropdown فيها الإجابات =====
                            FormBuilderDropdown<String>(
                              name: "preview_dropdown",
                              decoration: InputDecoration(
                                hintText: "Select an answer",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              items: (surveyModel.questions.last.answers)
                                  .map(
                                    (a) => DropdownMenuItem<String>(
                                  value: a,
                                  child: Text(a,style: TextStyle(color: ColorManager.black),),
                                ),
                              )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final ok = _formKey.currentState?.saveAndValidate() ?? false;
                          if (!ok) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Fix validation errors first.")),
                            );
                            return;
                          }

                          final values = _formKey.currentState!.value;
                          debugPrint("Form values: $values");
                        },
                        child: const Text("Next"),
                      ),
                    ),
                  ],
                ),
              ),
            );

          },
        ),
      ),
    );
  }
}