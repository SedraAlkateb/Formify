import 'package:flutter/material.dart';
import 'package:formify/presentation/resources/color_manager.dart';

Future<void> showPasswordDialog({
  required BuildContext context,
  required VoidCallback onSuccess,
  required String correctPassword, // كلمة السر الصحيحة للمقارنة
}) async {
  final TextEditingController passwordController =
  TextEditingController();

  bool obscure = true;

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white, // خلفية ثابتة بيضاء

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),

            title: const Text("دخول الإعدادات", style: const TextStyle(
              color: ColorManager.primary, // أزرق ثابت
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),),

            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "أدخل كلمة السر للدخول إلى الإعدادات",
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: passwordController,
                  obscureText: obscure,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    hintText: "كلمة السر",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscure
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          obscure = !obscure;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),

            actions: [

              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[700],
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("إلغاء", style: TextStyle(fontWeight: FontWeight.w600),),
              ),

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
                  if (passwordController.text ==
                      correctPassword) {
                    Navigator.of(context).pop();
                    onSuccess();
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content:
                        Text("كلمة السر غير صحيحة"),
                      ),
                    );
                  }
                },
                child: const Text("دخول"),
              ),
            ],
          );
        },
      );
    },
  );
}