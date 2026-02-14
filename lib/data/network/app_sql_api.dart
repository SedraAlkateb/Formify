import 'package:formify/data/network/sqlite_factory.dart';
import 'package:formify/domain/models/model_q.dart';
import 'package:formify/domain/models/models.dart';
import 'package:sqflite/sqflite.dart';

abstract class AppSqlApiAbs {
  Future<String> asyncData(GetAsyncModel asyncData);
  Future<void> deleteData();
  Future<List<UserSqlModel>> getDataSql();
  Future<GetAllConferenceModel?> getConference();
  Future<List<MainSurveyModel>> getSurveys();
  // Future<List<AnswerModel>> getAnswers();
  // Future<List<QuestionModel>> getQuestionAnswers();
  Future<List<QuestionModel>> getSurveyQuestionsWithAnswers(int surveyId);
  Future<void> insertUserWithAnswer(UserSqlModel user);
  //Future<List<AsyncQuestionModel>> getQuestions();
  Future<InfoConference> getConferenceInfo();
}

class AppSqlApi extends AppSqlApiAbs {
  DatabaseHelper databaseHelper;
  AppSqlApi(this.databaseHelper);
  Future<void> initializeDatabase() async {
    await databaseFactory.debugSetLogLevel(sqfliteLogLevelVerbose);
  }
  @override
  Future<InfoConference> getConferenceInfo() async {
    final db = await databaseHelper.database;

    final usersResult =
    await db.rawQuery('SELECT COUNT(*) AS count FROM users');
    final totalUsers =
        (usersResult.first['count'] as num?)?.toInt() ?? 0;

    // Total Surveys
    final surveysResult =
    await db.rawQuery('SELECT COUNT(*) AS count FROM survey');
    final totalSurveys =
        (surveysResult.first['count'] as num?)?.toInt() ?? 0;

    // Total filled surveys (each user + survey where user answered at least 1 question)
    final filledResult = await db.rawQuery(r'''
    SELECT COUNT(*) AS count
    FROM (
      SELECT ua.user_id, q.survey_id
      FROM users_answers ua
      JOIN answers a   ON a.id = ua.answer_id
      JOIN questions q ON q.id = a.question_id
      GROUP BY ua.user_id, q.survey_id
    ) t;
  ''');

    final totalCompletedSurveys =
        (filledResult.first['count'] as num?)?.toInt() ?? 0;

    return InfoConference(
      totalUsers,
      totalSurveys,
      totalCompletedSurveys,
    );
  }
  @override
  Future<List<QuestionModel>> getSurveyQuestionsWithAnswers(
    int surveyId,
  ) async {
    final db = await databaseHelper.database;

    final rows = await db.rawQuery(
      '''
      
    SELECT
      q.id              AS q_id,
      q.question        AS q_question,
      q.question_order  AS q_order,
      q.is_required     AS q_required,
      q.type            AS q_type,

      a.id              AS a_id,
      a.title           AS a_title,
      a.img             AS a_img
    FROM questions q
    LEFT JOIN answers a ON a.question_id = q.id
    WHERE q.survey_id = ?
    ORDER BY q.question_order ASC, a.id ASC;
  ''',
      [surveyId],
    );
    // نجمعهم حسب السؤال
    final Map<int, Map<String, dynamic>> qMap = {};
    final Map<int, List<AnswerModel>> aMap = {};

    for (final r in rows) {
      final qId = r['q_id'] as int;

      qMap.putIfAbsent(qId, () {
        return {
          'id': qId,
          'question': r['q_question'],
          'question_order': r['q_order'],
          'is_required': r['q_required'],
          'type': r['q_type'],
        };
      });

      final aId = r['a_id'];
      if (aId != null) {
        aMap.putIfAbsent(qId, () => []);
        aMap[qId]!.add(AnswerModel(aId as int, r['a_title'] as String,imgName: r['a_img']as String?));
      }
    }
    final result = <QuestionModel>[];
    for (final entry in qMap.entries) {
      final qId = entry.key;
      final qRow = entry.value;
      final answers = aMap[qId] ?? [];
      result.add(
        QuestionModel(
          id: qRow['id'] as int,
          title: qRow['question'] as String,
          order: (qRow['question_order'] as int?) ?? 0,
          isRequired: ((qRow['is_required'] as int?) ?? 0) == 1,
          type: convertToQuestionType((qRow['type'] as String?) ?? 'text'),
          answers: answers,
        ),
      );
    }

    return result;
  }

  @override
  Future<String> asyncData(GetAsyncModel asyncData) async {
    try {
      final db = await databaseHelper.database;

      await db.transaction((txn) async {
        final batch = txn.batch();

        batch.insert(
          'conference',
          asyncData.conferenceModel.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        for (final survey in asyncData.surveys) {
          batch.insert(
            'survey',
            survey.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        for (final question in asyncData.questions) {
          batch.insert(
            'questions',
            question.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        for (final answer in asyncData.answers) {
          batch.insert(
            'answers',
            answer.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        for (final sc in asyncData.surveyConference) {
          batch.insert(
            'survey_conference',
            sc.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        await batch.commit(noResult: true);
      });

      return "";
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Future<void> deleteData() async {
    final db = await databaseHelper.database;
    final tables = [
      'users',
      'conference',
      'survey',
      'questions',
      'answers',
      'users_answers',
      'survey_conference',
    ];
    Batch batch = db.batch();
    for (var table in tables) {
      batch.delete(table);
    }
    await batch.commit(noResult: true);
  }

  // Future<List<UserSqlModel>> getDataSql() async {
  //   final db = await databaseHelper.database;
  //
  //   try {
  //     final List<Map<String, dynamic>> maps = await db.rawQuery('''
  //     SELECT users.*, GROUP_CONCAT(users_answers.answer_id) AS answer_ids,
  //            GROUP_CONCAT(users_answers.content) AS answer_contents
  //     FROM users
  //     LEFT JOIN users_answers ON users.id = users_answers.user_id
  //     GROUP BY users.id;
  //   ''');
  //
  //     return List.generate(maps.length, (i) {
  //       var map = maps[i];
  //
  //       // تقسيم الـ 'answer_ids' و 'answer_contents' إلى قوائم
  //       List<String> answerIds = map['answer_ids']?.split(',') ?? [];
  //       List<String> answerContents = map['answer_contents']?.split(',') ?? [];
  //
  //       // تحويل الإجابات إلى قائمة من AnswerUserModel
  //       List<AnswerUserModel> answers = [];
  //       for (int i = 0; i < answerIds.length; i++) {
  //         answers.add(AnswerUserModel(
  //          int.parse(answerIds[i]),
  //       answerContents[i],
  //         ));
  //       }
  //
  //       // إعادة بناء كائن المستخدم مع الإجابات
  //       return UserSqlModel(
  //         fullName: map['fullname'],
  //         email: map['email'],
  //         phone: map['phone'],
  //         address: map['address'],
  //         answerModel: answers,
  //       );
  //     });
  //   } catch (e) {
  //     throw Exception("حدث خطأ أثناء جلب المستخدمين والإجابات: $e");
  //   }
  // }
  @override
  Future<List<UserSqlModel>> getDataSql() async {
    final db = await databaseHelper.database;

    final maps = await db.rawQuery('''
    SELECT
      users.id            AS user_id,
      users.fullname      AS fullname,
      users.email         AS email,
      users.phone         AS phone,
      users.address       AS address,
      users_answers.answer_id AS answer_id,
      users_answers.content   AS content
    FROM users
    JOIN users_answers ON users.id = users_answers.user_id;
  ''');

    final Map<int, UserSqlModel> usersMap = {};

    for (final row in maps) {
      final int userId = row['user_id'] as int;

      usersMap.putIfAbsent(
        userId,
            () => UserSqlModel(
          fullName: row['fullname'] as String,
          email: row['email'] as String,
          phone: row['phone'] as String,
          address: row['address'] as String,
          answerModel: <AnswerUserModel>[],
        ),
      );
//Image.memory(model.imageBlob)
      //final bytes = await File(imagePath).readAsBytes();
      usersMap[userId]!.answerModel.add(
        AnswerUserModel(
          row['answer_id'] as int,
          row['content'] as String,
        ),
      );
    }

    return usersMap.values.toList();
  }

  //  @override
  //   Future<List<UserSqlModel>> getDataSql() async {
  //     final db = await databaseHelper.database;
  //     try {
  //       final List<Map<String, dynamic>> maps = await db.rawQuery('''
  //  SELECT users.*, users_answers.*
  // FROM users
  // JOIN users_answers ON users.id = users_answers.user_id;
  //     ''', []);
  //       if (maps.isNotEmpty) {
  //
  //         // return AllUserModel(
  //         //   List.generate(maps.length, (i) {
  //         //     return UserSqlModel.fromMap(maps[i]);
  //         //   }),
  //         // );
  //       } else {
  //         return [];
  //       }
  //     } catch (e) {
  //       throw Exception("حدث خطأ أثناء جلب المستشفيات: $e");
  //     }
  //   }

  @override
  @override
  Future<GetAllConferenceModel?> getConference() async {
    final db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query('conference');

    if (maps.isEmpty) {
      return null;
    }

    return GetAllConferenceModel.fromMap(maps.first);
  }



  @override
  Future<List<MainSurveyModel>> getSurveys() async {
    final db = await databaseHelper.database;
    List<Map<String, dynamic>> maps;
    maps = await db.query('survey');
    return List.generate(maps.length, (i) {
      return MainSurveyModel.fromMap(maps[i]);
    });
  }

  @override
  Future<void> insertUserWithAnswer(UserSqlModel user) async {
    final db = await databaseHelper.database;
    await db.transaction((txn) async {
      int userId = await txn.insert('users', user.toJsonSql());
      for (var answer in user.answerModel) {
        await txn.insert('users_answers', answer.toJsonSql(userId));
      }
    });
  }
}

/*
  @override
  Future<List<AsyncQuestionModel>> getQuestions() async {
    final db = await databaseHelper.database;
    List<Map<String, dynamic>> maps;

    maps = await db.query('questions');
    return List.generate(maps.length, (i) {
      return AsyncQuestionModel.fromMap(maps[i]);
    });
  }

  @override
  Future<List<AnswerModel>> getAnswers() async {
    final db = await databaseHelper.database;
    List<Map<String, dynamic>> maps;
    maps = await db.rawQuery('''
SELECT
  q.id            AS question_id,
  q.question      AS question_text,
  q.question_order,
  q.is_required,
  q.type,

  a.id            AS answer_id,
  a.title         AS answer_title

FROM questions q
LEFT JOIN answers a ON a.question_id = q.id
WHERE q.survey_id = ?
ORDER BY q.question_order ASC, a.id ASC;
''', []);
    return List.generate(maps.length, (i) {
      return AnswerModel.fromMap(maps[i]);
    });
  }
 */
