import 'package:formify/presentation/resources/routes.dart';

class Constants {
  static const baseUrl = "https://dominapharm.com/domina-survey/";
  static const imageUrl =
      "https://dominapharm.com/domina-survey/survey-crud/uploads/";

  /// إدخال الأطباء المهمين من assets/json/important_doctors.json بعد تفعيل المؤتمر.
  /// معطّل حالياً؛ فعّله (true) عند وضع ملف JSON جديد (يعمل مرة واحدة).
  /// لإعادة الإدخال على جهاز مرّ به سابقاً: setImportantDoctorsImported(false).
  static const bool importImportantDoctors = true;
  static const String empty = "";
  static const String token = "SEND TOKEN HERE";
  static int type = 0;
  static const int zero = 0;
  static const int apiTimeOut = 50000;
  static String isLogin = Routes.onboarding;
  static bool isTablet = false;
  static String password = "";
}
