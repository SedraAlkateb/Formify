import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'task_database1.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onOpen: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
  CREATE TABLE IF NOT EXISTS all_users (
    id INTEGER PRIMARY KEY, 
    fullname TEXT NOT NULL,
    email TEXT,
    phone TEXT NOT NULL,
    address TEXT,
    type_id INTEGER NOT NULL,
    notes TEXT,
    specId INTEGER,
    FOREIGN KEY (specId) REFERENCES spec(id) 
  )
''');

    // جدول users (يبقى كما هو، الربط الآن صحيح)
    await db.execute('''
  CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    fullname TEXT NOT NULL,
    email TEXT,
    phone TEXT NOT NULL,
    address TEXT,
    type_id INTEGER NOT NULL,
    user_id INTEGER,
    notes TEXT, 
    isUpload INTEGER DEFAULT 0,
    specId INTEGER,
    FOREIGN KEY (specId) REFERENCES spec(id) 
  );
''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS conference (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        address TEXT,
        start_date TEXT,
        end_date TEXT,
        is_active INTEGER DEFAULT 0
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS sp_conference (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        conferenceId INTEGER NOT NULL,
        specId INTEGER NOT NULL,
        FOREIGN KEY (specId) REFERENCES spec(id) ON DELETE CASCADE,
        FOREIGN KEY (conferenceId) REFERENCES conference(id) ON DELETE CASCADE

      );
    ''');

    // 5. جدول الاستبيانات
    await db.execute('''
      CREATE TABLE IF NOT EXISTS survey (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        timer TEXT,
        color TEXT
      );
    ''');

    // 6. جدول الأسئلة
    await db.execute('''
      CREATE TABLE IF NOT EXISTS questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        survey_id INTEGER,
        question TEXT,
        question_order INTEGER,
        is_required INTEGER DEFAULT 0,
        type TEXT,
        value INTEGER,
        FOREIGN KEY (survey_id) REFERENCES survey(id) ON DELETE CASCADE
      );
    ''');

    // 7. جدول الخيارات (الإجابات المقترحة)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS answers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        img TEXT NULL,
        question_id INTEGER,
        isCorrect INTEGER NULL,
        FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
      );
    ''');

    // 8. جدول إجابات المستخدمين
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users_answers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        answer_id INTEGER,
        content TEXT,
        isCorrect INTEGER NULL,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (answer_id) REFERENCES answers(id) ON DELETE CASCADE
      );
    ''');

    // 9. جدول الربط بين الاستبيان والمؤتمر
    await db.execute('''
      CREATE TABLE IF NOT EXISTS survey_conference (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        survey_id INTEGER,
        conference_id INTEGER,
        survey_order INTEGER,
        FOREIGN KEY (survey_id) REFERENCES survey(id) ON DELETE CASCADE,
        FOREIGN KEY (conference_id) REFERENCES conference(id) ON DELETE CASCADE
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS spec (
        id INTEGER PRIMARY KEY,
       title TEXT
      );
    ''');
  }
}

/*
  Future<List<UserSqlModel>> getDataSql() async {

    final db = await databaseHelper.database;



    // 1. استخدام LEFT JOIN لجلب المستخدمين حتى لو لم تكن هناك إجابات مرتبطة بهم

    final maps = await db.rawQuery('''

  SELECT

    users.id            AS user_id,

    users.fullname      AS fullname,

    users.email         AS email,

    users.phone         AS phone,

    users.address       AS address,

    users.type_id       AS type_id,

    users_answers.answer_id AS answer_id,

    users_answers.content   AS content,

    users_answers.isCorrect AS isCorrect

  FROM users

  LEFT JOIN users_answers ON users.id = users_answers.user_id;

''');



    final Map<int, UserSqlModel> usersMap = {};



    for (final row in maps) {

      final int userId = row['user_id'] as int;



      usersMap.putIfAbsent(

        userId,

            () => UserSqlModel(

          fullName: row['fullname'] as String,

          email: row['email'] as String?,

          phone: (row['phone'] as String).isEmpty?"09":row['phone'] as String,

          address: row['address'] as String?,

          doctorId: row['doctor_id'] as int?,

          userType: userTypeFromId(row['type_id'] as int),

          answerModel: <AnswerUserModel>[],

        ),

      );



      // 2. التحقق من أن حقل الإجابة ليس فارغاً (NULL) قبل محاولة الإضافة

      // إذا كان المستخدم ليس لديه إجابة، سيكون row['answer_id'] قيمته null

      if (row['answer_id'] != null) {

        usersMap[userId]!.answerModel.add(

          AnswerUserModel(

            row['answer_id'] as int,

            row['content'] as String,

            row['isCorrect'] as int,

          ),

        );

      }

    }



    return usersMap.values.toList();

  } اجلب لي isUpload =0 فقط  للمستخدم users_answers و users
 */
