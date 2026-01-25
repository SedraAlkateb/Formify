import 'package:flutter/material.dart';

class SurveyQuestion {
  final String title;
  final String hint;
  const SurveyQuestion({required this.title, required this.hint});
}

class SurveyInputPage extends StatefulWidget {
  const SurveyInputPage({super.key});

  @override
  State<SurveyInputPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyInputPage> {
  final _pageController = PageController();
  int _index = 0;

  final _questions = const [
    SurveyQuestion(title: "كيف كان تنظيم المؤتمر؟", hint: "اكتب إجابتك هنا..."),
    SurveyQuestion(title: "كيف تقيم جودة المحتوى؟", hint: "اكتب إجابتك هنا..."),
    SurveyQuestion(title: "هل توصي بالمؤتمر لأصدقائك؟", hint: "اكتب إجابتك هنا..."),
    SurveyQuestion(title: "ما هي اقتراحاتك لتحسين المؤتمر؟", hint: "اكتب إجابتك هنا..."),
  ];

  late final List<TextEditingController> _answers =
  List.generate(_questions.length, (_) => TextEditingController());

  @override
  void dispose() {
    _pageController.dispose();
    for (final c in _answers) {
      c.dispose();
    }
    super.dispose();
  }

  void _goNext() {
    if (_index < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      _submit();
    }
  }

  void _goPrev() {
    if (_index > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  void _submit() {
    final data = <String, String>{};
    for (int i = 0; i < _questions.length; i++) {
      data[_questions[i].title] = _answers[i].text.trim();
    }

    // هنا ترسل البيانات للسيرفر أو تخزنها محلياً
    debugPrint("SUBMIT: $data");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("تم إرسال الإجابات")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = _questions.length;
    final progress = (total == 0) ? 0.0 : (_index + 1) / total;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F7FF),
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                      label: const Text("العودة"),
                    ),
                    const Spacer(),
                    const Text(
                      "استبيان رضا الحضور",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: Colors.black.withOpacity(0.06),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text("السؤال ${_index + 1} من $total",
                        style: TextStyle(color: Colors.black.withOpacity(0.6))),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Pages
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(), // تنقل بالأزرار فقط
                  itemCount: total,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (context, i) {
                    final q = _questions[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      child: _QuestionCard(
                        number: i + 1,
                        total: total,
                        title: q.title,
                        controller: _answers[i],
                        hint: q.hint,
                        isLast: i == total - 1,
                        onPrev: _goPrev,
                        onNext: _goNext,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final int number;
  final int total;
  final String title;
  final TextEditingController controller;
  final String hint;
  final bool isLast;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _QuestionCard({
    required this.number,
    required this.total,
    required this.title,
    required this.controller,
    required this.hint,
    required this.isLast,
    required this.onPrev,
    required this.onNext,
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
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Chip "سؤال"
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2F4F6A),
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    )
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

            // Question title + red dot required
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 6),
                const Text("•", style: TextStyle(color: Colors.red, fontSize: 22)),
              ],
            ),

            const SizedBox(height: 12),

            // Text answer
            TextField(
              controller: controller,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: hint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFF2F4F6A), width: 1.4),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onPrev,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("السابق"),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                      backgroundColor: const Color(0xFF2F4F6A),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
