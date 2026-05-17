import 'package:flutter/material.dart';
import 'package:formify/presentation/resources/color_manager.dart';

Future<void> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  required VoidCallback onConfirm1,
   VoidCallback? onConfirm2,
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
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. السطر الأول: "إلغاء" و "نعم" بجانب بعضهما بالتساوي
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        "إلغاء",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12), // مسافة بين الزرين
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.primary, // أزرق ثابت
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        onConfirm1();
                      },
                      child: const Text(
                        "نعم",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12), // مسافة رأسية قبل الزر الثالث

              // 2. السطر الثاني: زر "عرض قائمة حضور" مستقر في سطر بمفرده وممتد بالكامل
              onConfirm2!=null?  SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primary, // أزرق ثابت
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    onConfirm2(); // السلوك الأصلي كما هو دون تغيير
                  },
                  child: const Text(
                    "عرض قائمة حضور",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ):SizedBox(),
            ],
          ),
        ],
      );
    },
  );
}