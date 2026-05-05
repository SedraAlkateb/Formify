import 'dart:io';
import 'package:excel/excel.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> exportAndShareExcel({
  required List<Map<String, String>> userAnswersList,
  required Map<int, String> questionsMap,
  required String filename
}) async {
  final file = await exportUsersToExcel(
    userAnswersList: userAnswersList,
    questionsMap: questionsMap,
    filename: filename,
  );

  await SharePlus.instance.share(
    ShareParams(files: [XFile(file.path)], text: 'ملف نتائج الاستبيان'),
  );
}

// دالة لتصدير البيانات إلى ملف Excel
Future<File> exportUsersToExcel({
  required List<Map<String, String>> userAnswersList,
  required Map<int, String> questionsMap,
  required String filename
}) async {
  var excel = Excel.createExcel(); // إنشاء ملف Excel جديد
  Sheet sheet = excel['Sheet1']; // اختر الورقة في الملف

  // إضافة رؤوس الأعمدة
  sheet.appendRow([
    TextCellValue('الاسم'),
    TextCellValue('العنوان'),
    TextCellValue('الهاتف'),
    TextCellValue('النوع'),
    ...questionsMap.values.map((e) => TextCellValue(e)),
  ]);

  for (var user in userAnswersList) {
    sheet.appendRow([
      TextCellValue(user['user'] ?? 'N/A'), // إضافة الاسم من بيانات المستخدم
      TextCellValue(user['address'] ?? 'N/A'), // إضافة العنوان
      TextCellValue(user['phone'] ?? 'N/A'), // إضافة الاسم من بيانات المستخدم
      TextCellValue(user['type'] ?? 'N/A'), // إضافة العنوان
      ...questionsMap.entries.map((entry) {
        return TextCellValue(user[entry.value.toString()] ?? ""); // إضافة الإجابات
      }).toList(),
    ]);
  }

  // الحصول على البيانات المشفرة
  final excelBytes = excel.encode();

  if (excelBytes != null) {
    // الحصول على المسار لمجلد التحميلات أو المستندات
    Directory directory = Directory('/storage/emulated/0/Download');
    // أو يمكنك استخدام getDocumentsDirectory() لوضعه في مجلد المستندات
    final path = '${directory.path}/$filename.xlsx'; // المسار داخل مجلد التحميلات

    var file = File(path);
    await file.writeAsBytes(excelBytes); // الكتابة إلى الملف
    print(file);
    return file;
  } else {
    throw Exception('فشل في إنشاء الملف');
  }
}

/// دالة شاملة لتصدير البيانات إلى ملف Excel
/// تستقبل [data] وهي قائمة الخرائط، و [fileName] اسم الملف المراد حفظه
Future<File?> exportDataToExcel({
  required List<Map<String, String>> data,
  required String fileName
}) async {

  // 1. طلب إذن الوصول إلى التخزين (ضروري لأجهزة أندرويد)
  var status = await Permission.storage.request();

  if (status.isGranted || await Permission.manageExternalStorage.request().isGranted) {

    // 2. إنشاء كائن Excel جديد في الذاكرة
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    if (data.isNotEmpty) {
      // 3. إضافة صف العناوين (Headers) تلقائياً من مفاتيح أول عنصر في القائمة
      List<String> headers = data.first.keys.toList();
      sheetObject.appendRow(headers.map((h) => TextCellValue(h)).toList());

      // 4. إضافة صفوف البيانات
      for (var row in data) {
        List<TextCellValue> values = headers.map((header) {
          return TextCellValue(row[header] ?? "");
        }).toList();
        sheetObject.appendRow(values);
      }
    }

    // 5. تحديد مسار الحفظ (مجلد المستندات أو التحميلات)
    Directory? directory = await getExternalStorageDirectory();
    String filePath = "${directory!.path}/$fileName.xlsx";

    // 6. ترميز الملف وحفظه فعلياً
    var fileBytes = excel.save();
    if (fileBytes != null) {
      File file = File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);

      print("تم حفظ الملف في: $filePath");
      return file;
    }
  } else {
    print("لم يتم منح صلاحيات التخزين");
  }
  return null;
}

Future<File?> exportDataToExcel1({
  required List<Map<String, String>> data,
  required String fileName
}) async {

  // 1. طلب إذن الوصول إلى التخزين (ضروري لأجهزة أندرويد)
  var status = await Permission.storage.request();

  if (status.isGranted || await Permission.manageExternalStorage.request().isGranted) {

    // 2. إنشاء كائن Excel جديد في الذاكرة
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    if (data.isNotEmpty) {
      // 3. إضافة صف العناوين (Headers) تلقائياً من مفاتيح أول عنصر في القائمة
      List<String> headers = data.first.keys.toList();
      sheetObject.appendRow(headers.map((h) => TextCellValue(h)).toList());

      // 4. إضافة صفوف البيانات
      for (var row in data) {
        List<TextCellValue> values = headers.map((header) {
          return TextCellValue(row[header] ?? "");
        }).toList();
        sheetObject.appendRow(values);
      }
    }

    // 5. تحديد مسار الحفظ (مجلد المستندات أو التحميلات)
    Directory? directory = await getExternalStorageDirectory();
    String filePath = "${directory!.path}/$fileName.xlsx";

    // 6. ترميز الملف وحفظه فعلياً
    var fileBytes = excel.save();
    if (fileBytes != null) {
      File file = File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);

      print("تم حفظ الملف في: $filePath");
      return file;
    }
  } else {
    print("لم يتم منح صلاحيات التخزين");
  }
  return null;
}