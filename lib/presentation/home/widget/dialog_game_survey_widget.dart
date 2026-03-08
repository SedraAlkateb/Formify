import 'package:flutter/material.dart';
import 'package:formify/app/app_preferences.dart';
import 'package:formify/app/di.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';

Future<void> showDialogGameSurveyWidget({
  required BuildContext context,
  required String title,
  required String message,
}) async {
  final selected = ValueNotifier<int?>(null); // 1 = yes, 0 = no

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.white, // خلفية ثابتة بيضاء
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(title, style: const TextStyle(
          color: ColorManager.primary, // أزرق ثابت
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message,  style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
            ),),
            const SizedBox(height: 12),

            ValueListenableBuilder<int?>(
              valueListenable: selected,
              builder: (context, value, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        selected.value = 1;
                        instance<AppPreferences>().setGameORSurvey(1);
                      },
                      child: Row(
                        children: [
                          Radio<int>(
                            value: 1,
                            groupValue: value,
                            onChanged: (v) {
                              selected.value = v;
                              instance<AppPreferences>().setGameORSurvey(1);
                            },
                          ),
                          const Text("نعم"),
                        ],
                      ),
                    ),

                    const SizedBox(width: 24),

                    InkWell(
                      onTap: () {
                        selected.value = 0;
                        instance<AppPreferences>().setGameORSurvey(0);
                      },
                      child: Row(
                        children: [
                          Radio<int>(
                            value: 0,
                            groupValue: value,
                            onChanged: (v) {
                              selected.value = v;
                              instance<AppPreferences>().setGameORSurvey(0);
                            },
                          ),
                          const Text("لا"),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),

        actions: [
          ValueListenableBuilder<int?>(
            valueListenable: selected,
            builder: (context, value, _) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                onPressed: value == null
                    ? null
                    : () {
                  Navigator.of(dialogContext).pop();
                  Navigator.pushNamedAndRemoveUntil(context,
                    Routes.showConference,(route) => false,);
                  selected.dispose(); // تنظيف
                },
                child: const Text("عرض"),
              );
            },
          ),
        ],
      );
    },
  );
}