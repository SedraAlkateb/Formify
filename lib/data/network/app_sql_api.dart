import 'package:formify/data/network/sqlite_factory.dart';
import 'package:formify/domain/models/mock_users.dart';
import 'package:formify/domain/models/model_q.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/user_type.dart';
import 'package:sqflite/sqflite.dart';

abstract class AppSqlApiAbs {
  Future<String> asyncData(GetAsyncModel asyncData);
  Future<void> deleteData();
  Future<void> deleteDataForSave();

  Future<String> insertDataForSave(DataForSaveModel asyncData);

  Future<void> insertDoctor(UserModel doctor);
  Future<void> insertAllUsers(List<UserModel> users);
  Future<List<UserSqlModel>> getDataSql();
  Future<GetAllConferenceModel?> getConference();
  Future<List<MainSurveyModel>> getSurveys();
  Future<List<QuestionModel>> getSurveyQuestionsWithAnswers(int surveyId);
  Future<void> insertUserWithAnswer(UserSqlModel user);
  Future<InfoConference> getConferenceInfo();
  Future<List<UserModel>> getDoctors();
  Future<List<UserModel>> getUserConference(int conferenceId);
  Future<void> updateUser(UserModel user);
  Future<List<UserModel>> getAllImportantDoctorNotCome(List<UserModel> users);
  Future<List<DoctorMockItem>> refreshAndSyncUsers();
  Future<void> updateIsDone(int isDone,int doctorId);
}

class AppSqlApi extends AppSqlApiAbs {
  DatabaseHelper databaseHelper;

  AppSqlApi(this.databaseHelper);

  List<DoctorMockItem> usersList = MockModel.usersList;

  Future<void> initializeDatabase() async {
    await databaseFactory.debugSetLogLevel(sqfliteLogLevelVerbose);
  }

  @override
  Future<InfoConference> getConferenceInfo() async {
    final db = await databaseHelper.database;

    final usersResult = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM users',
    );
    final totalUsers = (usersResult.first['count'] as num?)?.toInt() ?? 0;

    // Total Surveys
    final surveysResult = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM survey',
    );
    final totalSurveys = (surveysResult.first['count'] as num?)?.toInt() ?? 0;

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

    return InfoConference(totalUsers, totalSurveys, totalCompletedSurveys);
  }

  @override
  Future<List<QuestionModel>> getSurveyQuestionsWithAnswers(
      int surveyId,) async {
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
      a.img             AS a_img,
      a.isCorrect       AS a_isCorrect
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
        aMap[qId]!.add(
          AnswerModel(
            aId as int,
            r['a_title'] as String,
            imgName: r['a_img'] as String?,
            isCorrect: r['a_isCorrect'] as int,
          ),
        );
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

        // 1. إدخال الاختصاصات العامة القادمة من السيرفر
        for (final sp in asyncData.spec) {
          batch.insert(
            'spec',
            sp.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        batch.insert(
          'conference',
          asyncData.conferenceModel.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        // 3. إدخال جدول الربط (sp_conference) - الآن الاختصاص ID 1 موجود حتماً في الأعلى!
          for (final sp in asyncData.conferenceModel.spec) {
            batch.insert(
              'sp_conference',
              {
                'specId': sp.id,
                'conferenceId': asyncData.conferenceModel.id
              },
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }


        // 4. إدخال بقية الجداول المرتبطة بالترتيب الصحيح
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

        for (final at in asyncData.users) {
          batch.insert(
            'all_users',
            at.toJsonSql(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        // تنفيذ كل العمليات المترابطة دفعة واحدة ككتلة سليمة
        await batch.commit(noResult: true);
      });

      return ""; // المزامنة تمت بنجاح تام
    } catch (e) {
      print("❌ خطأ المزامنة الضخمة: $e");
      return e.toString();
    }
  }

  @override
  Future<void> deleteData() async {
    final db = await databaseHelper.database;
    final tables = [
      'all_users',
      'conference',
      'spec',
      'survey',
      'questions',
      'answers',
      'users_answers',
      'survey_conference',
      'user_conference',
      'sp_conference',
    ];
    Batch batch = db.batch();
    for (var table in tables) {
      batch.delete(table);
    }
    await batch.commit(noResult: true);
  }
  @override
  Future<void> deleteDataForSave() async {
    final db = await databaseHelper.database;
    final tables = [
      'all_users',
      'users_answers',
      'user_conference',
    ];
    Batch batch = db.batch();
    for (var table in tables) {
      batch.delete(table);
    }
    await batch.commit(noResult: true);
  }
  @override
  Future<String> insertDataForSave(DataForSaveModel asyncData) async {
    try {
      final db = await databaseHelper.database;

      await db.transaction((txn) async {
        final batch = txn.batch();

        for (final at in asyncData.users) {
          batch.insert(
            'all_users',
            at.toJsonSql(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        for (final at in asyncData.answerUser) {
          batch.insert(
            'users_answers',
            at.toJsonSql(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        for (final at in asyncData.userConference) {
          batch.insert(
            'user_conference',
            at.toJsonSql(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        await batch.commit(noResult: true);
      });

      return ""; // المزامنة تمت بنجاح تام
    } catch (e) {
      print("❌ خطأ المزامنة الضخمة: $e");
      return e.toString();
    }
  }

  @override
  Future<void> deleteUser() async {
    final db = await databaseHelper.database;
    Batch batch = db.batch();
    batch.update("users", {'isUpload': 1});
    batch.delete("all_users");

    // 3. تنفيذ كافة العمليات المخزنة في الـ Batch
    // noResult: true تستخدم عندما لا نحتاج لمعرفة عدد الأسطر التي تأثرت، وهي أسرع في التنفيذ
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
    try {
      final db = await databaseHelper.database;

      // 1. استعلام الـ SQL مع الفلترة
      final maps = await db.rawQuery('''
      SELECT 
        users.id            AS user_id,
        users.fullname      AS fullname,
        users.email         AS email,
        users.phone         AS phone,
        users.address       AS address,
        users.notes       AS notes,
        users.type_id       AS type_id,
        users.user_id       AS user_type_id,
        users_answers.answer_id AS answer_id,
        users_answers.content   AS content,
        users_answers.isCorrect AS isCorrect
      FROM users
      LEFT JOIN users_answers ON users.id = users_answers.user_id
      WHERE users.isUpload = 0;
    ''');

      // إذا لم تكن هناك بيانات، نختصر الوقت ونعيد قائمة فارغة مباشرة
      if (maps.isEmpty) {
        return <UserSqlModel>[];
      }

      final Map<int, UserSqlModel> usersMap = {};

      for (final row in maps) {
        // حماية إضافية في حال كان الـ ID مفقوداً أو ليس رقماً صريحاً
        final dynamic rawUserId = row['user_id'];
        if (rawUserId == null) continue; // تخطي السطر الفاسد بأمان

        final int userId = rawUserId as int;

        usersMap.putIfAbsent(
          userId,
              () =>
              UserSqlModel(
                  fullName: (row['fullname'] ?? "مستخدم بدون اسم") as String,
                  email: row['email'] as String?,
                  phone: (row['phone'] as String? ?? "").isEmpty
                      ? "09"
                      : row['phone'] as String,
                  address: row['address'] as String?,
                  // تحصين تحويل الـ type_id لتجنب خطأ الـ NullPointerException
                  userType: userTypeFromId((row['type_id'] ?? 0) as int),
                  userId: row['user_type_id'] as int,
                  answerModel: <AnswerUserModel>[],
                  notes: row['notes'] as String?
              ),
        );

        // 2. التحقق من حقل الإجابة بشكل آمن
        if (row['answer_id'] != null) {
          usersMap[userId]!.answerModel.add(
            AnswerUserModel(
              row['answer_id'] as int,
              (row['content'] ?? "") as String,
              (row['isCorrect'] ?? 0) as int,
            ),
          );
        }
      }

      return usersMap.values.toList();
    } catch (e, stackTrace) {
      // التقاط الخطأ وطباعته في الـ Console لمعرفته وحله أثناء التطوير
      print("❌ حدث خطأ أثناء جلب البيانات من SQL (getDataSql): $e");
      print("StackTrace: $stackTrace");

      // إعادة قائمة فارغة بدلاً من جعل التطبيق ينهار (Crash)
      return <UserSqlModel>[];
    }
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
  Future<GetAllConferenceModel?> getConference() async {
    try {
      final db = await databaseHelper.database;

      // 1. جلب أول مؤتمر فقط من جدول المؤتمرات (أصغر ID)
      final List<Map<String, dynamic>> conferenceMaps = await db.query(
        'conference',
        limit: 1,
        orderBy: 'id ASC', // ترتيب تصاعدي لضمان جلب أول مؤتمر تم إدخاله
      );

      // إذا كان جدول المؤتمرات فارغاً تماماً، نخرج ونعيد null
      if (conferenceMaps.isEmpty) {
        return null;
      }

      // تحويل السطر المرجّع إلى كائن المؤتمر الأساسي (وقائمة الاختصاصات فارغة حالياً)
      final Map<String, dynamic> firstConfRow = conferenceMaps.first;
      final GetAllConferenceModel conference = GetAllConferenceModel(
        firstConfRow['id'] as int,
        (firstConfRow['name'] ?? "") as String,
        (firstConfRow['description'] ?? "") as String,
        (firstConfRow['address'] ?? "") as String,
        (firstConfRow['start_date'] ?? "") as String,
        (firstConfRow['end_date'] ?? "") as String,
        (firstConfRow['is_active'] ?? 0) == 1,
        <SpecModel>[], // قائمة فارغة سنملؤها في الخطوة التالية
      );

      // 2. جلب الاختصاصات المرتبطة بهذا المؤتمر المحدد عبر الـ ID الخاص به
      final List<Map<String, dynamic>> specMaps = await db.rawQuery('''
      SELECT 
        spec.id     AS spec_id,
        spec.title  AS spec_title
      FROM sp_conference
      INNER JOIN spec ON sp_conference.specId = spec.id
      WHERE sp_conference.conferenceId = ?;
    ''', [conference.id]); // تمرير ID أول مؤتمر جلبناه

      // 3. الدوران حول الاختصاصات المسترجعة (إن وجدت) وحقنها داخل المؤتمر
      for (final row in specMaps) {
        conference.spec.add(
          SpecModel(
            row['spec_id'] as int,
            (row['spec_title'] ??
                "") as String, // مطابقة حقل title مع خاصية name في الـ Model
          ),
        );
      }

      // إعادة كائن أول مؤتمر بعد أن أصبحت قائمة اختصاصاته مكتملة
      return conference;
    } catch (e, stackTrace) {
      print("❌ خطأ أثناء جلب أول مؤتمر واختصاصاته: $e");
      print("StackTrace: $stackTrace");
      return null; // ضمان عدم انهيار التطبيق
    }
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

  @override
  Future<void> insertDoctor(UserModel doctor) async {
    final db = await databaseHelper.database;
    await db.transaction((txn) async {
      await txn.insert('users', doctor.toJson());
    });
  }

  ////////////////// تخزين كل المستخدمين
  @override
  Future<void> insertAllUsers(List<UserModel> users) async {
    // 1. الحصول على نسخة من قاعدة البيانات
    final db = await databaseHelper.database;

    // 2. بدء عملية "Transaction" لضمان السرعة والأمان
    await db.transaction((txn) async {
      // 3. التكرار على كل مستخدم (User) موجود في القائمة الممررة
      for (var user in users) {
        // 4. إدخال بيانات المستخدم الحالي في جدول 'all_users'
        // يتم تحويل الـ Model إلى Map باستخدام toJson()
        await txn.insert(
          'all_users',
          user.toJsonSql(),
          // استخدام conflictAlgorithm يمنع توقف التطبيق في حال تكرار نفس المستخدم
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
    // عند انتهاء الحلقة، يتم اعتماد (Commit) جميع الإدخالات مرة واحدة
  }

  //////////////////// لجلب الاطباء المهمين
  @override
  Future<List<UserModel>> getDoctors() async {
    final db = await databaseHelper.database;

    // إضافة شرط التصفية (Filter) بناءً على type_id
    final List<Map<String, dynamic>> maps = await db.query(
      'all_users',
      where: 'type_id = ?',
      whereArgs: [6],
    );

    return List.generate(maps.length, (i) {
      return UserModel.fromMap(maps[i]);
    });
  }

  /// جلب كحل المستخدمين الخاصين بالكونفيرنس
  @override
  /// جلب كل المستخدمين المسجلين في مؤتمر معين بناءً على الـ conferenceId
  @override
  Future<List<UserModel>> getUserConference(int conferenceId) async {
    final db = await databaseHelper.database;

    // نقوم بعمل JOIN وتصفية النتائج باستخدام حقل الـ conferenceId
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT 
      u.id, 
      u.server_user_id, 
      u.fullname, 
      u.phone, 
      u.email, 
      u.address, 
      u.type_id, 
      u.notes, 
      u.specId,
      u.is_local_new,
      u.is_modified,
      u.is_uploaded
    FROM user_conference uc
    INNER JOIN all_users u ON uc.user_id = u.id
    WHERE uc.conference_id = ?
  ''', [conferenceId]);

    // تحويل البيانات المسترجعة إلى قائمة من UserModel
    return List.generate(maps.length, (i) {
      return UserModel.fromMap(maps[i]);
    });
  }

  @override
  Future<void> updateUser(UserModel user) async {
    final db = await databaseHelper.database;

    final Map<String, dynamic> userMap = {
      ...user.toJson(),
      //   'isUpload': 1, // سنفترض أن أي تعديل محلي يجعل السجل بحاجة للرفع مجدداً
    };

    int count = await db.update(
      'all_users',
      userMap,
      where: 'id = ?',
      whereArgs: [user.id],
    );
    if (count == 0) {
      // إذا كان count يساوي 0، فهذا يعني أن الشرط لم يتحقق (السجل مرفوع مسبقاً أو غير موجود)
      throw Exception(
        "عذراً، لا يمكن تعديل هذا المستخدم لأنه تم رفعه مسبقاً إلى السيرفر.",
      );
    }

    // إذا وصل الكود إلى هنا، فهذا يعني أن التحديث تم بنجاح
  }

  /// الطريقة الأكثر كفاءة لجلب الأطباء (نوع 6) وتحويلهم مباشرة إلى قائمة UserModel
  @override
  Future<List<UserModel>> getAllImportantDoctorNotCome(
      List<UserModel> users ) async {
    // 1. الحصول على نسخة من قاعدة البيانات
    final db = await databaseHelper.database;

    // 2. تحويل قائمة المستخدمين (الباراميتر) إلى قائمة أسماء فقط للمقارنة
    // نستخدم .map لاستخراج fullname ونحولها لـ List<String>
    List<String> namesInParam = users.map((u) => u.fullName).toList();

    // 3. التحقق إذا كانت القائمة فارغة
    // إذا كانت فارغة، سنحتاج لجلب كل الأطباء من نوع 6 دون استثناء
    if (namesInParam.isEmpty) {
      final List<Map<String, dynamic>> allImportant = await db.query(
        'all_users',
        where: 'type_id = ?',
        whereArgs: [6],
      );
      return allImportant.map((map) => UserModel.fromMapSql(map)).toList();
    }

    // 4. بناء الاستعلام باستخدام 'NOT IN'
    // نستخدم علامات الاستفهام لضمان الأمان ومنع SQL Injection
    String placeholders = List.filled(namesInParam.length, '?').join(',');

    final List<Map<String, dynamic>> results = await db.rawQuery('''
    SELECT * 
    FROM all_users 
    WHERE type_id = 6 
    AND fullname NOT IN ($placeholders)
  ''', namesInParam); // نمرر قائمة الأسماء هنا كـ whereArgs

    // 5. تحويل النتائج إلى قائمة UserModel وإعادتها
    return results.map((map) => UserModel.fromMapSql(map)).toList();
  }

  @override
  Future<List<DoctorMockItem>> refreshAndSyncUsers() async {
    try {
      final db = await databaseHelper.database;

      // 🔥 إضافة orderBy لترتيب الحاضرين (1) في البداية تلقائياً
      final List<Map<String, dynamic>> maps = await db.query(
        'doctor',
        orderBy: 'isDone DESC',
      );

      return maps.map((row) {
        return DoctorMockItem(
          id: row['id'] as int,
          name: row['name'] as String,
          isDone: row['isDone'] as int,
        );
      }).toList();
    } catch (e, stackTrace) {
      print("❌ خطأ أثناء جلب قائمة الدكاترة من جدول doctor: $e");
      print("StackTrace: $stackTrace");

      return <DoctorMockItem>[];
    }
  }
  @override
  Future<void> updateIsDone(int isDone, int doctorId) async {
    // تنفيذ استعلام التحديث في قاعدة البيانات
    final db = await databaseHelper.database;
    await db.update(
      'doctor',
      {'isDone': isDone},
      where: 'id = ?',
      whereArgs: [doctorId],
    );
  }
}