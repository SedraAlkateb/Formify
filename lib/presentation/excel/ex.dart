import 'dart:io';

import 'package:excel/excel.dart';
import 'package:formify/domain/models/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// Future<List<Map<String, dynamic>>> fetchUserData() async {
//   // هذه مجرد محاكاة للبيانات
//   await Future.delayed(Duration(seconds: 1)); // محاكاة تأخير الـ API
//   return [
//     {
//       "username": "Ahmed",
//       "location": "Cairo",
//       "favoriteMedicine": "Paracetamol",
//     },
//     {
//       "username": "Sara",
//       "location": "Alexandria",
//       "favoriteMedicine": "Aspirin",
//     },
//     {
//       "username": "John",
//       "location": "New York",
//       "favoriteMedicine": "Ibuprofen",
//     },
//     {
//       "username": "Laila",
//       "location": "Cairo",
//       "favoriteMedicine": "Paracetamol",
//     },
//     {
//       "username": "Mohammed",
//       "location": "Dubai",
//       "favoriteMedicine": "Aspirin",
//     },
//   ];
// }

List<SurveyQuestionModel> baseQuestion = [
  SurveyQuestionModel(-1, "الاسم", "text"),
  SurveyQuestionModel(-2, "العنوان", "text"),
];
// الدالة لحفظ البيانات في ملف Excel
Future<void> generateExcel(
  ExelModel exel,
) async {
  var excel = Excel.createExcel(); // أنشئ ملف Excel جديد
  Sheet sheet = excel['Sheet1']; // اختر الورقة في الملف
  List<SurveyQuestionModel> questionName = baseQuestion;
  questionName.addAll(exel.surveyQuestionModel);
  sheet.appendRow(
    questionName.map((header) => TextCellValue(header.question)).toList(),
  );

  for (var row in exel.userAndAnswersModel) {
    sheet.appendRow([
      TextCellValue(row.userModel.fullName),
      TextCellValue(row.userModel.address),

      ...row.userAnswerForStatModel.map((header) {
        return TextCellValue(header.content);
      }).toList(),
    ]);
  }
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

final List<ChartPoint> stats = [ChartPoint("نعم", 18), ChartPoint("لا", 12)];
