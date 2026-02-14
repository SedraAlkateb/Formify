import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/survey/bloc/survey_bloc.dart';

Widget nextWidget(BuildContext context){
  return    SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {
        BlocProvider.of<SurveyBloc>(context).add(AddQuestionEvent());
        Navigator.pushReplacementNamed(context, Routes.viewSurvey);
      },
      child: const Text("التالي"),
    ),
  );
}