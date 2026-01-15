import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/question/widgets/next_widget.dart';
import 'package:formify/presentation/question/widgets/question_widget.dart';
import 'package:formify/presentation/survey/bloc/survey_bloc.dart';

class TextQuestionPage extends StatelessWidget {
  TextQuestionPage({super.key});

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return  Scaffold(
      backgroundColor: colorScheme.background,

      appBar: AppBar(title: const Text("Text Question")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<SurveyBloc, SurveyState>(
          builder: (context, state) {
            SurveyModel surveyModel = BlocProvider.of<SurveyBloc>(
              context,
            ).surveyModel;
            if (state is ViewSurveyState) {
              surveyModel = state.surveyModel;
            }
            return FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                questionWidget(context),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Required (Validation)",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                    Switch(
                                      value:
                                           BlocProvider.of<SurveyBloc>(
                                        context,
                                      ).question.isRequired,
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
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                         BlocProvider.of<SurveyBloc>(
                                        context,
                                      ).question.title.isEmpty
                                            ? "Question label will appear here"
                                            :  BlocProvider.of<SurveyBloc>(
                                        context,
                                      ).question.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                    ),
                                    if ( BlocProvider.of<SurveyBloc>(
                                      context,
                                    ).question
                                        .isRequired) ...[
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
                                FormBuilderTextField(
                                  name: 'answer_text',
                                  decoration: InputDecoration(
                                    hintText: "Answer...",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator: (value) {
                                    if ( BlocProvider.of<SurveyBloc>(
                                        context,
                                      ).question.isRequired &&
                                        (value == null ||
                                            value.trim().isEmpty)) {
                                      return "Answer cannot be empty";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    final isValid =
                                        _formKey.currentState
                                            ?.saveAndValidate() ??
                                        false;
                                    if (!isValid) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Please fix validation errors before continuing.",
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text("Test"),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  nextWidget(context)
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
