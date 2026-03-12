import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> exportAndShareExcel({
  required List<Map<String, String>> userAnswersList,
  required Map<int, String> questionsMap,
}) async {
  final file = await exportUsersToExcel(
    userAnswersList: userAnswersList,
    questionsMap: questionsMap,
    fileName: 'conference_users',
  );

  await SharePlus.instance.share(
    ShareParams(
      files: [XFile(file.path)],
      text: 'ملف نتائج الاستبيان',
    ),
  );
}
Future<File> exportUsersToExcel({
  required List<Map<String, String>> userAnswersList,
  required Map<int, String> questionsMap,
  String fileName = 'survey_results',
}) async {
  final excel = Excel.createExcel();
  final String sheetName = 'Results';

  /// احذف الشيت الافتراضي إذا أردت اسمًا مخصصًا فقط
  if (excel.tables.containsKey('Sheet1')) {
    excel.delete('Sheet1');
  }

  final Sheet sheet = excel[sheetName];

  /// ترتيب الأعمدة
  final List<String> headers = [
    '#',
    'اسم المستخدم',
    'العنوان',
    ...questionsMap.values,
  ];

  /// صف الهيدر
  for (int col = 0; col < headers.length; col++) {
    final cell = sheet.cell(
      CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0),
    );

    cell.value = TextCellValue(headers[col]);

    cell.cellStyle = CellStyle(
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      backgroundColorHex: ExcelColor.blue,
      fontColorHex: ExcelColor.white,
      textWrapping: TextWrapping.WrapText,
    );
  }

  /// البيانات
  for (int row = 0; row < userAnswersList.length; row++) {
    final user = userAnswersList[row];

    final List<String> rowValues = [
      '${row + 1}',
      user['user'] ?? '',
      user['address'] ?? '',
      ...questionsMap.values.map((question) => user[question] ?? 'لا توجد إجابة'),
    ];

    for (int col = 0; col < rowValues.length; col++) {
      final cell = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row + 1),
      );

      cell.value = TextCellValue(rowValues[col]);
      cell.cellStyle = CellStyle(
        horizontalAlign: HorizontalAlign.Center,
        verticalAlign: VerticalAlign.Center,
        textWrapping: TextWrapping.WrapText,
      );
    }
  }

  /// عرض الأعمدة
  sheet.setColumnWidth(0, 8);   // #
  sheet.setColumnWidth(1, 22);  // اسم المستخدم
  sheet.setColumnWidth(2, 28);  // العنوان

  for (int i = 3; i < headers.length; i++) {
    sheet.setColumnWidth(i, 30);
  }

  /// حفظ الملف
  final List<int>? bytes = excel.save();
  if (bytes == null) {
    throw Exception('فشل إنشاء ملف Excel');
  }

  final Directory dir = await getApplicationDocumentsDirectory();
  final String safeName =
      '${fileName}_${DateTime.now().millisecondsSinceEpoch}.xlsx';
  final File file = File('${dir.path}/$safeName');

  await file.writeAsBytes(bytes, flush: true);
  return file;
}
