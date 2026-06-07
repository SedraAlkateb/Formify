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
  Future<List<SpecModel>> getSpec();
  Future<List<UserModel>> getUsersBySpecIdAndName(int specId, String name);
  Future<void> deleteUser();
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
  Future<AddAndModifyUsersRequest> getUserAddAndModify();
  Future<void> addServerIdToUser(List<AddModifyUser>usersId);
  Future<SyncUsersRequest> getConferenceAndAnswers(int conferenceId);
  Future<void> deleteSyncData();
  Future<void> addSyncData(SaveDataBaseModel baseData);
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
      'SELECT COUNT(*) AS count FROM all_users',
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

      // استخدام الـ Transaction لضمان (إما نجاح كل شيء أو إلغاء كل شيء)
      await db.transaction((txn) async {
        // نربط الـ batch بالـ txn مباشرة ليكون جزءاً من الترانزاكشن
        final batch = txn.batch();

        // 1. إدخال الاختصاصات العامة القادمة من السيرفر
        for (final sp in asyncData.spec) {
          batch.insert(
            'spec',
            sp.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        // 2. إدخال المؤتمر
        batch.insert(
          'conference',
          asyncData.conferenceModel.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        // 3. إدخال جدول الربط (sp_conference)
        if (asyncData.conferenceModel.spec != null) {
          for (final sp in asyncData.conferenceModel.spec!) {
            batch.insert(
              'sp_conference',
              {
                'specId': sp.id,
                'conferenceId': asyncData.conferenceModel.id
              },
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
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

        // 🔥 هنا التعديل: حذف كافة المستخدمين القدامى محلياً قبل حقن القائمة الجديدة
        batch.delete('all_users');

        // 5. حقن قائمة المستخدمين الجديدة النظيفة القادمة من السيرفر
        for (final at in asyncData.users) {
          batch.insert(
            'all_users',
            at.toJsonSqlForFirst(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        await batch.commit(noResult: true);
      });

      return ""; // المزامنة تمت بنجاح تام
    } catch (e) {
      // إذا حدث أي خطأ في الإدخال بعد الحذف، سيتراجع الترانزاكشن تلقائياً وتعود البيانات المحذوفة!
      print("❌ خطأ المزامنة الضخمة وتم عمل Rollback تلقائي: $e");
      return e.toString();
    }
  }
  @override
  Future<void> deleteData() async {
    final db = await databaseHelper.database;
    final tables = [
      'conference',
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
            at.toJsonSqlForFirst(),
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
    batch.update("all_users", {'isUpload': 1});
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
        all_users.id            AS user_id,
        all_users.fullname      AS fullname,
        all_users.email         AS email,
        all_users.phone         AS phone,
        all_users.address       AS address,
        all_users.notes       AS notes,
        all_users.type_id       AS type_id,
        all_users.user_id       AS user_type_id,
        users_answers.answer_id AS answer_id,
        users_answers.content   AS content,
        users_answers.isCorrect AS isCorrect
      FROM all_users
      LEFT JOIN users_answers ON all_users.id = users_answers.user_id
      WHERE all_users.isUpload = 0;
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
                user: UserModel(  (row['fullname'] ?? "مستخدم بدون اسم") as String,
                    row['email'] as String?,
                     (row['phone'] as String? ?? "").isEmpty
                        ? "09"
                        : row['phone'] as String,
                     row['address'] as String?, userTypeFromId((row['type_id'] ?? 0) as int)
                    , row['notes'] as String?),

                  answerModel: <AnswerUserModel>[],

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

  @override
  Future<AddAndModifyUsersRequest> getUserAddAndModify() async {
    try {
      final db = await databaseHelper.database;

      // 1️⃣ جلب المستخدمين الجدد كلياً مع اختصاصاتهم (is_local_new = 1) باستخدام LEFT JOIN
      final List<Map<String, dynamic>> newUsersMaps = await db.rawQuery('''
      SELECT 
        u.*, 
        s.id AS spec_id_joined, 
        s.title AS spec_title_joined
      FROM all_users u
      LEFT JOIN spec s ON u.specId = s.id
      WHERE u.is_local_new = ? AND u.isUpload = ?
    ''', [1, 0]);

      // 2️⃣ جلب المستخدمين المعدلين مع اختصاصاتهم (is_modified = 1) باستخدام LEFT JOIN
      final List<Map<String, dynamic>> modifyUsersMaps = await db.rawQuery('''
      SELECT 
        u.*, 
        s.id AS spec_id_joined, 
        s.title AS spec_title_joined
      FROM all_users u
      LEFT JOIN spec s ON u.specId = s.id
      WHERE u.server_user_id IS NOT NULL AND u.is_modified = ? AND u.isUpload = ?
    ''', [1, 0]);

      // 3️⃣ تحويل الـ Maps القادمة من الداتا بيز إلى قائمة من UserModel
      // (الآن أصبح الـ fromMap قادراً على قراءة الاختصاص لأن الأسماء المطابقة تم جلبها بالـ Alias AS)
      final List<UserModel> newUsersList = List.generate(newUsersMaps.length, (i) {
        return UserModel.fromMap(newUsersMaps[i]);
      });

      final List<UserModel> modifyUsersList = List.generate(modifyUsersMaps.length, (i) {
        return UserModel.fromMap(modifyUsersMaps[i]);
      });

      // 4️⃣ إعادة الكائن المطلوب محقوناً بالقوائم الصحيحة
      return AddAndModifyUsersRequest(modifyUsers: modifyUsersList, newUsers: newUsersList);

    } catch (e, stackTrace) {
      print("❌ حدث خطأ أثناء جلب بيانات الإضافة والتعديل من SQL: $e");
      print("StackTrace: $stackTrace");

      return AddAndModifyUsersRequest(modifyUsers: <UserModel>[], newUsers: <UserModel>[]);
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
    // 📥 [المدخلات - INPUT]: طباعة البيانات القادمة إلى التابع قبل المعالجة
    print("================ 📥 بداية عملية الحفظ (المفصولة والمحسنة) 📥 ================");
    print("ID المحلي الحالي: ${user.user.id}");
    print("اسم المستخدم/الطبيب: ${user.user.fullName}");
    print("-------------------------------------------------------");

    // 1️⃣ الحصول على نسخة من قاعدة البيانات المحلية
    final db = await databaseHelper.database;

    // 2️⃣ بدء معاملة موحدة (Transaction) لضمان أمان وحفظ البيانات بالكامل معاً
    await db.transaction((txn) async {
      int userId;

      // ================= الجزء الأول: معالجة بيانات المستخدم والإجابات القديمة =================
      if (user.user.id != null) {
        // 📑 حالة تعديل مستخدم موجود مسبقاً
        userId = user.user.id!;

        // أ) تحديث بيانات المستخدم في جدول 'all_users'
        int updatedRowsCount = await txn.update(
          'all_users',
          user.toJsonSql(),
          where: 'id = ?',
          whereArgs: [userId],
        );
        print("🔄 [تعديل]: تم تحديث بيانات المستخدم في 'all_users'. ID: $userId (السجلات المتأثرة: $updatedRowsCount)");

        // ب) مسح الإجابات القديمة لهذا المستخدم لمنع تكرارها
        int deletedAnswersCount = await txn.delete(
          'users_answers',
          where: 'user_id = ?',
          whereArgs: [userId],
        );
        print("🗑️ [تنظيف]: تم مسح ($deletedAnswersCount) من الإجابات القديمة للمستخدم $userId.");

      } else {
        // 📑 حالة مستخدم جديد كلياً
        // أ) نقوم بإدراج المستخدم الجديد وتوليد معرف محلي (userId) تلقائياً
        userId = await txn.insert(
          'all_users',
          user.toJsonSql(),
        );
        print("🆕 [إضافة]: تم إدراج مستخدم جديد في جدول 'all_users'. تم توليد ID محلي جديد: $userId");
      }

      // ================= الجزء الثاني: خطوة المؤتمر الموحدة (مرة واحدة لكافة الحالات) =================
      // 🔍 نقوم بفحص وجود المستخدم في جدول user_conference مرة واحدة فقط هنا، لأن userId أصبح جاهزاً ومضموناً من الخطوة السابقة
      final List<Map<String, dynamic>> existingConference = await txn.query(
        'user_conference',
        where: 'user_id = ?',
        whereArgs: [userId],
      );

      // ✨ إذا لم يجد السجل (المصفوفة فارغة) يقوم بالإدخال، وإلا يتخطى العملية تماماً في حال وجوده مسبقاً
      if (existingConference.isEmpty) {
        final Map<String, dynamic> conferenceRow = {
          'user_id': userId,
          'isUpload': 0 // 0 تعني ارتباط محلي بحاجة للمزامنة
        };
        await txn.insert('user_conference', conferenceRow);
        print("🎯 [خطوة المؤتمر الموحدة]: لم يكن مسجلاً، تم إدراجه الآن بنجاح للمعرّف: $userId");
      } else {
        print("⏭️ [خطوة المؤتمر الموحدة]: المستخدم مسجّل مسبقاً في المؤتمر، تم التخطي بدون تعديل.");
      }

      // ================= الجزء الثالث: حفظ الإجابات الجديدة =================
      print("📝 البدء في حفظ الإجابات في جدول 'users_answers' للمعرف ($userId):");
      for (var answer in user.answerModel) {
        final Map<String, dynamic> answerData = answer.toJsonSql(userId);
        await txn.insert('users_answers', answerData);
        print("   🔹 تم إدراج إجابة مرتبطة -> البيانات: $answerData");
      }
    });

    print("================ 📤 نهاية عملية الحفظ بنجاح 📤 ================");
  }
  @override
  Future<void> insertDoctor(UserModel doctor) async {
    final db = await databaseHelper.database;
    await db.transaction((txn) async {
      await txn.insert('all_users', doctor.toJson());
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
          user.toJsonSqlForFirst(),
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
  /// تابع جلب جميع المستخدمين المشاركين في المؤتمر الحالي مع جلب اختصاصاتهم الطبية
  Future<List<UserModel>> getUserConference(int conf) async {
    // 1️⃣ الحصول على نسخة من قاعدة البيانات المحلية
    final db = await databaseHelper.database;

    // 2️⃣ إجراء عملية الدمج (JOIN) لجلب المستخدمين مع تفاصيل اختصاصاتهم الطبية
    // قمنا بإضافة LEFT JOIN مع جدول spec للتأكد من جلب اسم الاختصاص حتى لو لم يكن للطبيب اختصاص محدد
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
      u.is_local_new,
      u.is_modified,
      u.isUpload,
      -- ✨ جلب بيانات الاختصاص وتسميتها لتطابق دالة UserModel.fromMap
      s.id AS spec_id_joined,
      s.title AS spec_title_joined
    FROM user_conference uc
    INNER JOIN all_users u ON uc.user_id = u.id
    LEFT JOIN spec s ON u.specId = s.id
  ''');

    print("📊 [قاعدة البيانات]: تم جلب (${maps.length}) مستخدمين مرتبطيين بالمؤتمر مع اختصاصاتهم الطبية.");

    // 3️⃣ تحويل البيانات المسترجعة (قائمة الخرائط Maps) إلى قائمة من الموديلات UserModel
    // الدالة المصنعية fromMap ستتلقى الآن spec_id_joined و spec_title_joined وتبني كائن SpecModel تلقائياً
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

  /// تحديث الـ server_user_id للمستخدمين الجدد بناءً على الـ localId الراجع من السيرفر
  @override
  Future<void> addServerIdToUser(List<AddModifyUser> syncedUsers) async {
    if (syncedUsers.isEmpty) {
      print("⏭️ [المزامنة]: قائمة المستخدمين القادمين من السيرفر فارغة تماماً، تم تخطي العملية.");
      return;
    }

    final db = await databaseHelper.database;

    // 💡 نفتح Batch لتنفيذ التحديثات دفعة واحدة في الذاكرة لتسريع الأداء
    final batch = db.batch();

    int addedToBatchCount = 0; // عداد لحساب العمليات الصالحة فعلياً

    for (final user in syncedUsers) {

      // ✨ [التحقق من البيانات الفارغة]: نتأكد أن معرّف السيرفر ليس null وليس فارغاً
      if (user.userId != null) {

        batch.update(
          'all_users',
          {
            'server_user_id': user.userId, // حفظ المعرف الحقيقي القادم من السيرفر

            // 2️⃣ نُعيد تصفير العدادات (Flags) لأن المستخدم أصبح مطابقاً تماماً للسيرفر الآن
            'is_local_new': 0,
            'is_modified': 0,
            'isUpload': 1, // تم الرفع بنجاح
          },
          // الشرط: نقوم بالتحديث بناءً على الـ Local ID الفريد للموبايل
          where: 'id = ?',
          whereArgs: [user.localId],
        );

        addedToBatchCount++; // زيادة عدد العمليات الجاهزة للتنفيذ

      } else {
        // ⚠️ في حال كان معرف السيرفر "فاضي"، نتخطى تعديله لحماية منطق البيانات
        print("⚠️ [تحذير]: تم تخطي المستخدم ذو المعرف المحلي (${user.localId}) لأن معرف السيرفر (userId) قادم بقيمة فارغة!");
      }
    }

    // 3️⃣ تنفيذ العمليات إذا كان هناك سجلات صالحة فقط داخل الـ Batch
    if (addedToBatchCount > 0) {
      try {
        // 🚀 تنفيذ كافة العمليات في قاعدة البيانات دفعة واحدة دون إبطاء التطبيق
        await batch.commit(noResult: true);
        print("✅ تم تحديث معرفات السيرفر وتصفير علامات المزامنة لـ $addedToBatchCount مستخدم بنجاح.");
      } catch (e) {
        print("❌ خطأ أثناء تنفيذ الـ Batch في قاعدة البيانات المحلية: $e");
      }
    } else {
      print("⏭️ [تنبيه]: لم يتم إرسال أي تحديثات لقاعدة البيانات لأن كل المعرفات القادمة كانت فارغة.");
    }
  }
  @override
  Future<SyncUsersRequest> getConferenceAndAnswers(int conferenceId) async {
    try {
      final db = await databaseHelper.database;

      // 1️⃣ جلب سجلات الحضور التي لم ترفع بعد مع استبدال الـ user_id بـ server_user_id
      // نستخدم INNER JOIN لضمان أننا نرسل فقط المستخدمين الذين يملكون معرف سيرفر حقيقي حالياً
      final List<Map<String, dynamic>> conferenceMaps = await db.rawQuery('''
      SELECT 
        uc.id,
        u.server_user_id AS user_id,
        uc.isUpload AS isUpload
      FROM user_conference uc
      INNER JOIN all_users u ON uc.user_id = u.id
      WHERE uc.isUpload = 0 AND u.server_user_id IS NOT NULL
    ''');

      // 2️⃣ جلب سجلات الإجابات التي لم ترفع بعد مع استبدال الـ user_id بـ server_user_id
      final List<Map<String, dynamic>> answerMaps = await db.rawQuery('''
      SELECT 
        u.server_user_id AS user_id,
        ua.answer_id,
        ua.content
      FROM users_answers ua
      INNER JOIN all_users u ON ua.user_id = u.id
      WHERE ua.isUpload = 0 AND u.server_user_id IS NOT NULL
    ''');

      // 3️⃣ تحويل البيانات المسترجعة إلى الكلاسات البرمجية المقابلة لها (Mapping)
      final List<UserConferenceModel> userConferenceList = List.generate(
        conferenceMaps.length,
            (i) {
          return UserConferenceModel(
            conferenceMaps[i]['id'] as int,
            conferenceMaps[i]['user_id'] as int,
            conferenceMaps[i]['isUpload'] as int,
            conference_id: conferenceId, // إسناد معرف المؤتمر النشط لتجهيز الـ API
          );
        },
      );

      final List<UsersAnswersRequest> answersList = List.generate(
        answerMaps.length,
            (i) {
          return UsersAnswersRequest(
            answerMaps[i]['user_id'] as int,
            answerMaps[i]['answer_id'] as int,
            answerMaps[i]['content'] as String,
            conferenceId, // ربط الإجابة بالمؤتمر الحالي
          );
        },
      );

      // 4️⃣ إعادة الحزمة الكاملة جاهزة للتحويل إلى JSON والرفع
      return SyncUsersRequest(0,userConferenceList, answersList);

    } catch (e, stackTrace) {
      print("❌ خطأ أثناء تجهيز حزمة الحضور والإجابات للمزامنة: $e");
      print("StackTrace: $stackTrace");

      // إرجاع كائن فارغ لحماية التطبيق من الانهيار في حالة وجود خطأ
      return SyncUsersRequest(0,<UserConferenceModel>[], <UsersAnswersRequest>[]);
    }
  }

  @override
  Future<void> deleteSyncData() async {
    try {
      final db = await databaseHelper.database;

      // 💡 نفتح Batch لدمج عمليات الحذف وتسريع التنفيذ في قاعدة البيانات
      final batch = db.batch();

      // 1️⃣ حذف كل إجابات المستخدمين
      batch.delete('users_answers');

      // 2️⃣ حذف كل سجلات حضور المؤتمرات
      batch.delete('user_conference');

      // 3️⃣ حذف كل المستخدمين (القدامى، الجدد، والأطباء المهمين المزامنين)
      batch.delete('all_users');

      // 🚀 تنفيذ الحذف الجماعي فوراً
      await batch.commit(noResult: true);

      print("🗑️ تم تفريغ جداول all_users و user_conference و users_answers بنجاح. التطبيق جاهز الآن للجلب الكامل.");

    } catch (e, stackTrace) {
      print("❌ خطأ أثناء محاولة تفريغ بيانات التزامن الموضعية (deleteSyncData): $e");
      print("StackTrace: $stackTrace");

      // إعادة رمي الخطأ إذا كنت بحاجة لمعالجته في طبقة الـ Bloc / Provider
      rethrow;
    }
  }
  @override
  Future<void> addSyncData(SaveDataBaseModel baseData) async {
    try {
      final db = await databaseHelper.database;
      final batch = db.batch();
      final syncData = baseData.data;
      if (syncData.users.isNotEmpty) {
        for (final user in syncData.users) {
          batch.insert(
            'all_users',
            {
              'id': user.id,
              'server_user_id': user.id,
              'fullname': user.fullName,
              'phone': user.phone,
              'email': user.email,
              'address': user.address,
              'type_id': user.userTypeId,
              'notes': user.notes,
              'specId': user.specId,
              'is_local_new': 0,
              'is_modified': 0,
              'isUpload': 1,
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }

      // 2️⃣ ثانياً: حقن حضور المؤتمر (user_conference) مباشرة
      if (syncData.userConference.isNotEmpty) {
        for (final conf in syncData.userConference) {
          batch.insert(
            'user_conference',
            {
              'user_id': conf.user_id,
              'isUpload': 1,
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }

      // 3️⃣ ثالثاً: حقن إجابات المستخدمين (users_answers) بالاعتماد الكامل على toJsonSaveData()
      if (syncData.answerUser.isNotEmpty) {
        for (final ans in syncData.answerUser) {
          batch.insert(
            'users_answers',
            {
              ...ans.toJsonSaveData(),     // 🔥 فرد الخريطة كاملة بما فيها الـ id القادم من السيرفر
              'isUpload': 1,           // إضافة حقل الأمان للمزامنة المحلية فقط
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }

      // 🚀 إرسال كل الأوامر دفعة واحدة لقاعدة البيانات
      await batch.commit(noResult: true);

      print("🚀 تم اكتمال المزامنة العكسية بنجاح مبهر! الجداول الثلاثة محقونة الآن ببيانات السيرفر وتطابق المعرفات 100%.");

    } catch (e, stackTrace) {
      print("❌ خطأ أثناء حقن البيانات بالمعرفات المتطابقة: $e");
      print("StackTrace: $stackTrace");
      rethrow;
    }
  }

  @override
  Future<List<SpecModel>> getSpec() async {
    try {
      final db = await databaseHelper.database;

      final List<Map<String, dynamic>> maps = await db.query('spec');

      final SpecModel allSpecialtiesOption = SpecModel(-1, "الكل");

      if (maps.isEmpty) {
        return [allSpecialtiesOption];
      }

      final List<SpecModel> fetchedSpecs = maps.map((specMap) => SpecModel.fromMap(specMap)).toList();
      return [
        allSpecialtiesOption,
        ...fetchedSpecs,
      ];

    } catch (e) {
      print("❌ خطأ أثناء جلب الاختصاصات من قاعدة البيانات المحلية: $e");
      return [SpecModel(-1, "الكل")];
    }
  }

  @override
  @override
  Future<List<UserModel>> getUsersBySpecIdAndName(int specId, String name) async {
    try {
      // 1️⃣ الحصول على نسخة نشطة من قاعدة البيانات المحلية
      final db = await databaseHelper.database;

      // 2️⃣ بناء نص الاستعلام المشترك (LEFT JOIN) الصحيح
      // تم تغيير 'specifications' إلى 'spec' ليطابق اسم جدولك الحقيقي
      String query = '''
    SELECT 
      u.*, 
      s.id AS spec_id_joined, 
      s.title AS spec_title_joined
    FROM all_users u
    LEFT JOIN spec s ON u.specId = s.id
    WHERE 
  ''';

      List<dynamic> whereArguments = [];

      // 3️⃣ التحقق من قيمة specId لتحديد نطاق البحث
      if (specId == -1) {
        // البحث بالاسم فقط عبر جميع الاختصاصات (استخدام u.fullname بحروف صغيرة مطابقة لجدولك)
        query += ' u.fullname LIKE ?';
        whereArguments.add('%$name%');
      } else {
        // دمج شرط الاختصاص المحدد مع الاسم
        query += ' u.specId = ? AND u.fullname LIKE ?';
        whereArguments.addAll([specId, '%$name%']);
      }

      // 4️⃣ تنفيذ الاستعلام المباشر الآمن باستخدام المعاملات الممررة
      final List<Map<String, dynamic>> maps = await db.rawQuery(query, whereArguments);

      // 5️⃣ التحقق مما إذا كانت المصفوفة فارغة
      if (maps.isEmpty) {
        return [];
      }

      // 6️⃣ تحويل البيانات الناتجة إلى قائمة مستخدمين من نوع UserModel
      return maps.map((userMap) =>
          UserModel.fromMap(userMap)).toList();

    } catch (e) {
      // توثيق الخطأ بالتفصيل في السجل في حال حدوث استثناء
      print("❌ خطأ أثناء جلب المستخدمين مع الاختصاص: $e");
      return [];
    }
  }  /// تابع مخصص لطباعة مصفوفة المستخدمين وتنسيق الخرج النهائي بشكل مقروء

}