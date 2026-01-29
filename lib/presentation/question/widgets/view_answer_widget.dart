import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
              "Answers",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),

        const SizedBox(height: 10),
        BlocBuilder<SurveyBloc, SurveyState>(

  builder: (context, state) {
  if (state is ViewQuestionState) {
  print("RemoveAnswerAtEvent");
  QuestionModel questionModel = state.questionModel;
  return   questionModel.answers.isEmpty?
  const Text("No answers yet. Tap 'Add Answer' to add one.")
      :
  ListView.separated(
    itemCount: questionModel.answers.length,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    separatorBuilder: (_, __) => const SizedBox(height: 10),
    itemBuilder: (context, index) {
      final String item =
          questionModel.answers[index].title;

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
                context.read<SurveyBloc>().add(
                  CreateAnswerSurveyEvent(index, val ?? ""),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              context.read<SurveyBloc>().add(
                RemoveAnswerAtEvent(index),
              );
            },
          ),
        ],
      );
    },
  );
  }
  return SizedBox();
  }),

      ],
    ),
  );
}
