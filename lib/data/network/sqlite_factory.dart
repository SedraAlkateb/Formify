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
      version: 6, // تم رفع الإصدار لضمان تحديث الجدول وإضافة عمود الوصف
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onOpen: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('PRAGMA foreign_keys = OFF');

    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';",
    );

    for (final row in tables) {
      final tableName = row['name'] as String;
      await db.execute('DROP TABLE IF EXISTS $tableName');
    }

    await _onCreate(db, newVersion);
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    // 1. إنشاء الجداول

    // جدول الأطباء مع عمود الوصف
    await db.execute('''
      CREATE TABLE doctors (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        region TEXT NOT NULL,
        description TEXT
      );
    ''');

    // Users
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fullname TEXT NOT NULL,
        email TEXT ,
        phone TEXT NOT NULL,
        address TEXT ,
        type_id INTEGER NOT NULL,
        doctor_id INTEGER,
        FOREIGN KEY (doctor_id) REFERENCES doctors(id) 
      );
    ''');

    // باقي الجداول (Conference, Survey, Questions, Answers, etc.)
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
      CREATE TABLE IF NOT EXISTS survey (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        timer TEXT,
        color TEXT
      );
    ''');

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

    // 2. إدخال البيانات الأولية للأطباء فور إنشاء القاعدة
    await _seedInitialDoctors(db);
  }

  Future<void> _seedInitialDoctors(Database db) async {
    final batch = db.batch();

    final List<Map<String, String>> initialDoctors = [

      // حلب - مشفى العيون (التموين)
      {'name': 'د. نور الدين الخطيب', 'region': 'حلب', 'description': 'مدير مشفى العيون - مهم جداً'},
      {'name': 'د. سوسن ابراهيم', 'region': 'حلب', 'description': 'طبيبة عينية - مشفى العيون'},
      {'name': 'د. بانة حامشلي', 'region': 'حلب', 'description': 'طبيبة عينية - مشفى العيون'},

      // حلب - مشفى الجامعة (أخصائيين)
      {'name': 'د. عمار كيالي', 'region': 'حلب', 'description': 'أخصائي عينية - مشفى الجامعة'},
      {'name': 'د. نديم زحلوق', 'region': 'حلب', 'description': 'أخصائي عينية - مشفى الجامعة'},
      {'name': 'د. عبد الرحمن نجوم', 'region': 'حلب', 'description': 'أخصائي عينية - مشفى الجامعة'},
      {'name': 'د. عثمان نعمة', 'region': 'حلب', 'description': 'أخصائي عينية - مشفى الجامعة'},

      // حمص
      {'name': 'طلال حبوش', 'region': 'حمص', 'description': 'طبيب عينية - مهم'},
      {'name': 'رامز بيطار', 'region': 'حمص', 'description': 'طبيب عينية - مهم'},
      {'name': 'سناء عباس', 'region': 'حمص', 'description': 'طبيبة عينية'},
      {'name': 'نهال ابو اللبن', 'region': 'حمص', 'description': 'طبيبة عينية'},
      {'name': 'عاصم حبوس', 'region': 'حمص', 'description': 'طبيب عينية'},
      {'name': 'فواز النجار', 'region': 'حمص', 'description': 'طبيب عينية'},
      {'name': 'نور خلوف', 'region': 'حمص', 'description': 'طبيبة عينية'},
      {'name': 'نيروز علي', 'region': 'حمص', 'description': 'طبيبة عينية'},
      {'name': 'يونس عتون', 'region': 'حمص', 'description': 'طبيب عينية'},
      {'name': 'هبة مطر', 'region': 'حمص', 'description': 'طبيبة عينية'},
      {'name': 'بتول سعود', 'region': 'حمص', 'description': 'طبيبة عينية'},

      // حماة
      {'name': 'د.عبدالله الاصفر', 'region': 'حماة', 'description': 'طبيب عينية - مهم جداً'},
      {'name': 'د.محمد بدر زقزوق', 'region': 'حماة', 'description': 'طبيب عينية - مهم'},
      {'name': 'د.منار طالب اغا', 'region': 'حماة', 'description': 'طبيبة عينية'},
      {'name': 'د.عبد الرزاق الكيلاني', 'region': 'حماة', 'description': 'طبيب عينية'},
      {'name': 'د.صفوان الحاج حسين', 'region': 'حماة', 'description': 'طبيب عينية'},
      {'name': 'د.معتز عبد الرزاق', 'region': 'حماة', 'description': 'طبيب عينية'},
      {'name': 'د.ايهاب الخطيب', 'region': 'حماة', 'description': 'طبيب عينية'},
      {'name': 'د.حسن صيادي', 'region': 'حماة', 'description': 'طبيب عينية'},
      {'name': 'د.فواز العوض', 'region': 'حماة', 'description': 'طبيب عينية'},

      // طرطوس
      {'name': 'د. شهاب محمد', 'region': 'طرطوس', 'description': 'طبيب عينية'},
      {'name': 'د. أيمن خضر', 'region': 'طرطوس', 'description': 'طبيب عينية'},
      {'name': 'د. أيمن يوسف', 'region': 'طرطوس', 'description': 'طبيب عينية'},
      {'name': 'د. ايفيلين رستم', 'region': 'طرطوس', 'description': 'طبيبة عينية'},
      {'name': 'د. ربااسماعيل', 'region': 'طرطوس', 'description': 'طبيبة عينية'},
      {'name': 'د. مهى عيسى', 'region': 'طرطوس', 'description': 'طبيبة عينية'},
      // طرطوس (ملاحظة عدم الحضور)
      {'name': 'د.وافي ميهوب', 'region': 'طرطوس', 'description': 'متوقع عدم الحضور'},
      {'name': 'د. أحمدونوس', 'region': 'طرطوس', 'description': 'متوقع عدم الحضور'},
      {'name': 'د أكسم أحمد', 'region': 'طرطوس', 'description': 'متوقع عدم الحضور'},
      {'name': 'د. عبدالرحمن سلمان', 'region': 'طرطوس', 'description': 'متوقع عدم الحضور'},
      {'name': 'د. محمدمعلا', 'region': 'طرطوس', 'description': 'متوقع عدم الحضور'},

      // سويداء (مرتبة حسب الأهمية)
      {'name': 'د أمجد الصالح', 'region': 'السويداء', 'description': 'أولوية قصوى - مهم جداً'},
      {'name': 'د مناف معروف', 'region': 'السويداء', 'description': 'أهمية مرتفعة'},
      {'name': 'د أمية جنود', 'region': 'السويداء', 'description': 'مهم'},
      {'name': 'د خالد أبو حمدان', 'region': 'السويداء', 'description': 'طبيب عينية'},
      {'name': 'د أدهم خير', 'region': 'السويداء', 'description': 'طبيب عينية'},
      {'name': 'د إيمان جنود', 'region': 'السويداء', 'description': 'طبيبة عينية'},
      {'name': 'د دينا أبو شديد', 'region': 'السويداء', 'description': 'طبيبة عينية'},
      {'name': 'د مجد الحلبي', 'region': 'السويداء', 'description': 'طبيب عينية'},
      {'name': 'د خلدون البعيني', 'region': 'السويداء', 'description': 'أهمية عادية'},

      // اللاذقية وجبلة
      {'name': 'عبد القادر تعتاع', 'region': 'اللاذقية', 'description': 'رئيس قسم العينية بمشفى تشرين الجامعي - مهم جداً'},
      {'name': 'فريد طيفور', 'region': 'اللاذقية', 'description': 'رئيس قسم العينية بالمشفى الوطني - مهم جداً'},
      {'name': 'نادر يونس', 'region': 'اللاذقية', 'description': 'طبيب عينية - مهم'},
      {'name': 'زينب حلوم', 'region': 'اللاذقية', 'description': 'طبيبة عينية'},
      {'name': 'ميساء أحمد', 'region': 'اللاذقية', 'description': 'طبيبة عينية'},
      {'name': 'احمد ميهوب', 'region': 'اللاذقية', 'description': 'طبيب عينية'},
      {'name': 'يوسف سليمان', 'region': 'اللاذقية', 'description': 'طبيب عينية'},
      {'name': 'محمد بركات', 'region': 'اللاذقية', 'description': 'طبيب عينية'},
      {'name': 'مجدولين سرحيل', 'region': 'اللاذقية', 'description': 'طبيبة عينية'},
      {'name': 'ميراي جمل', 'region': 'اللاذقية', 'description': 'طبيبة عينية'},
      {'name': 'رؤى عبد الرحمن', 'region': 'اللاذقية', 'description': 'طبيبة عينية'},
      {'name': 'حنان علي', 'region': 'اللاذقية', 'description': 'طبيبة عينية'},
      {'name': 'رانية امهان', 'region': 'اللاذقية', 'description': 'طبيبة عينية'},
      {'name': 'احمد احمد', 'region': 'اللاذقية', 'description': 'طبيب عينية'},
      {'name': 'ميرنا جرجس', 'region': 'اللاذقية', 'description': 'طبيبة عينية'},
      {'name': 'مي شهابي', 'region': 'اللاذقية', 'description': 'طبيبة عينية'},
      {'name': 'د عبدالمعين عميش', 'region': 'جبلة', 'description': 'طبيب عينية - مهم'},
      {'name': 'لمياء الراهب', 'region': 'جبلة', 'description': 'طبيبة عينية'},
      {'name': 'مهى محمد', 'region': 'جبلة', 'description': 'طبيبة عينية'},

      // درعا
      {'name': 'د عبد الودود الحمصي', 'region': 'درعا', 'description': 'طبيب عينية - مهم'},
      {'name': 'د قاسم كيوان', 'region': 'درعا', 'description': 'طبيب عينية'},
      {'name': 'د أزهر النايف', 'region': 'درعا', 'description': 'طبيب عينية'},

    ];

    for (var doc in initialDoctors) {
      batch.insert('doctors', doc);
    }
    await batch.commit();
  }

}