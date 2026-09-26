import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:formify/domain/models/mock_users.dart';
import 'package:path/path.dart';
// 1. تغيير الاستيراد ليدعم التشفير
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // 2. تعريف التخزين الآمن التابع للنظام
  final _secureStorage = const FlutterSecureStorage();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // 3. دالة جلب أو إنشاء مفتاح التشفير السري بـ AES-256
  Future<String> _getOrCreateEncryptionKey() async {
    const keyName = 'formify_db_encryption_key';
    String? storedKey = await _secureStorage.read(key: keyName);

    if (storedKey == null) {
      var random = Random.secure();
      var values = List<int>.generate(32, (i) => random.nextInt(256));
      String newKey = base64Url.encode(values);
      await _secureStorage.write(key: keyName, value: newKey);
      return newKey;
    }
    return storedKey;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    // نصيحة: يفضل تغيير اسم الملف إذا كان التطبيقان ينزلان على نفس الجهاز منعا للتداخل
    final path = join(dbPath, 'formify_secure_database.db');

    // 4. جلب المفتاح السري الآمن
    final encryptionKey = await _getOrCreateEncryptionKey();

    // 5. ترحيل قاعدة البيانات القديمة غير المشفّرة (إن وجدت) قبل إنشاء/فتح الجديدة
    await _migrateLegacyDatabaseIfNeeded(path, encryptionKey);

    try {
      return await openDatabase(
        path,
        version: 1,
        password: encryptionKey, // 👈 تفعيل التشفير الشامل هنا
        onCreate: _onCreate,
        onOpen: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
      );
    } catch (e) {
      // فشل فتح القاعدة المشفّرة غالبًا لأن المفتاح المحفوظ لم يعد يطابق الملف
      // (مثلاً بعد إعادة تثبيت التطبيق مع بقاء بيانات التطبيق على الجهاز).
      // بدلاً من تعطّل التطبيق بالكامل، نحذف الملف التالف ونبدأ بقاعدة جديدة نظيفة.
      print(
        "❌ فشل فتح قاعدة البيانات المشفّرة، سيتم إعادة إنشائها من الصفر: $e",
      );
      final corruptFile = File(path);
      if (await corruptFile.exists()) {
        await corruptFile.delete();
      }
      return openDatabase(
        path,
        version: 1,
        password: encryptionKey,
        onCreate: _onCreate,
        onOpen: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
      );
    }
  }

  // 6. نقل بيانات القاعدة القديمة غير المشفّرة (task_database1.db) إلى القاعدة
  // الجديدة المشفّرة باستخدام sqlcipher_export، حفاظاً على بيانات المستخدمين الحاليين.
  Future<void> _migrateLegacyDatabaseIfNeeded(
    String newDbPath,
    String encryptionKey,
  ) async {
    final oldPath = join(dirname(newDbPath), 'task_database1.db');
    final oldFile = File(oldPath);
    final newFile = File(newDbPath);

    if (!await oldFile.exists() || await newFile.exists()) {
      return; // لا توجد قاعدة قديمة، أو أن الترحيل تم مسبقاً
    }

    Database? legacyDb;
    try {
      legacyDb = await openDatabase(oldPath, password: '');
      await legacyDb.execute(
        "ATTACH DATABASE '$newDbPath' AS encrypted KEY '$encryptionKey'",
      );
      await legacyDb.execute("SELECT sqlcipher_export('encrypted')");
      await legacyDb.execute("DETACH DATABASE encrypted");
      print("✅ تم ترحيل قاعدة البيانات القديمة إلى النسخة المشفّرة بنجاح.");
    } catch (e) {
      print(
        "❌ فشل ترحيل قاعدة البيانات القديمة، سيتم إنشاء قاعدة جديدة فارغة: $e",
      );
      if (await newFile.exists()) {
        await newFile.delete();
      }
    } finally {
      await legacyDb?.close();
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    // 1. جدول التخصصات (تم نقله للأعلى لأن الجداول الأخرى تعتمد عليه كمفتاح أجنبي)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS spec (
        id INTEGER PRIMARY KEY,
        title TEXT
      );
    ''');

    // 2. جدول المستخدمين (تم إصلاح الفاصلة والتعليق هنا)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS all_users (
        id INTEGER PRIMARY KEY,
        server_user_id INTEGER NULL,
        fullname TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT,
        address TEXT,
        type_id INTEGER NOT NULL,
        notes TEXT,
        specId INTEGER,
        is_local_new INTEGER DEFAULT 0,
        is_modified INTEGER DEFAULT 0,
        isUpload INTEGER DEFAULT 1, 
        FOREIGN KEY (specId) REFERENCES spec(id) 
      );
    ''');

    // 3. جدول مؤتمرات المستخدمين
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_conference (
        id INTEGER PRIMARY KEY,
        user_id INTEGER,
        isUpload INTEGER DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES all_users(id) 
      );
    ''');

    // 4. جدول المؤتمرات
    await db.execute('''
      CREATE TABLE IF NOT EXISTS conference (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        address TEXT,
        start_date TEXT,
        end_date TEXT,
        is_active INTEGER DEFAULT 0
      );
    ''');

    // 5. جدول ربط المؤتمر بالتخصص
    await db.execute('''
      CREATE TABLE IF NOT EXISTS sp_conference (
        id INTEGER PRIMARY KEY,
        conferenceId INTEGER NOT NULL,
        specId INTEGER NOT NULL,
        FOREIGN KEY (specId) REFERENCES spec(id) ON DELETE CASCADE,
        FOREIGN KEY (conferenceId) REFERENCES conference(id) ON DELETE CASCADE
      );
    ''');

    // 6. جدول الاستبيانات
    await db.execute('''
      CREATE TABLE IF NOT EXISTS survey (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        timer TEXT,
        color TEXT
      );
    ''');

    // 7. جدول الأسئلة
    await db.execute('''
      CREATE TABLE IF NOT EXISTS questions (
        id INTEGER PRIMARY KEY,
        survey_id INTEGER,
        question TEXT,
        question_order INTEGER,
        is_required INTEGER DEFAULT 0,
        type TEXT,
        value INTEGER,
        FOREIGN KEY (survey_id) REFERENCES survey(id) ON DELETE CASCADE
      );
    ''');

    // 8. جدول الخيارات
    await db.execute('''
      CREATE TABLE IF NOT EXISTS answers (
        id INTEGER PRIMARY KEY,
        title TEXT,
        img TEXT NULL,
        question_id INTEGER,
        isCorrect INTEGER NULL,
        FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
      );
    ''');

    // 9. جدول إجابات المستخدمين
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users_answers (
        id INTEGER PRIMARY KEY,
        user_id INTEGER,
        answer_id INTEGER,
        content TEXT,
        isCorrect INTEGER NULL,
        isUpload INTEGER DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES all_users(id) ON DELETE CASCADE,
        FOREIGN KEY (answer_id) REFERENCES answers(id) ON DELETE CASCADE
      );
    ''');

    // 10. جدول الربط بين الاستبيان والمؤتمر
    await db.execute('''
      CREATE TABLE IF NOT EXISTS survey_conference (
        id INTEGER PRIMARY KEY,
        survey_id INTEGER,
        conference_id INTEGER,
        survey_order INTEGER,
        FOREIGN KEY (survey_id) REFERENCES survey(id) ON DELETE CASCADE,
        FOREIGN KEY (conference_id) REFERENCES conference(id) ON DELETE CASCADE
      );
    ''');

    // 11. جدول الأطباء المخصص للحفظ المؤقت من الـ Mock
    await db.execute('''
      CREATE TABLE IF NOT EXISTS doctor (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        isDone INTEGER DEFAULT 0
      );
    ''');

    // حقن البيانات الافتراضية
    await _seedDoctorsOnFirstCreate(db);
  }
}

Future<void> _seedDoctorsOnFirstCreate(Database db) async {
  try {
    final batch = db.batch();

    for (final user in MockModel.usersList) {
      batch.insert('doctor', {
        'id': user.id,
        'name': user.name,
        'isDone': 0,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit(noResult: true);
    print("✅ تم إدخال الدكاترة بنجاح عند تأسيس قاعدة البيانات.");
  } catch (e) {
    print("❌ خطأ أثناء إدخال الدكاترة في الـ onCreate: $e");
  }
}