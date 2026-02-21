import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/question/widgets/image_answer.dart';

class CheckboxQuestionWidget extends StatefulWidget {
  final QuestionModel question;
  final String name;

  const CheckboxQuestionWidget({super.key, required this.question, required this.name});

  @override
  State<CheckboxQuestionWidget> createState() => _CheckboxQuestionWidgetState();
}

class _CheckboxQuestionWidgetState extends State<CheckboxQuestionWidget> {
  List<AnswerModel> selected = [];
  bool isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<List<AnswerModel>>(
      name: widget.name,
      validator: widget.question.isRequired
          ? (value) {
        if (value == null || value.isEmpty) return "اختر خياراً واحداً على الأقل";
        return null;
      }
          : null,
      builder: (field) {
        selected = field.value ?? [];
        return Column(
          children: [
            ...widget.question.answers.map((a) {
              final isSelected = selected.contains(a);
              final isCorrect = a.isCorrect == 1;

              Color? bgColor;
              Color borderColor = Colors.grey.shade300;
              if (isSubmitted) {
                if (isCorrect) {
                  bgColor = Colors.green.withOpacity(0.15);
                  borderColor = Colors.green;
                } else if (isSelected && !isCorrect) {
                  bgColor = Colors.red.withOpacity(0.15);
                  borderColor = Colors.red;
                }
              }

              return GestureDetector(
                onTap: isSubmitted
                    ? null
                    : () {
                  setState(() {
                    if (isSelected) {
                      selected.remove(a);
                    } else {
                      selected.add(a);
                    }
                    field.didChange(selected);
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: isSelected,
                            onChanged: isSubmitted
                                ? null
                                : (val) {
                              setState(() {
                                if (val == true) {
                                  selected.add(a);
                                } else {
                                  selected.remove(a);
                                }
                                field.didChange(selected);
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          imageAnswerNetwork(a),
                          const SizedBox(width: 8),

                          if (isSubmitted)
                            Icon(
                              isCorrect
                                  ? Icons.check_circle
                                  : (isSelected ? Icons.cancel : Icons.radio_button_unchecked),
                              color: isCorrect ? Colors.green : (isSelected ? Colors.red : Colors.grey),
                            ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 60),
                        child: Text(a.title),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 16),

            if (!isSubmitted)
              ElevatedButton(
                onPressed: selected.isEmpty
                    ? null
                    : () {
                  setState(() {
                    isSubmitted = true;
                  });
                },
                child: const Text("عرض النتيجة"),
              ),
          ],
        );
      },
    );
  }
}