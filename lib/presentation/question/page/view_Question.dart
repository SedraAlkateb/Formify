import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/model_q.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';

class QuestionPreviewBuilder extends StatelessWidget {
  final QuestionModel question;

  const QuestionPreviewBuilder({super.key, required this.question});

  double _toDouble(String? v, {double fallback = 0}) {
    if (v == null) return fallback;
    return double.tryParse(v) ?? fallback;
  }

  int _toInt(String? v, {int fallback = 0}) {
    if (v == null) return fallback;
    return int.tryParse(v) ?? fallback;
  }

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
              .map((a) => DropdownMenuItem(value: a.content, child: Text(a.content)))
              .toList(),
          validator: question.isRequired == true
              ? FormBuilderValidators.required(
                  errorText: "This question is required",
                )
              : null,
        );

      case QuestionType.searchableList:
        return FormBuilderDropdown<String>(
          name: "q_${question.order}",
          decoration: InputDecoration(
            hintText: "Search & select",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: question.answers
              .map((a) => DropdownMenuItem(value:  a.content, child: Text( a.content)))
              .toList(),
          isExpanded: true,
          validator: question.isRequired == true
              ? FormBuilderValidators.required(
                  errorText: "This question is required",
                )
              : null,
        );

      /// ================= MULTIPLE CHOICE (RADIO) =================
      case QuestionType.multipleChoice:
        return FormBuilderRadioGroup<String>(
          name: "q_${question.order}",
          options: question.answers
              .map((a) => FormBuilderFieldOption(value:  a.content))
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
              .map((a) => FormBuilderFieldOption(value:  a.content))
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
                (a) => FormBuilderChipOption<String>(value:  a.content, child: Text( a.content)),
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

                    // تصفية الإجابات والرجوع فقط إلى النصوص (content)
                    Iterable<String> an = question.answers.where(
                          (a) => a.content.toLowerCase().contains(q),
                    ).map((a) => a.content);  // هنا نقوم بأخذ content فقط

                    return an;  // إرجاع Iterable من النصوص فقط
                  },
                  onSelected: (val) => field.didChange(val),  // التعامل مع النص الذي تم اختياره
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
              (question.answers.isNotEmpty && question.answers[0] == "1"),
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
        final min = _toDouble(
          question.answers.isNotEmpty ? question.answers[0].content : null,
          fallback: 0,
        );
        final max = _toDouble(
          question.answers.length > 1 ? question.answers[1].content : null,
          fallback: 100,
        );
        final initial = _toDouble(
          question.answers.length > 2 ? question.answers[2] .content: null,
          fallback: min,
        );
        final divisions = _toInt(
          question.answers.length > 3 ? question.answers[3].content : null,
          fallback: 0,
        );

        return FormBuilderSlider(
          name: "q_${question.order}",
          min: min,
          max: max,
          initialValue: initial.clamp(min, max),
          divisions: divisions > 0 ? divisions : null,
          validator: question.isRequired == true
              ? FormBuilderValidators.required(
                  errorText: "This question is required",
                )
              : null,
        );

      /// ================= RANGE SLIDER =================
      /// answers: [min, max, start?, end?]
      case QuestionType.rangeSlider:
        final min = _toDouble(
          question.answers.isNotEmpty ? question.answers[0] .content: null,
          fallback: 0,
        );
        final max = _toDouble(
          question.answers.length > 1 ? question.answers[1].content : null,
          fallback: 100,
        );
        final start = _toDouble(
          question.answers.length > 2 ? question.answers[2] .content: null,
          fallback: min,
        );
        final end = _toDouble(
          question.answers.length > 3 ? question.answers[3].content : null,
          fallback: max,
        );

        return FormBuilderRangeSlider(
          name: "q_${question.order}",
          min: min,
          max: max,
          initialValue: RangeValues(start.clamp(min, max), end.clamp(min, max)),
          validator: question.isRequired == true
              ? (value) {
                  if (value == null) return "This question is required";
                  return null;
                }
              : null,
        );

      case QuestionType.rating:
        return FormBuilderRatingBar(
          name: "q_${question.order}",
          initialValue: 0,
          maxRating: _toDouble(
            question.answers.isNotEmpty ? question.answers[0] .content: null,
            fallback: 5,
          ),
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

      /// ================= STEPPER NUMBER =================
      /// answers: [min, max, step, initial?]
      case QuestionType.stepperNumber:
        final min = _toDouble(
          question.answers.isNotEmpty ? question.answers[0].content : null,
          fallback: 0,
        );
        final max = _toDouble(
          question.answers.length > 1 ? question.answers[1].content : null,
          fallback: 100,
        );
        final step = _toDouble(
          question.answers.length > 2 ? question.answers[2].content : null,
          fallback: 1,
        );
        final initial = _toDouble(
          question.answers.length > 3 ? question.answers[3].content : null,
          fallback: min,
        );

        return FormBuilderTouchSpin(
          name: "q_${question.order}",
          min: min,
          max: max,
          step: step,
          initialValue: initial.clamp(min, max),
          validator: question.isRequired == true
              ? FormBuilderValidators.required()
              : null,
        );

      /// ================= SECTION HEADER =================
      case QuestionType.sectionHeader:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            (question.title.isNotEmpty) ? question.title : "Section",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        );

      /// ================= HTML CONTENT =================
      /// عرض نص فقط (Preview). إذا تحتاج HTML حقيقي استخدم flutter_widget_from_html.
      case QuestionType.htmlContent:
        return Text(
          (question.title.isNotEmpty) ? question.title : "",
          style: const TextStyle(height: 1.4),
        );

      /// ================= HIDDEN =================
      /// قيمة مخفية: استخدم FormBuilderField بدون UI أو SizedBox.shrink()
      case QuestionType.hidden:
        return FormBuilderField<String>(
          name: "q_${question.order}",
          initialValue: question.answers.isNotEmpty
              ? question.answers.first.content
              : "",
          builder: (field) => const SizedBox.shrink(),
        );

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
