import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/survey/bloc/survey_bloc.dart';

Widget nextWidget(BuildContext context, void Function() fun) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: fun,
      child: const Text("التالي"),
    ),
  );
}