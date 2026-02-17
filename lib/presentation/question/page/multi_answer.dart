import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:formify/domain/models/model_q.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/question/page/view_Question.dart';
import 'package:formify/presentation/question/widgets/add_answer_widget.dart';
import 'package:formify/presentation/question/widgets/next_widget.dart';
import 'package:formify/presentation/question/widgets/question_widget.dart';
import 'package:formify/presentation/question/widgets/view_answer_widget.dart';
import 'package:formify/presentation/survey/bloc/survey_bloc.dart';

class MultiAnswerPage extends StatelessWidget {
  MultiAnswerPage({super.key});
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text("${BlocProvider.of<SurveyBloc>(context).question.type.title} سؤال"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FormBuilder(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= Control Panel =================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: colorScheme.outline.withOpacity(0.25),
                    ),
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
                      addAnswerWidget(context),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ================= Answers Section =================
                viewAnswerWidget(context),

                const SizedBox(height: 14),

                // ================= Preview =================
                const Text(
                  "معاينة",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 8),

                const SizedBox(height: 14),
                BlocBuilder<SurveyBloc, SurveyState>(
                  builder: (context, state) {
                    if (state is ViewQuestionState) {
                      QuestionModel questionModel = state.questionModel;
                      return questionModel.title.isEmpty
                          ? const Text("لا يوجد سؤال للمعاينة بعد.")
                          : Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: colorScheme.outline.withOpacity(0.25),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ===== Question title =====
                            Text(
                              questionModel.title.isEmpty
                                  ? "سيظهر السؤال هنا"
                                  : questionModel.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            const SizedBox(height: 12),
                            QuestionPreviewBuilder(question: questionModel),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),

                const SizedBox(height: 20),
                nextWidget(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}