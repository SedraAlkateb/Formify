import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formify/domain/models/models.dart';

class DropdownQuestionWidget extends StatefulWidget {
  final QuestionModel question;
  final String name;

  const DropdownQuestionWidget({
    super.key,
    required this.question,
    required this.name,
  });

  @override
  State<DropdownQuestionWidget> createState() =>
      _DropdownQuestionWidgetState();
}

class _DropdownQuestionWidgetState extends State<DropdownQuestionWidget> {
  AnswerModel? selectedAnswer;
  AnswerModel? correctAnswer;

  @override
  void initState() {
    super.initState();

    /// جلب الإجابة الصحيحة
    correctAnswer = widget.question.answers.firstWhere(
          (a) => a.isCorrect == 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// Dropdown
        FormBuilderDropdown<AnswerModel>(
          name: widget.name,
          decoration: InputDecoration(
            hintText: "اختر إجابة",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          items: widget.question.answers
              .map(
                (a) => DropdownMenuItem(
              value: a,
              child: Text(a.title),
            ),
          )
              .toList(),

          onChanged: (value) {
            setState(() {
              selectedAnswer = value;
            });
          },

          validator: FormBuilderValidators.required(
            errorText: "هذا الحقل مطلوب",
          ),
        ),

        const SizedBox(height: 8),

        /// النتيجة
        if (selectedAnswer != null)
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: selectedAnswer!.isCorrect == 1
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selectedAnswer!.isCorrect == 1
                    ? Colors.green
                    : Colors.red,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  selectedAnswer!.isCorrect == 1
                      ? Icons.check_circle
                      : Icons.cancel,
                  color: selectedAnswer!.isCorrect == 1
                      ? Colors.green
                      : Colors.red,
                ),
                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    selectedAnswer!.isCorrect == 1
                        ? "إجابة صحيحة"
                        : "إجابة خاطئة\nالإجابة الصحيحة: ${correctAnswer?.title}",
                    style: TextStyle(
                      color: selectedAnswer!.isCorrect == 1
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}