import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:formify/presentation/survey/bloc/survey_bloc.dart';

Widget questionWidget(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 14),
      Text(
        "Question Text",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
      ),
      const SizedBox(height: 6),
      FormBuilderTextField(
        name: 'question_text',
        decoration: InputDecoration(
          hintText: "Enter question...",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: (val) {

          context.read<SurveyBloc>().add(CreateQuesNameSurveyEvent(val ?? ""));
        },
        validator: (v) {
          if (v == null || v.trim().isEmpty) {
            return "Question cannot be empty";
          }
          return null;
        },
      ),

      const SizedBox(height: 14),
    ],
  );
}
