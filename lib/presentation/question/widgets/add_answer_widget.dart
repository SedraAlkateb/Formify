import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/presentation/survey/bloc/survey_bloc.dart';

Widget addAnswerWidget(BuildContext context) {
  return Row(
    children: [
      Expanded(
        child: ElevatedButton.icon(
          onPressed: () {
            context.read<SurveyBloc>().add(CreateEmptyAnswerSurveyEvent());
          },
          icon: const Icon(Icons.add),
          label: const Text("إضافة إجابة"),
        ),
      ),
      const SizedBox(width: 10),

      OutlinedButton.icon(
        onPressed: () {
          context.read<SurveyBloc>().add(RemoveLastAnswerEvent());
        },
        icon: const Icon(Icons.clear_all),
        label: const Text("مسح"),
      ),
    ],
  );
}