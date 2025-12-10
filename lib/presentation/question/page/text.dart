import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

Widget TextWidget(String name,bool valid){

  return FormBuilderTextField(
    name: 'title',
    decoration: InputDecoration(
      labelText: "Title",
      hintText: "Enter survey title",
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // ========== VALIDATION ==========

    validator:
    valid==true?
    FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: "This field is required"),
      // FormBuilderValidators.minLength(3,
      //     errorText: "Title must be at least 3 characters"),
      // FormBuilderValidators.maxLength(50,
      //     errorText: "Title cannot exceed 50 characters"),
    ]):null,

    // ===== OPTIONAL =======
   // keyboardType: TextInputType.text,
   // textInputAction: TextInputAction.next,
  );

}

class TextQuestionPage extends StatefulWidget {
  // final String name;        // اسم الحقل في الفورم (id)
  // final bool  valid;  // القيمة الابتدائية لـ Required

  const TextQuestionPage({
    super.key,
    // required this.name,
    // this.valid = true,
  });

  @override
  State<TextQuestionPage> createState() => _TextQuestionPageState();
}

class _TextQuestionPageState extends State<TextQuestionPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  String _questionText = "";
  bool _isRequired = true;

  @override
  void initState() {
    super.initState();
  //  _isRequired = widget.valid;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text("Text Question"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===================== إعداد السؤال =====================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Question Text",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // نص السؤال
                    FormBuilderTextField(
                      name: 'question_text',
                      decoration: InputDecoration(
                        hintText: "Enter question...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _questionText = val ?? "";
                        });
                      },
                      validator: (value) {
                        if (
                            value == null || value.trim().isEmpty) {
                          return "Question cannot be empty";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // اختيار إذا Required أو لا
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Required (Validation)",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Switch(
                          value: _isRequired,
                          activeColor: colorScheme.primary,
                          onChanged: (val) {
                            setState(() {
                              _isRequired = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ===================== معاينة الشكل النهائي =====================
              Text(
                "Preview",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onBackground,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorScheme.outline.withOpacity(0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Label
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            _questionText.isEmpty
                                ? "Question label will appear here"
                                : _questionText,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                        if (_isRequired) ...[
                          const SizedBox(width: 4),
                          Text(
                            "*",
                            style: TextStyle(
                              color: colorScheme.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    // حقل التعبئة (preview)
                    FormBuilderTextField(
                      name: 'answer_text',
                      decoration: InputDecoration(
                        hintText: "Answer...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (_isRequired &&
                            (value == null || value.trim().isEmpty)) {
                          return "Answer cannot be empty";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        final isValid = _formKey.currentState?.saveAndValidate() ?? false;
                        if (!isValid) {
                          // إذا Required والنص فاضي أو أي خطأ -> رسالة
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please fix validation errors before continuing."),
                            ),
                          );
                          return;
                        }
                      },
                      child: const Text("Test"),
                    ),

                  ],
                ),
              ),

              const Spacer(),

              // ===================== زر Next =====================
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // هنا منطق المتابعة (حاليا بس print)
                    final data = {
                      "name": _questionText,
                      "valid": _isRequired,
                    };
                    Navigator.pop(context, data);

                    debugPrint("Saved question: $data");
                  },
                  child: const Text("Next"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
