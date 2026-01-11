import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  Batch? batch;
  factory DatabaseHelper() {
    return _instance;
  }
  DatabaseHelper._internal();
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute("PRAGMA foreign_keys = OFF");
    List<Map<String, dynamic>> tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';");
    for (var table in tables) {
      String tableName = table['name'];
      await db.execute("DROP TABLE IF EXISTS $tableName");
    }
    await _onCreate(db, newVersion);
    await db.execute("PRAGMA foreign_keys = ON");
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'task_database1.db');
    return await openDatabase(
      path,
      version: 5,
      onUpgrade: _onUpgrade,
      onCreate: _onCreate,
      onOpen: (db) async {
        await db.execute("PRAGMA foreign_keys = ON");
      },
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      fullname VARCHAR(100) NOT NULL,
      email VARCHAR(200) NOT NULL,
      phone VARCHAR(13) NOT NULL,
      address TEXT NOT NULL,
    );
  ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS conference (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name VARCHAR(100) NOT NULL,
      description TEXT,
      address TEXT,
      start_date DATE,
      end_date DATE,
      is_active TINYINT(1) DEFAULT 0
    );
  ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS survey (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title VARCHAR(100) NOT NULL,
      description TEXT,
      color VARCHAR(100)
    );
  ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS questions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      survey_id INTEGER,
      question TEXT,
      question_order TINYINT(4),
      is_required TINYINT(1) DEFAULT 0,
      type VARCHAR(100),
      FOREIGN KEY (survey_id) REFERENCES survey(id) ON DELETE CASCADE
    );
  ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS answers (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      question_id INTEGER,
      FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
    );
  ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS users_answers (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      answer_id INTEGER,
      content TEXT,
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
      FOREIGN KEY (answer_id) REFERENCES answers(id) ON DELETE CASCADE
    );
  ''');



    await db.execute('''
    CREATE TABLE IF NOT EXISTS survey_conference (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      survey_id INTEGER,
      conference_id INTEGER,
      survey_order TINYINT(4),
      FOREIGN KEY (survey_id) REFERENCES survey(id) ON DELETE CASCADE,
      FOREIGN KEY (conference_id) REFERENCES conference(id) ON DELETE CASCADE
    );
  ''');
  }
}
