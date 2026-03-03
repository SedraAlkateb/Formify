
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<List<Map<String, dynamic>>> fetchUserData() async {
  // هذه مجرد محاكاة للبيانات
  await Future.delayed(Duration(seconds: 1)); // محاكاة تأخير الـ API
  return [
    {"username": "Ahmed", "location": "Cairo", "favoriteMedicine": "Paracetamol"},
    {"username": "Sara", "location": "Alexandria", "favoriteMedicine": "Aspirin"},
    {"username": "John", "location": "New York", "favoriteMedicine": "Ibuprofen"},
    {"username": "Laila", "location": "Cairo", "favoriteMedicine": "Paracetamol"},
    {"username": "Mohammed", "location": "Dubai", "favoriteMedicine": "Aspirin"},
  ];
}

// الدالة لحفظ البيانات في ملف Excel
Future<void> generateExcel(List<Map<String, dynamic>> data) async {
  var excel = Excel.createExcel(); // أنشئ ملف Excel جديد
  Sheet sheet = excel['Sheet1']; // اختر الورقة في الملف

  // إضافة رؤوس الأعمدة
  sheet.appendRow([
    TextCellValue("اسم المستخدم"),
    TextCellValue("الموقع"),
    TextCellValue("أكثر دواء مفضل"),
  ]);

  // إضافة البيانات
  for (var row in data) {
    sheet.appendRow([
      TextCellValue(row['username'].toString()),
      TextCellValue(row['location'].toString()),
      TextCellValue(row['favoriteMedicine'].toString()),
    ]);
  }

  // تحقق من التكويد قبل الكتابة إلى الملف
  final excelBytes = excel.encode(); // الحصول على البيانات المشفرة
  if (excelBytes != null) {
    // طلب الأذونات قبل الكتابة إلى المجلد الخارجي
    await requestPermissions();

    // الحصول على المسار للمجلد الخارجي
    final directory = await getExternalStorageDirectory();
    final path = '${directory?.path}/user_data.xlsx'; // المسار للمجلد الخارجي

    var file = File(path);
    await file.writeAsBytes(excelBytes); // الكتابة إلى الملف

    print("تم حفظ الملف في: $path");
  } else {
    print("لم تتم عملية التكويد بنجاح.");
  }
}
Future<void> requestPermissions() async {
  PermissionStatus status = await Permission.storage.request();

  if (status.isGranted) {
    print("تم منح الأذونات بنجاح");
  } else if (status.isDenied) {
    print("الأذونات مرفوضة");
  } else if (status.isPermanentlyDenied) {
    // إذا كانت الأذونات مرفوضة بشكل دائم، اطلب من المستخدم الذهاب للإعدادات
    openAppSettings();
    print("الأذونات مرفوضة بشكل دائم");
  }
}
class ChartPoint {
  final String label;
  final num value;
  const ChartPoint(this.label, this.value);
}
final List<ChartPoint> stats = [
  ChartPoint("نعم", 18),
  ChartPoint("لا", 12),
];