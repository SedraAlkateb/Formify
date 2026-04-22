import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/app/app_preferences.dart';
import 'package:formify/app/di.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';

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
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: ColorManager.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<int?>(
              valueListenable: selected,
              builder: (context, value, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildRadioOption(
                      label: "نعم",
                      value: 1,
                      groupValue: value,
                      onChanged: (v) => selected.value = v,
                    ),
                    const SizedBox(width: 24),
                    _buildRadioOption(
                      label: "لا",
                      value: 0,
                      groupValue: value,
                      onChanged: (v) => selected.value = v,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          ValueListenableBuilder<int?>(
            valueListenable: selected,
            builder: (context, value, _) {
              return SizedBox(
                width: double.infinity, // جعل الزر بعرض الحوار
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: value == null ? 0 : 4,
                  ),
                  onPressed: value == null
                      ? null
                      : () async {
                    // 1. حفظ التفضيلات أولاً
                    await instance<AppPreferences>().setGameORSurvey(value);

                    // 2. إغلاق الحوار
                    if (dialogContext.mounted) {
                      Navigator.of(dialogContext).pop();
                    }

                    // 3. الانتقال للصفحة التالية باستخدام اصل الـ context
                    if (context.mounted) {


                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.showConference,
                            (route) => false,
                      );
                      BlocProvider.of<SyncBloc>(context).add(GetConferenceAsyncEvent());
                      BlocProvider.of<SyncBloc>(context).add(DoctorEvent());
                    }

                    // ملاحظة: لا تستدعي selected.dispose() هنا لأنها قد تسبب خطأ
                    // إذا حاول الـ Builder الوصول إليها أثناء الإغلاق.
                    // الفلاتر سيتكفل بها أو يفضل تركها للـ Garbage Collector في هذه الحالة.
                  },
                  child: const Text("عرض"),
                ),
              );
            },
          ),
        ],
      );
    },
  );
}

// Widget مساعد لتنظيف الكود ومنع التكرار في خيارات الـ Radio
Widget _buildRadioOption({
  required String label,
  required int value,
  required int? groupValue,
  required ValueChanged<int?> onChanged,
}) {
  return InkWell(
    onTap: () => onChanged(value),
    borderRadius: BorderRadius.circular(8),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<int>(
          value: value,
          groupValue: groupValue,
          activeColor: ColorManager.primary,
          onChanged: onChanged,
        ),
        Text(label),
      ],
    ),
  );
}