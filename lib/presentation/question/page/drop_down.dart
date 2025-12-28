import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/question/widgets/add_answer_widget.dart';
import 'package:formify/presentation/question/widgets/question_widget.dart';
import 'package:formify/presentation/question/widgets/view_answer_widget.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/survey/bloc/survey_bloc.dart';

class DropDownQuestionPage extends StatelessWidget {
   DropDownQuestionPage({super.key});
  final _formKey = GlobalKey<FormBuilderState>();
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
                          questionWidget(context),

                         addAnswerWidget(context)
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ================= قسم الإجابات =================
                 viewAnswerWidget(context, surveyModel),

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
                          Navigator.pushNamed(context, Routes.viewSurvey);

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