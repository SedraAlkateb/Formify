import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formify/app/constants.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/model_q.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:formify/presentation/question/widgets/image_answer.dart';
import 'package:formify/presentation/resources/color_manager.dart';

class QuestionPreviewNetworkBuilder extends StatelessWidget {
  final QuestionModel question;
  const QuestionPreviewNetworkBuilder({super.key, required this.question});

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
          orientation: OptionsOrientation.vertical,
          name: _name,

          options: question.answers
              .map(
                (a) => FormBuilderFieldOption(
                  value: a,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [imageAnswerNetwork(a), Text("${a.title}")],
                  ),
                ),
              )
              .toList(),
          validator: _requiredIfNeeded(),
        );

      case QuestionType.checkbox:
        return FormBuilderCheckboxGroup<AnswerModel>(
          name: _name,
          orientation: OptionsOrientation.vertical,
          options: question.answers
              .map(
                (a) => FormBuilderFieldOption(
                  value: a,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [imageAnswerNetwork(a), Text("${a.title}")],
                  ),
                ),
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
          //
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
          initialValue: 0,
          divisions: 50,
          validator: _requiredIfNeeded(),
        );

      case QuestionType.rating:
        return FormBuilderRatingBar(
          name: _name,
          maxRating: 5,
          allowHalfRating: true,

          unratedColor: const Color(0xFFFFD54F),
          // const Color(0xFFFFC107), // أصفر ذهبي
          glow: true,
          glowColor: ColorManager.textHint,
          glowRadius:2,
          itemSize: 36,
          ratingWidget: RatingWidget(
            full: Icon(
              Icons.star,
              size: 36,
              color: const Color(0xFFFFC107), // أصفر ذهبي
              shadows: [
                Shadow(
                  color: Color(0xFFFFC107).withOpacity(0.6),
                  blurRadius: 6,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            half: Icon(
              Icons.star_half,
              size: 36,
              color: const Color(0xFFFFC107),
              shadows: [
                Shadow(
                  color: Color(0xFFFFC107).withOpacity(0.5),
                  blurRadius: 5,
                  offset: Offset(0, 1),
                ),
              ],
            ),

            empty: Icon(
              Icons.star_border_outlined,
              size: 36,
              color: const Color(0xFF837659),
            ),
          ),
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
