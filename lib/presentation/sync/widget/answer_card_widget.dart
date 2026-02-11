import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:formify/domain/models/model_q.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/question/page/view_question.dart';

class QuestionCard extends StatelessWidget {
  final int number;
  final int total;
  final QuestionModel questionModel;
  final bool isLast;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  final GlobalKey<FormBuilderState> formKey;
  final Object? initialValue; // إضافة initialValue لتعيين القيمة المحفوظة

  const QuestionCard({
    super.key,
    required this.number,
    required this.total,
    required this.questionModel,
    required this.isLast,
    required this.onPrev,
    required this.onNext,
    required this.formKey,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 520),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: FormBuilder(
            key: formKey,
            initialValue: {
              "q_${questionModel.order}":
                  initialValue, // تخصيص القيمة المخزنة في الـForm
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2F4F6A),
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Text(
                      "سؤال $number",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        questionModel.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (questionModel.isRequired == true)
                      const Text(
                        "•",
                        style: TextStyle(color: Colors.red, fontSize: 22),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                QuestionPreviewBuilder(question: questionModel),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: number == 1 ? null : onPrev,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text("السابق"),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onNext,
                        icon: const Icon(Icons.check_circle_outline),
                        label: Text(isLast ? "إرسال الإجابات" : "التالي"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
