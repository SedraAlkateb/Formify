import 'package:formify/domain/models/models.dart';

/// خدمة بناء الـ Prompts للـ Gemini
class GeminiPromptBuilderService {
  /// بناء prompt احترافي لسؤال معين
  static String? buildQuestionAnalysisPrompt({
    required String surveyTitle,
    required QuestionsStatisticsModel questionWithAnswers,
  }) {
    final question = questionWithAnswers.question;
    final userAnswers = questionWithAnswers.userAnswers;

    if (userAnswers.isEmpty) return null;

    return '''
حلل بإيجاز إجابات السؤال من استبيان "$surveyTitle":

السؤال: ${question.title}
عدد الإجابات: ${userAnswers.length}

الإجابات:
${_buildAnswersSection(userAnswers)}

المطلوب (بشكل مختصر جداً):
- خلاصة عامة (سطرين كحد أقصى)
- أهم 3 مواضيع + استنتاج ضمني
- الاتجاه العام (إيجابي/سلبي/محايد مع نسبة تقريبية)
- كلمـات مفتاحية (5 كلمات)
- توصيتين عمليتين

الإجابة بالعربية فقط وبأسلوب واضح ومباشر مع اضهار العوانين بخط واضح واعرض وتنسيق جميل
⚠️ لا تتجاوز 15 أسطر إجمالاً
.

''';
  }
  /// بناء قسم الإجابات بصيغة منظمة
  static String _buildAnswersSection(List<UserAnswerStatModel> answers) {
    final buffer = StringBuffer();

    for (int i = 0; i < answers.length; i++) {
      final answer = answers[i];
      buffer.writeln('''
┌─────────────────────────────────────────────────────────────────────────────
│ الإجابة #${i + 1}
├─────────────────────────────────────────────────────────────────────────────
│ المستخدم: ${answer.fullName}
├─────────────────────────────────────────────────────────────────────────────
│ "${answer.content}"
└─────────────────────────────────────────────────────────────────────────────
''');
    }

    return buffer.toString();
  }

  /// بناء prompt لتحليل عدة أسئلة
  static String buildMultipleQuestionsAnalysisPrompt({
    required String surveyTitle,
    required List<QuestionsStatisticsModel> questions,
  }) {
    final questionsWithAnswers =
    questions.where((q) => q.hasTextAnswers).toList();

    if (questionsWithAnswers.isEmpty) {
      return '';
    }

    final prompt = '''
═══════════════════════════════════════════════════════════════════════════════
📊 تقرير تحليل شامل للاستبيان
═══════════════════════════════════════════════════════════════════════════════

📋 معلومات الاستبيان:
├─ اسم الاستبيان: "$surveyTitle"
├─ عدد الأسئلة النصية: ${questionsWithAnswers.length}
└─ التاريخ: ${DateTime.now().toString().split('.')[0]}

───────────────────────────────────────────────────────────────────────────────

${questionsWithAnswers.asMap().entries.map((entry) {
      final index = entry.key + 1;
      final question = entry.value;
      return '''
❓ السؤال #$index: "${question.question.title}"
عدد الإجابات: ${question.userAnswers.length}

${question.userAnswers.asMap().entries.map((ans) => '''
  • "${ans.value.content}" - ${ans.value.fullName}''').join('\n')}
''';
    }).join('\n───────────────────────────────────────────────────────────────────────────────\n')}

───────────────────────────────────────────────────────────────────────────────
🎯 المطلوب:
───────────────────────────────────────────────────────────────────────────────

قدم تقرير شامل يتضمن:

1. ملخص عام لجميع الإجابات
2. المواضيع المشتركة بين الأسئلة المختلفة
3. الاستنتاجات والمشاعر العامة
4. التوصيات والإجراءات المقترحة

═══════════════════════════════════════════════════════════════════════════════
''';

    return prompt;
  }
}


