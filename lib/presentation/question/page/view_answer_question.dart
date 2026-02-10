import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/model_q.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:formify/presentation/resources/color_manager.dart';

class QuestionAnswerPreviewBuilder extends StatelessWidget {
  final QuestionModel question;
  final List<String>? initValue;
  const QuestionAnswerPreviewBuilder({
    super.key,
    required this.question,
    this.initValue,
  });

  String get _name => "q_${question.order}";

  @override
  Widget build(BuildContext context) {
    switch (question.type) {
      case QuestionType.text:
        return FormBuilderTextField(
          initialValue: initValue?[0],
          name: _name,
          maxLines: 5,
          minLines: 1,
          enabled: false,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
          ),
        );

      case QuestionType.email:
        return FormBuilderTextField(
          initialValue: initValue?[0],
          name: _name,
          maxLines: 5,
          minLines: 1,
          enabled: false,

          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
          ),
        );

      case QuestionType.password:
        return FormBuilderTextField(
          initialValue: initValue?[0],
          name: _name,
          enabled: false,

          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
          ),
        );

      case QuestionType.phone:
        return FormBuilderTextField(
          name: _name,
          initialValue: initValue?[0],
          enabled: false,

          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
          ),
        );

      case QuestionType.number:
        return FormBuilderTextField(
          enabled: false,
          initialValue: initValue?[0],
          name: _name,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
          ),
        );

      case QuestionType.dropdown:
        return FormBuilderTextField(
          name: _name,
          enabled: false,
          initialValue: initValue![0],
          decoration: InputDecoration(
            icon: Icon(Icons.check_circle, color: ColorManager.success),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
          ),
        );

      case QuestionType.multipleChoice:
        return FormBuilderTextField(
          name: _name,
          enabled: false,
          initialValue: initValue![0],
          decoration: InputDecoration(
            icon: Icon(Icons.check_circle, color: ColorManager.success),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
          ),
        );

      case QuestionType.checkbox:
        return FormBuilderCheckboxGroup<AnswerModel>(
          name: _name,
          orientation: OptionsOrientation.vertical,
          initialValue: initValue
              ?.map((e) => AnswerModel(0, initValue![0], ""))
              .toList(),
          options: question.answers
              .map(
                (a) => FormBuilderFieldOption(value: a, child: Text(a.title)),
              )
              .toList(),
          validator: question.isRequired == true
              ? FormBuilderValidators.minLength(
                  1,
                  errorText: "Select at least one option",
                )
              : null,
        );

      case QuestionType.autocomplete:
        return FormBuilderTextField(
          initialValue: initValue?[0],
          name: _name,
          maxLines: 5,
          minLines: 1,
          enabled: false,
          decoration: InputDecoration(
            hintText: "Answer...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
          ),
        );

      case QuestionType.switchField:
        return FormBuilderSwitch(
          name: _name,
          enabled: false,
          initialValue: initValue != null
              ? (initValue?[0] == "0" ? false : true)
              : null,
          title: Text(question.title),
        );

      case QuestionType.date:
        return FormBuilderTextField(
          initialValue: initValue?[0],
          name: _name,
          maxLines: 5,
          minLines: 1,
          enabled: false,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
          ),
        );

      case QuestionType.time:
        return FormBuilderTextField(
          initialValue: initValue?[0],
          name: _name,
          maxLines: 5,
          minLines: 1,
          enabled: false,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
          ),
        );
      case QuestionType.dateTime:
        return FormBuilderTextField(
          initialValue: initValue?[0],
          name: _name,
          maxLines: 5,
          minLines: 1,
          enabled: false,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
          ),
        );

      case QuestionType.slider:
        return FormBuilderSlider(
          name: _name,
          enabled: false,
          min: 0,
          max: 100,
          initialValue: double.parse(initValue?[0] ?? "0"),
          divisions: 50,
        );

      case QuestionType.rating:
        return FormBuilderRatingBar(
          enabled: false,
          name: _name,
          initialValue: double.parse(initValue?[0] ?? "0"),
          maxRating: 5,
          allowHalfRating: true,
        );

      case QuestionType.generic:
        return const SizedBox.shrink();
    }
  }
}
