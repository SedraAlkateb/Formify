import 'package:flutter/material.dart';

Widget nextWidget(BuildContext context, void Function() fun) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: fun,
      child: const Text("التالي"),
    ),
  );
}