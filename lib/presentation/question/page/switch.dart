import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/question/widgets/question_widget.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/survey/bloc/survey_bloc.dart';

class SwitchQuestionPage extends StatelessWidget {
  SwitchQuestionPage({super.key});

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,

      appBar: AppBar(title: const Text("Switch Question")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<SurveyBloc, SurveyState>(
          builder: (context, state) {
            context.read<SurveyBloc>().add(CreateBoolAnswerSurveyEvent());

            SurveyModel surveyModel = BlocProvider.of<SurveyBloc>(
              context,
            ).surveyModel;
            if (state is ViewSurveyState) {
              surveyModel = state.surveyModel;
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
                    child: questionWidget(context),
                  ),

                  const SizedBox(height: 24),
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
                        FormBuilderSwitch(
                          title: Text(
                            surveyModel.questions.last.title.isEmpty
                                ? "Question label will appear here"
                                : surveyModel.questions.last.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),

                          name: 'answer_text',
                          decoration: InputDecoration(
                            hintText: "Answer...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (surveyModel.questions.last.isRequired &&
                                (value == null)) {
                              return "Answer cannot be empty";
                            }
                            return null;
                          },

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
