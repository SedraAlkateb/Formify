import 'package:formify/domain/models/mock_users.dart';
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
    id INTEGER PRIMARY KEY AUTOINCREMENT, -- معرف محلي تلقائي (Local ID)
    server_user_id INTEGER NULL,         -- معرف السيرفر (يكون NULL للمسجلين الجدد محلياً)
    fullname TEXT NOT NULL,
    phone TEXT NOT NULL,
    email TEXT,
    address TEXT,
    type_id INTEGER NOT NULL,            -- 6: طبيب مهم، 5: مختص، 4: طالب...
    notes TEXT,
    specId INTEGER,
    is_local_new INTEGER DEFAULT 0,      -- 1: مستخدم جديد مضاف من الموبايل، 0: قادم من السيرفر
    is_modified INTEGER DEFAULT 0,       -- 1: مستخدم قديم تم تعديل بياناته محلياً
    is_uploaded INTEGER DEFAULT 1        -- 0: يحتاج رفع/تحديث، 1: مزامن بالكامل    FOREIGN KEY (specId) REFERENCES spec(id) 
  )
''');

    // جدول users (يبقى كما هو، الربط الآن صحيح)
    await db.execute('''
  CREATE TABLE IF NOT EXISTS user_conference (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    is_uploaded INTEGER DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES all_users(id) 
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
        is_uploaded INTEGER DEFAULT 0,
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

    // 7. 🔥 جدول doctor الجديد المخصص لعرض وحفظ حضور الدكاترة من الـ Mock
    await db.execute('''
      CREATE TABLE IF NOT EXISTS doctor (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        isDone INTEGER DEFAULT 0
      );
    ''');

    // ✨ استدعاء تابع حقن الدكاترة الافتراضيين تلقائياً هنا باستخدام كائن الـ db الممرر حالياً
    await _seedDoctorsOnFirstCreate(db);
  }
}

// 🔥 تابع خاص ومحمي لحقن الدكاترة داخل الـ onCreate مباشرة لحماية الجلسة من الـ Deadlock
Future<void> _seedDoctorsOnFirstCreate(Database db) async {
  try {
    final batch = db.batch();

    for (final user in MockModel.usersList) {
      batch.insert('doctor', {
        'id': user.id,
        'name': user.name, // استخلاص الـ fullName المتوافق مع الموديل
        'isDone': 0, // غير حاضر افتراضياً
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit(noResult: true);
    print(
      "✅ تم إدخال 59 دكتوراً بنجاح إلى جدول 'doctor' عند تأسيس قاعدة البيانات.",
    );
  } catch (e) {
    print("❌ خطأ أثناء إدخال الدكاترة في الـ onCreate: $e");
  }
}
