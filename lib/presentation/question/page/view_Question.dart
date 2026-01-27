import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/model_q.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';

class QuestionPreviewBuilder extends StatelessWidget {
  final QuestionModel question;

  const QuestionPreviewBuilder({super.key, required this.question});

  // double _toDouble(String? v, {double fallback = 0}) {
  //   if (v == null) return fallback;
  //   return double.tryParse(v) ?? fallback;
  // }
  //
  // int _toInt(String? v, {int fallback = 0}) {
  //   if (v == null) return fallback;
  //   return int.tryParse(v) ?? fallback;
  // }
  // bool _toBool(String? v) {
  //   if (v == null) return false;
  //   return v=="0"?false:true;
  // }
  @override
  Widget build(BuildContext context) {
    switch (question.type) {
      /// ================= TEXT =================
      case QuestionType.text:
        return FormBuilderTextField(
          maxLines: 5,
          name: "q_${question.order}",
          decoration: InputDecoration(
            hintText: " Answer...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: question.isRequired == true
              ? FormBuilderValidators.required(
                  errorText: "This question is required",
                )
              : null,
        );

      /// ================= EMAIL =================
      case QuestionType.email:
        return FormBuilderTextField(
          name: "q_${question.order}",
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

      /// ================= PASSWORD =================
      case QuestionType.password:
        return FormBuilderTextField(
          name: "q_${question.order}",
          obscureText: true,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: question.isRequired == true
              ? FormBuilderValidators.required(
                  errorText: "This question is required",
                )
              : null,
        );

      /// ================= PHONE =================
      case QuestionType.phone:
        return FormBuilderTextField(
          name: "q_${question.order}",
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

      /// ================= NUMBER =================
      case QuestionType.number:
        return FormBuilderTextField(
          name: "q_${question.order}",
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

      /// ================= DROPDOWN =================
      case QuestionType.dropdown:
        return FormBuilderDropdown<String>(
          name: "q_${question.order}",
          decoration: InputDecoration(
            hintText: "Select an answer",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: question.answers
              .map(
                (a) =>
                    DropdownMenuItem(value: a.title, child: Text(a.title)),
              )
              .toList(),
          validator: question.isRequired == true
              ? FormBuilderValidators.required(
                  errorText: "This question is required",
                )
              : null,
        );

      // case QuestionType.searchableList:
      //   return FormBuilderDropdown<String>(
      //     name: "q_${question.order}",
      //     decoration: InputDecoration(
      //       hintText: "Search & select",
      //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      //     ),
      //     items: question.answers
      //         .map(
      //           (a) =>
      //               DropdownMenuItem(value: a.title, child: Text(a.title)),
      //         )
      //         .toList(),
      //     isExpanded: true,
      //     validator: question.isRequired == true
      //         ? FormBuilderValidators.required(
      //             errorText: "This question is required",
      //           )
      //         : null,
      //   );

      /// ================= MULTIPLE CHOICE (RADIO) =================
      case QuestionType.multipleChoice:
        return FormBuilderRadioGroup<String>(
          name: "q_${question.order}",
          options: question.answers
              .map((a) => FormBuilderFieldOption(value: a.title))
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
              .map((a) => FormBuilderFieldOption(value: a.title))
              .toList(),
          validator: question.isRequired == true
              ? FormBuilderValidators.minLength(
                  1,
                  errorText: "Select at least one option",
                )
              : null,
        );

      /// ================= CHIPS =================
      /// - اختيار واحد افتراضيًا
      /// - إذا تريد متعدد: حط question.allowMultiple=true عندك أو اعتمد على نوع آخر
      case QuestionType.chips:
        return FormBuilderChoiceChips<String>(
          name: "q_${question.order}",
          spacing: 8,
          runSpacing: 8,
          //      multiple: true,
          options: question.answers
              .map(
                (a) => FormBuilderChipOption<String>(
                  value: a.title,
                  child: Text(a.title),
                ),
              )
              .toList(),
          validator: question.isRequired == true
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return "Select at least one option";
                  }
                  return null;
                }
              : null,
        );

      /// ================= AUTOCOMPLETE =================
      /// (يعتمد على form_builder_extra_fields غالبًا)
      /// هنا نسخة Preview بسيطة بـ TypeAheadField غير متاحة ضمن form_builder الأساسي،
      /// لذلك نستخدم TextField + قائمة اقتراحات بسيطة عبر Autocomplete (Flutter).
      case QuestionType.autocomplete:
        return FormBuilderField<String>(
          name: "q_${question.order}",
          validator: question.isRequired == true
              ? FormBuilderValidators.required(
                  errorText: "This question is required",
                )
              : null,
          builder: (field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Autocomplete<String>(
                  optionsBuilder: (textEditingValue) {
                    final q = textEditingValue.text.trim().toLowerCase();
                    if (q.isEmpty) return const Iterable<String>.empty();

                    // تصفية الإجابات والرجوع فقط إلى النصوص (title)
                    Iterable<String> an = question.answers
                        .where((a) => a.title.toLowerCase().contains(q))
                        .map((a) => a.title); // هنا نقوم بأخذ title فقط

                    return an; // إرجاع Iterable من النصوص فقط
                  },
                  onSelected: (val) =>
                      field.didChange(val), // التعامل مع النص الذي تم اختياره
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
                      onChanged: field.didChange,
                    );
                  },
                ),
              ],
            );
          },
        );

      /// ================= SWITCH =================
      case QuestionType.switchField:
        return FormBuilderSwitch(
          name: "q_${question.order}",
          title: Text(question.title),
          initialValue:
              ((question.answers.isNotEmpty) && (question.answers[0].title == "1")),
          validator: (value) {
            if (question.isRequired == true && value != true) {
              return "This question is required";
            }
            return null;
          },
        );

      /// ================= DATE =================
      case QuestionType.date:
        return FormBuilderDateTimePicker(
          name: "q_${question.order}",
          inputType: InputType.date,
          decoration: InputDecoration(
            labelText: "Select date",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: question.isRequired == true
              ? FormBuilderValidators.required()
              : null,
        );

      /// ================= TIME =================
      case QuestionType.time:
        return FormBuilderDateTimePicker(
          name: "q_${question.order}",
          inputType: InputType.time,
          decoration: InputDecoration(
            labelText: "Select time",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: question.isRequired == true
              ? FormBuilderValidators.required()
              : null,
        );

      /// ================= DATE & TIME =================
      case QuestionType.dateTime:
        return FormBuilderDateTimePicker(
          name: "q_${question.order}",
          inputType: InputType.both,
          decoration: InputDecoration(
            labelText: "Select date & time",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: question.isRequired == true
              ? FormBuilderValidators.required()
              : null,
        );

      /// ================= SLIDER =================
      /// answers: [min, max, initial?, divisions?]
      case QuestionType.slider:
        return FormBuilderSlider(
          name: "q_${question.order}",
          min: 0,
          max: 100,
          initialValue: 0,
          divisions: 50 ,
          validator: question.isRequired == true
              ? FormBuilderValidators.required(
                  errorText: "This question is required",
                )
              : null,
        );

      /// ================= RANGE SLIDER =================
      /// answers: [min, max, start?, end?]
      case QuestionType.rating:
        return FormBuilderRatingBar(
          name: "q_${question.order}",
          initialValue: 0,
          maxRating: 5,
          allowHalfRating: true,
          validator: question.isRequired == true
              ? (value) {
                  if (value == null || value == 0) {
                    return "This question is required";
                  }
                  return null;
                }
              : null,
        );

      /// ================= GENERIC =================
      case QuestionType.generic:
        return const SizedBox.shrink();
    }
  }
}
