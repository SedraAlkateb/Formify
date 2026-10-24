import 'package:dio/dio.dart';
import 'package:formify/app/constants.dart';
import 'package:formify/domain/models/model_q.dart';
import 'package:formify/domain/models/models.dart';

class WebFormData {
  final String title;
  final String description;
  final List<QuestionModel> questions;
  WebFormData(this.title, this.description, this.questions);
}

/// Talks to the public (token based) endpoints.
/// Token `demo` returns built-in sample data and sends nothing.
class WebFormApi {
  static const _base = String.fromEnvironment(
    'API_URL',
    defaultValue: Constants.baseUrl,
  );
  final Dio _dio = Dio(BaseOptions(
    baseUrl: _base,
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
  ));

  static bool isDemo(String token) => token == 'demo';

  Future<WebFormData> fetchForm(String token) async {
    if (isDemo(token)) return _demo();
    final res = await _dio.get(
      'public/public_form.php',
      queryParameters: {'token': token},
    );
    final data = res.data is Map ? res.data as Map : <String, dynamic>{};
    final survey = (data['survey'] ?? {}) as Map;
    final questions = ((data['questions'] ?? []) as List).map((q) {
      return QuestionModel(
        id: q['id'],
        title: '${q['title']}',
        order: q['order'] ?? 0,
        isRequired: q['isRequired'] == true || q['isRequired'] == 1,
        type: convertToQuestionType('${q['type']}'),
        answers: ((q['answers'] ?? []) as List)
            .map((a) => AnswerModel(a['id'], '${a['title']}',
                questionId: q['id'], imgName: a['img']))
            .toList(),
      );
    }).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    return WebFormData(
        '${survey['title'] ?? ''}', '${survey['description'] ?? ''}', questions);
  }

  Map<String, dynamic> buildPayload(
    String token,
    Map<String, String> respondent,
    List<MapEntry<QuestionModel, List<AnswerUserModel>>> answers,
  ) {
    return {
      'token': token,
      'respondent': respondent,
      'answers': [
        for (final e in answers)
          for (final a in e.value)
            {
              'question_id': e.key.id,
              'answer_id': a.answer_id,
              'content': a.content,
            },
      ],
    };
  }

  Future<void> submit(String token, Map<String, dynamic> payload) async {
    if (isDemo(token)) return;
    await _dio.post('public/public_submit.php', data: payload);
  }

  WebFormData _demo() {
    AnswerModel a(int id, String t) => AnswerModel(id, t);
    return WebFormData('استبيان تجريبي', 'نموذج لتجربة جميع أنواع الأسئلة', [
      QuestionModel(
          id: 1,
          title: 'ما رأيك بالمؤتمر؟',
          order: 1,
          isRequired: true,
          type: QuestionType.multipleChoice,
          answers: [a(11, 'ممتاز'), a(12, 'جيد'), a(13, 'مقبول')]),
      QuestionModel(
          id: 2,
          title: 'ما المحاور التي أعجبتك؟',
          order: 2,
          isRequired: false,
          type: QuestionType.checkbox,
          answers: [a(21, 'الطب الباطني'), a(22, 'الجراحة'), a(23, 'الأطفال')]),
      QuestionModel(
          id: 3,
          title: 'المدينة',
          order: 3,
          isRequired: false,
          type: QuestionType.dropdown,
          answers: [a(31, 'دمشق'), a(32, 'حلب'), a(33, 'حمص')]),
      QuestionModel(
          id: 4,
          title: 'ملاحظاتك',
          order: 4,
          isRequired: false,
          type: QuestionType.text,
          answers: [a(41, 'الإجابة')]),
      QuestionModel(
          id: 5,
          title: 'البريد الإلكتروني',
          order: 5,
          isRequired: false,
          type: QuestionType.email,
          answers: [a(51, 'email')]),
      QuestionModel(
          id: 6,
          title: 'تاريخ الحضور',
          order: 6,
          isRequired: false,
          type: QuestionType.date,
          answers: [a(61, 'date')]),
      QuestionModel(
          id: 7,
          title: 'هل ستحضر مرة أخرى؟',
          order: 7,
          isRequired: false,
          type: QuestionType.switchField,
          answers: [a(71, 'switch')]),
      QuestionModel(
          id: 8,
          title: 'قيّم التنظيم',
          order: 8,
          isRequired: false,
          type: QuestionType.rating,
          answers: [a(81, 'rating')]),
    ]);
  }
}
