import 'package:flutter/material.dart';
import 'package:formify/presentation/resources/color_manager.dart';

Future<void> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  required VoidCallback onConfirm,
}) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    useSafeArea: true,
    builder: (context) {

      return AlertDialog(
        backgroundColor: Colors.white, // خلفية ثابتة بيضاء

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),


        title: Text(
          title,
          style: const TextStyle(
            color: ColorManager.primary, // أزرق ثابت
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),

        content: Text(
          message,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 15,
          ),
        ),

        actionsPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

        actions: [

          /// زر إلغاء
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[700],
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              "إلغاء",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),

          /// زر تأكيد أزرق ثابت
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.primary, // أزرق ثابت
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            child: const Text(
              "نعم",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}