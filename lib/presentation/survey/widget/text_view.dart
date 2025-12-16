import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

Future<Widget>  textView(int index) async {
  return FormBuilderTextField(
    name: "q_${index + 1}",
    decoration: InputDecoration(
      hintText: "Answer...",
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
// إن أردت جعلها Required أضف Validator هنا
    validator: FormBuilderValidators.required(
      errorText: "This question is required",
    ),
  );
}