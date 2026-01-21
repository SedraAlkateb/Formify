import 'package:formify/data/network/sqlite_factory.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/request.dart';
import 'package:sqflite/sqflite.dart';

abstract class AppSqlApiAbs {
  Future<String> asyncData(
      GetAsyncModel asyncData
      ) ;
  Future<void> deleteData();
  Future<List<UserRequest>> getDataSql();
}

class AppSqlApi extends AppSqlApiAbs {
  DatabaseHelper databaseHelper;
  AppSqlApi(this.databaseHelper);
  Future<void> initializeDatabase() async {
    await databaseFactory.debugSetLogLevel(sqfliteLogLevelVerbose);
  }

  @override
  Future<String> asyncData(
      GetAsyncModel asyncData
      ) async {
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

        for (final question in asyncData. questions) {
          batch.insert(
            'questions',
            question.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        for (final answer in  asyncData.answers) {
          batch.insert(
            'answers',
            answer.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        for (final sc in  asyncData.surveyConference) {
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

  @override
  Future<List<UserRequest>> getDataSql() async {
    final db = await databaseHelper.database;
    try {
      final List<Map<String, dynamic>> maps = await db.rawQuery('''
 SELECT users.*, users_answers.*
FROM users
JOIN users_answers ON users.id = users_answers.user_id;
    ''', []);
      if (maps.isNotEmpty) {
        return

          List.generate(maps.length, (i) {
          return UserRequest.fromMap(maps[i]);
        });
      } else {
        return [];
      }
    } catch (e) {
      throw Exception("حدث خطأ أثناء جلب المستشفيات: $e");
    }
  }

}
