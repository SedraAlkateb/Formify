import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/model_q.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:formify/presentation/question/widgets/image_answer.dart';
import 'package:formify/presentation/resources/color_manager.dart';

class QuestionPreviewBuilder extends StatelessWidget {
  final QuestionModel question;
  const QuestionPreviewBuilder({super.key, required this.question});

  String get _name => "q_${question.order}";

  FormFieldValidator<dynamic>? _requiredIfNeeded({String? message}) {
    if (question.isRequired == true) {
      return FormBuilderValidators.required(
        errorText: message ?? "هذا السؤال مطلوب",
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
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            hintText: "الإجابة...",
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
                errorText: "هذا السؤال مطلوب",
              ),
            FormBuilderValidators.email(errorText: "البريد الإلكتروني غير صالح"),
          ]),
        );

      case QuestionType.password:
        return FormBuilderTextField(
          name: _name,
          obscureText: true,
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            hintText: "كلمة المرور",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: _requiredIfNeeded(),
        );

      case QuestionType.phone:
        return FormBuilderTextField(
          name: _name,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: "رقم الهاتف",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: FormBuilderValidators.compose([
            if (question.isRequired == true)
              FormBuilderValidators.required(
                errorText: "هذا السؤال مطلوب",
              ),
            FormBuilderValidators.numeric(errorText: "أرقام فقط"),
            FormBuilderValidators.minLength(7, errorText: "قصير جداً"),
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
                errorText: "هذا السؤال مطلوب",
              ),
            FormBuilderValidators.numeric(errorText: "رقم غير صالح"),
          ]),
        );

      case QuestionType.dropdown:
        return FormBuilderDropdown<AnswerModel>(
          name: _name,
          decoration: InputDecoration(
            hintText: "اختر إجابة",
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
                children: [imageAnswer(a), Text("${a.title}")],
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
                children: [imageAnswer(a), Text("${a.title}")],
              ),
            ),
          )
              .toList(),
          validator: question.isRequired == true
              ? FormBuilderValidators.minLength(
            1,
            errorText: "اختر خياراً واحداً على الأقل",
          )
              : null,
        );

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
              onSelected: field.didChange,
              fieldViewBuilder: (context, controller, focusNode, onSubmit) {
                controller.text = field.value ?? controller.text;
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                    hintText: "ابدأ بالكتابة...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorText: field.errorText,
                  ),
                  onChanged: field.didChange,
                );
              },
            );
          },
        );

      case QuestionType.switchField:
        return FormBuilderSwitch(
          name: _name,
          title: Text(question.title),
        );

      case QuestionType.date:
        return FormBuilderDateTimePicker(
          name: _name,
          inputType: InputType.date,
          decoration: InputDecoration(
            labelText: "اختر التاريخ",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: _requiredIfNeeded(),
        );

      case QuestionType.time:
        return FormBuilderDateTimePicker(
          name: _name,
          inputType: InputType.time,
          decoration: InputDecoration(
            labelText: "اختر الوقت",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: _requiredIfNeeded(),
        );

      case QuestionType.dateTime:
        return FormBuilderDateTimePicker(
          name: _name,
          inputType: InputType.both,
          decoration: InputDecoration(
            labelText: "اختر التاريخ والوقت",
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
          glow: true,
          glowColor: ColorManager.textHint,
          glowRadius: 2,
          itemSize: 36,
          ratingWidget: RatingWidget(
            full: Icon(
              Icons.star,
              size: 36,
              color: const Color(0xFFFFC107),
              shadows: [
                Shadow(
                  color: const Color(0xFFFFC107).withOpacity(0.6),
                  blurRadius: 6,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            half: Icon(
              Icons.star_half,
              size: 36,
              color: const Color(0xFFFFC107),
              shadows: [
                Shadow(
                  color: const Color(0xFFFFC107).withOpacity(0.5),
                  blurRadius: 5,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            empty: const Icon(
              Icons.star_border_outlined,
              size: 36,
              color: Color(0xFF837659),
            ),
          ),
          validator: question.isRequired == true
              ? (value) => (value == null || value == 0)
              ? "هذا السؤال مطلوب"
              : null
              : null,
        );

      case QuestionType.generic:
        return const SizedBox.shrink();
    }
  }
}