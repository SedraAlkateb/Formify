import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:formify/domain/models/model_q.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/survey/bloc/survey_bloc.dart';

class TextQuestionPage extends StatefulWidget {
  const TextQuestionPage({super.key});

  @override
  State<TextQuestionPage> createState() => _TextQuestionPageState();
}

class _TextQuestionPageState extends State<TextQuestionPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,

      appBar: AppBar(title: const Text("Text Question")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<SurveyBloc, SurveyState>(

          builder: (context, state) {
            SurveyModel surveyModel=BlocProvider.of<SurveyBloc>(context).surveyModel;
            if(state is ViewSurveyState ){
              surveyModel=state.surveyModel;
            }
    return FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===================== إعداد السؤال =====================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Question Text",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // نص السؤال
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
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Question cannot be empty";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // اختيار إذا Required أو لا
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Required (Validation)",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Switch(
                          value: BlocProvider.of<SurveyBloc>(context).surveyModel.questions.last.isRequired,
                          activeColor: colorScheme.primary,
                          onChanged: (val) {
                            context.read<SurveyBloc>().add(
                              CreateQuesIsRequiredSurveyEvent(val),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ===================== معاينة الشكل النهائي =====================
              Text(
                "Preview",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onBackground,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(0.4),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Label
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            surveyModel.questions.last.title.isEmpty
                                ? "Question label will appear here"
                                :  surveyModel.questions.last.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                        if ( surveyModel.questions.last.isRequired) ...[
                          const SizedBox(width: 4),
                          Text(
                            "*",
                            style: TextStyle(
                              color: colorScheme.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    // حقل التعبئة (preview)
                    FormBuilderTextField(
                      name: 'answer_text',
                      decoration: InputDecoration(
                        hintText: "Answer...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if ( surveyModel.questions.last.isRequired &&
                            (value == null || value.trim().isEmpty)) {
                          return "Answer cannot be empty";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        final isValid =
                            _formKey.currentState?.saveAndValidate() ?? false;
                        if (!isValid) {
                          // إذا Required والنص فاضي أو أي خطأ -> رسالة
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please fix validation errors before continuing.",
                              ),
                            ),
                          );
                          return;
                        }
                      },
                      child: const Text("Test"),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // ===================== زر Next =====================
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {

                    Navigator.pushNamed(context, Routes.viewSurvey);
                  },
                  child: const Text("Next"),
                ),
              ),
            ],
          ),
        );
  },
),
      ),
    );
  }
}
