import 'dart:io';
import 'package:excel/excel.dart';
import 'package:share_plus/share_plus.dart';

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
    ...questionsMap.values.map((e) => TextCellValue(e)),
  ]);

  for (var user in userAnswersList) {
    sheet.appendRow([
      TextCellValue(user['user'] ?? 'N/A'), // إضافة الاسم من بيانات المستخدم
      TextCellValue(user['address'] ?? 'N/A'), // إضافة العنوان
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