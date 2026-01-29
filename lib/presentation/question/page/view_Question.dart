import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/model_q.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:formify/presentation/survey/bloc/survey_bloc.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';

class QuestionPreviewBuilder extends StatelessWidget {
  final QuestionModel question;

  const QuestionPreviewBuilder({super.key, required this.question});
  void handleTextQuestion(List<AnswerUserModel> answer, BuildContext context) {
    BlocProvider.of<SyncBloc>(context).answer = answer;
  }

  @override
  Widget build(BuildContext context) {
    switch (question.type) {
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
          onChanged: (value) {
            handleTextQuestion([AnswerUserModel(question.answers[0].id, value ?? "")], context);
          },
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
          onChanged: (value) {
            handleTextQuestion([AnswerUserModel(question.answers[0].id, value ?? "")], context);
          },
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
          onChanged: (value) {
            handleTextQuestion([AnswerUserModel(question.answers[0].id, value ?? "")], context);
          },
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
          onChanged: (value) {
            handleTextQuestion([AnswerUserModel(question.answers[0].id, value ?? "")], context);
          },
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
          onChanged: (value) {
            handleTextQuestion([AnswerUserModel(question.answers[0].id, value ?? "")], context);
          },
        );

      /// ================= DROPDOWN =================
      case QuestionType.dropdown:
        return FormBuilderDropdown<AnswerModel>(
          name: "q_${question.order}",

          decoration: InputDecoration(
            hintText: "Select an answer",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: question.answers
              .map((a) => DropdownMenuItem(value: a, child: Text(a.title)))
              .toList(),
          validator: question.isRequired == true
              ? FormBuilderValidators.required(
                  errorText: "This question is required",
                )
              : null,
          onChanged: (value) {
            handleTextQuestion((value!=null?([AnswerUserModel(value.id, value.title)] ) : [AnswerUserModel(0, "")]), context);
          },
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
        return FormBuilderRadioGroup<AnswerModel>(
          name: "q_${question.order}",
          initialValue:
          BlocProvider.of<SyncBloc>(context).answer.map((answer) =>AnswerModel(answer.answer_id??0, answer.content) ).first,

          options: question.answers
              .map((a) => FormBuilderFieldOption(value: a))
              .toList(),
          validator: question.isRequired == true
              ? FormBuilderValidators.required()
              : null,
          onChanged: (value) {
            handleTextQuestion((value!=null?([AnswerUserModel(value.id, value.title)] ) : [AnswerUserModel(0, "")]), context);
          },
        );

      /// ================= CHECKBOX =================
      case QuestionType.checkbox:
        return FormBuilderCheckboxGroup<AnswerModel>(
          name: "q_${question.order}",

          initialValue: BlocProvider.of<SyncBloc>(context).answer.map((answer) =>AnswerModel(answer.answer_id??0, answer.content) ).toList(),
          options: question.answers
              .map((a) => FormBuilderFieldOption(value: a))
              .toList(),
          validator: question.isRequired == true
              ? FormBuilderValidators.minLength(
                  1,
                  errorText: "Select at least one option",
                )
              : null,
          onChanged: (value) {
            List<AnswerUserModel> answers=[];
            if(value!=null){
              Set<int> uniqueIds = Set(); // لإنشاء مجموعة لتخزين المعرفات الفريدة
              for (var item in value) {
                if (!uniqueIds.contains(item.id)) {
                  uniqueIds.add(item.id); // إضافة المعرف إلى المجموعة الفريدة
                  answers.add(AnswerUserModel(item.id, item.title)); // إضافة الإجابة فقط إذا لم يكن المعرف مكررًا
                }
              }
              handleTextQuestion(answers, context);
            }
          },
        );

      /// ================= CHIPS =================
      /// - اختيار واحد افتراضيًا
      /// - إذا تريد متعدد: حط question.allowMultiple=true عندك أو اعتمد على نوع آخر
      case QuestionType.chips:
        return FormBuilderChoiceChips<String>(
          name: "q_${question.order}",
          // initialValue:
          // BlocProvider.of<SyncBloc>(context).answer.map((answer) =>AnswerModel(answer.answer_id??0, answer.content) ).first,

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
              ((question.answers.isNotEmpty) &&
              (question.answers[0].title == "1")),
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
          divisions: 50,
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
