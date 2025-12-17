import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/model_q.dart';

class QuestionPreviewBuilder extends StatelessWidget {
  final QuestionModel question;

  const QuestionPreviewBuilder({super.key, required this.question});

  @override
  @override
  Widget build(BuildContext context) {
    switch (question.type) {

    /// ================= TEXT =================
      case QuestionType.text:
        return FormBuilderTextField(
          name: "q_${question.order}",
          decoration: InputDecoration(
            hintText: "Answer...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: question.isRequired == true
              ? FormBuilderValidators.required(
            errorText: "This question is required",
          )
              : null,
        );

    /// ================= DROPDOWN =================
      case QuestionType.dropdown:
        return FormBuilderDropdown<String>(
          name: "q_${question.order}",
          decoration: InputDecoration(
            hintText: "Select an answer",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: question.answers
              .map((a) => DropdownMenuItem(value: a, child: Text(a)))
              .toList(),
        );

    /// ================= MULTIPLE CHOICE (RADIO) =================
      case QuestionType.multipleChoice:
        return FormBuilderRadioGroup<String>(
          name: "q_${question.order}",
          options: question.answers
              .map((a) => FormBuilderFieldOption(value: a))
              .toList(),
          validator: question.isRequired == true
              ? FormBuilderValidators.required()
              : null,
        );

    /// ================= CHECKBOX =================
      case QuestionType.checkbox:
        return FormBuilderCheckboxGroup<String>(
          name: "q_${question.order}",
          options: question.answers
              .map((a) => FormBuilderFieldOption(value: a))
              .toList(),
          validator: question.isRequired == true
              ? FormBuilderValidators.minLength(1,
              errorText: "Select at least one option")
              : null,
        );

    /// ================= SWITCH =================
      case QuestionType.switchField:
        return FormBuilderSwitch(
          name: "q_${question.order}",
          title: Text(question.title ?? "Enable"),
          initialValue: false,
        );

    /// ================= DATE & TIME =================
      case QuestionType.dateTime:
        return FormBuilderDateTimePicker(
          name: "q_${question.order}",
          decoration: const InputDecoration(labelText: "Select date"),
          inputType: InputType.both,
          validator: question.isRequired == true
              ? FormBuilderValidators.required()
              : null,
        );

    /// ================= SLIDER =================
      case QuestionType.slider:
        return
          SizedBox();

        //   FormBuilderSlider(
        //   name: "q_${question.order}",
        //   min: double.parse(question.answers[0]),
        //   max: double.parse(question.answers[0]) ?? 100,
        //   divisions: question.step != null
        //       ? ((question.max! - question.min!) ~/ question.step!)
        //       : null,
        //   initialValue: question.min ?? 0,
        // );

    /// ================= RANGE SLIDER =================
      case QuestionType.rangeSlider:
        return FormBuilderRangeSlider(
          name: "q_${question.order}",
          min: double.parse(question.answers[0]),
          max: double.parse(question.answers[1]),
          initialValue: RangeValues(
            double.parse(question.answers[0]),
            double.parse(question.answers[1]),
          ),
        );

    /// ================= FILE UPLOAD =================
      case QuestionType.fileUpload:
       return SizedBox();
    //FormBuilde(
        //   name: "q_${question.order}",
        //   decoration: const InputDecoration(labelText: "Upload file"),
        //   maxFiles: 1,
        // );

    /// ================= SIGNATURE =================
      case QuestionType.signature:
        return SizedBox();
        //
        //   FormBuilderSignaturePad(
        //   name: "q_${question.order}",
        //   decoration: const InputDecoration(labelText: "Signature"),
        //   backgroundColor: Colors.grey.shade200,
        // );

    /// ================= COLOR PICKER =================
      case QuestionType.colorPicker:
        return SizedBox();

        //   FormBuilderColorPicker(
        //   name: "q_${question.order}",
        //   decoration: const InputDecoration(labelText: "Pick a color"),
        // );

    /// ================= SEARCHABLE LIST =================
      case QuestionType.searchableList:
        return FormBuilderDropdown<String>(
          name: "q_${question.order}",
          decoration: const InputDecoration(labelText: "Search & select"),
          items: question.answers
              .map((a) => DropdownMenuItem(value: a, child: Text(a)))
              .toList(),
          isExpanded: true,
        );

    /// ================= STEPPER NUMBER =================
      case QuestionType.stepperNumber:
        return SizedBox();

        //   FormBuilderTouchSpin(
        //   name: "q_${question.order}",
        //   min: question.min?.toDouble() ?? 0,
        //   max: question.max?.toDouble() ?? 100,
        //   step: question.step?.toDouble() ?? 1,
        // );

    /// ================= MULTI PAGE STEPPER =================
      case QuestionType.multiPageStepper:
        return const Text(
          "Multi-page stepper handled at form level",
          style: TextStyle(color: Colors.grey),
        );

    /// ================= GENERIC =================
      case QuestionType.generic:
        return const SizedBox.shrink();
    }
  }
}
