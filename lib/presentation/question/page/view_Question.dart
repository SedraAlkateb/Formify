import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/model_q.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';

class QuestionPreviewBuilder extends StatelessWidget {
  final QuestionModel question;
  final List<String>? initValue;
  const QuestionPreviewBuilder({
    super.key,
    required this.question,
    this.initValue,
  });

  String get _name => "q_${question.order}";

  FormFieldValidator<dynamic>? _requiredIfNeeded({String? message}) {
    if (question.isRequired == true) {
      return FormBuilderValidators.required(
        errorText: message ?? "This question is required",
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    switch (question.type) {
      case QuestionType.text:
        return FormBuilderTextField(
          initialValue: initValue?[0],
          name: _name,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: "Answer...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: _requiredIfNeeded(),
        );

      case QuestionType.email:
        return FormBuilderTextField(
          initialValue: initValue?[0],
          name: _name,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: "example@mail.com",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: FormBuilderValidators.compose([
            if (question.isRequired == true)
              FormBuilderValidators.required(
                errorText: "This question is required",
              ),
            FormBuilderValidators.email(errorText: "Invalid email"),
          ]),
        );

      case QuestionType.password:
        return FormBuilderTextField(
          initialValue:initValue?[0],
          name: _name,
          obscureText: true,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: _requiredIfNeeded(),
        );

      case QuestionType.phone:
        return FormBuilderTextField(
          name: _name,
          initialValue: initValue?[0],
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: "Phone number",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: FormBuilderValidators.compose([
            if (question.isRequired == true)
              FormBuilderValidators.required(
                errorText: "This question is required",
              ),
            FormBuilderValidators.numeric(errorText: "Numbers only"),
            FormBuilderValidators.minLength(7, errorText: "Too short"),
          ]),
        );

      case QuestionType.number:
        return FormBuilderTextField(
          initialValue: initValue?[0],
          name: _name,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "0",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: FormBuilderValidators.compose([
            if (question.isRequired == true)
              FormBuilderValidators.required(
                errorText: "This question is required",
              ),
            FormBuilderValidators.numeric(errorText: "Invalid number"),
          ]),
        );

      case QuestionType.dropdown:
        return FormBuilderDropdown<AnswerModel>(
          name: _name,
          //enabled: false,
          initialValue: AnswerModel(0, initValue![0], ""),
          decoration: InputDecoration(
            hintText: "Select an answer",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: question.answers
              .map((a) => DropdownMenuItem(value: a, child: Text(a.title)))
              .toList(),
          validator: _requiredIfNeeded(),
        );

      case QuestionType.multipleChoice:
        return FormBuilderRadioGroup<AnswerModel>(
          name: _name,
          initialValue: AnswerModel(0, initValue![0], ""),
          options: question.answers
              .map(
                (a) => FormBuilderFieldOption(value: a, child: Text(a.title)),
              )
              .toList(),
          validator: _requiredIfNeeded(),
        );

      case QuestionType.checkbox:
        return FormBuilderCheckboxGroup<AnswerModel>(
          name: _name,
          initialValue:initValue?.map((e) =>AnswerModel(0, initValue![0], "") ,).toList() ,
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

      // case QuestionType.chips:
      //   return FormBuilderChoiceChips<String>(
      //     name: _name,
      //     spacing: 8,
      //     runSpacing: 8,
      //     options: question.answers
      //         .map((a) => FormBuilderChipOption<String>(value: a.title, child: Text(a.title)))
      //         .toList(),
      //     validator: question.isRequired == true
      //         ? (value) {
      //       if (value == null || value.isEmpty) return "Select at least one option";
      //       return null;
      //     }
      //         : null,
      //   );

      case QuestionType.autocomplete:
        return FormBuilderField<String>(
          name: _name,
          initialValue: initValue?[0],
          validator: _requiredIfNeeded(),
          builder: (field) {
            return Autocomplete<String>(
              optionsBuilder: (textEditingValue) {
                final q = textEditingValue.text.trim().toLowerCase();
                if (q.isEmpty) return const Iterable<String>.empty();
                return question.answers
                    .where((a) => a.title.toLowerCase().contains(q))
                    .map((a) => a.title);
              },
         //     initialValue:TextEditingValue(text: initValue?[0] ??""),
              onSelected: field.didChange,
              fieldViewBuilder: (context, controller, focusNode, onSubmit) {
                controller.text = field.value ?? controller.text;
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: "Start typing...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorText: field.errorText,
                  ),
                  onChanged: field
                      .didChange, // هذا فقط لربط قيمة الحقل داخل FormBuilderField
                );
              },
            );
          },
        );

      case QuestionType.switchField:
        return FormBuilderSwitch(
          name: _name,
        //  initialValue: initValue?[0],
          title: Text(question.title),
          validator: (value) {
            if (question.isRequired == true && value != true) {
              return "This question is required";
            }
            return null;
          },
        );

      case QuestionType.date:
        return FormBuilderDateTimePicker(
          name: _name,
        //  initialValue: initValue[0],
          inputType: InputType.date,
          decoration: InputDecoration(
            labelText: "Select date",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: _requiredIfNeeded(),
        );

      case QuestionType.time:
        return FormBuilderDateTimePicker(
          name: _name,
     //     initialValue: initValue[0],
          inputType: InputType.time,
          decoration: InputDecoration(
            labelText: "Select time",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: _requiredIfNeeded(),
        );

      case QuestionType.dateTime:
        return FormBuilderDateTimePicker(
          name: _name,
        //  initialValue: initValue[0],
          inputType: InputType.both,
          decoration: InputDecoration(
            labelText: "Select date & time",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: _requiredIfNeeded(),
        );

      case QuestionType.slider:
        return FormBuilderSlider(
          name: _name,
          min: 0,
          max: 100,
         initialValue: double.parse(initValue?[0]??"0"),
          divisions: 50,
          validator: _requiredIfNeeded(),
        );

      case QuestionType.rating:
        return FormBuilderRatingBar(
          name: _name,
      //    initialValue: initValue[0],
          maxRating: 5,
          allowHalfRating: true,
          validator: question.isRequired == true
              ? (value) => (value == null || value == 0)
                    ? "This question is required"
                    : null
              : null,
        );

      case QuestionType.generic:
        return const SizedBox.shrink();
    }
  }
}
