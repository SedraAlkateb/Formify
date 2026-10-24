import 'package:formify/domain/models/model_q.dart';
import 'package:formify/domain/models/models.dart';

/// Converts a FormBuilder raw value into the rows stored in `users_answers`.
/// Same rules as SyncBloc._mapToAnswers, without the Bloc/SQLite dependency.
List<AnswerUserModel> mapToAnswers(QuestionModel q, dynamic rawValue) {
  if (rawValue == null) return [];

  if (rawValue is AnswerModel) {
    return [AnswerUserModel(rawValue.id, rawValue.title, rawValue.isCorrect)];
  }
  if (rawValue is List) {
    return rawValue
        .whereType<AnswerModel>()
        .map((a) => AnswerUserModel(a.id, a.title, a.isCorrect))
        .toList();
  }

  if (q.type == QuestionType.autocomplete && rawValue is String) {
    final match = q.answers.where((a) => a.title == rawValue);
    if (match.isNotEmpty) {
      final a = match.first;
      return [AnswerUserModel(a.id, a.title, a.isCorrect)];
    }
  }

  final content = _stringify(rawValue);
  if (content == null || content.isEmpty) return [];

  // free-value types are stored against the question's placeholder option
  final placeholder = q.answers.isNotEmpty ? q.answers.first : null;
  return [
    AnswerUserModel(placeholder?.id, content, placeholder?.isCorrect ?? 0),
  ];
}

String? _stringify(dynamic v) {
  if (v is bool) return v ? '1' : '0';
  if (v is DateTime) return v.toIso8601String();
  if (v is String || v is num) return v.toString();
  return null;
}
