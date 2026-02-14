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
        "نص السؤال",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
        textAlign: TextAlign.right,
      ),

      const SizedBox(height: 6),

      FormBuilderTextField(
        name: 'question_text',
        textDirection: TextDirection.rtl, // ✅ Arabic input
        decoration: InputDecoration(
          hintText: "أدخل السؤال...",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (val) {
          BlocProvider.of<SurveyBloc>(context)
              .add(CreateQuesNameSurveyEvent(val ?? ""));
        },
        validator: (v) {
          if (v == null || v.trim().isEmpty) {
            return "لا يمكن أن يكون السؤال فارغاً";
          }
          return null;
        },
      ),

      const SizedBox(height: 14),
    ],
  );
}