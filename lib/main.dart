import 'package:flutter/material.dart';
import 'package:formify/app/app.dart';
import 'package:formify/app/di.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await initAppModule();
  runApp(const MyApp());
}

// Future<void> testGeminiConnection() async {
//   // 1. ضع مفتاحك هنا مباشرة للتجربة فقط
//   final apiKey = "AIzaSyAICqdmhhKC4rSbZaFUKWcYCwdSjs6eSSw";
//
//   // 2. تعريف الموديل بأكثر صيغة مستقرة
//   final model = GenerativeModel(
//     model: 'gemini-1.5-flash-latest',
//     apiKey: apiKey,
//   );
//
//   print('جاري فحص الاتصال بـ Gemini 1.5 Flash...');
//
//   try {
//     final content = [Content.text('Say hello in one word.')];
//     final response = await model.generateContent(content);
//
//     if (response.text != null) {
//       print('✅ نجح الاتصال! الرد: ${response.text}');
//     } else {
//       print('❌ استجابة فارغة من السيرفر.');
//     }
//   } catch (e) {
//     print('-----------------------------------------');
//     print('❌ فشل الاختبار. الخطأ الظاهر:');
//     print(e);
//     print('-----------------------------------------');
//
//     if (e.toString().contains('v1beta')) {
//       print('💡 تحليل: المكتبة لا تزال تطلب نسخة بيتا، تأكد من إصدار google_generative_ai في pubspec');
//     } else if (e.toString().contains('403') || e.toString().contains('API_KEY_INVALID')) {
//       print('💡 تحليل: المشكلة في صلاحية مفتاح الـ API نفسه.');
//     }
//   }
// }

// void main() async {
//   await testGeminiConnection();
// }