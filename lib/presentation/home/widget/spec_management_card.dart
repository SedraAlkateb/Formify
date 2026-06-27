import 'package:flutter/material.dart';
import 'package:formify/presentation/resources/color_manager.dart';

/// [UserManagementCard] هو كارد تفاعلي يُستخدم في لوحة التحكم الرئيسية لإدارة الأطباء والمستخدمين.
/// تم تحديث الألوان بالكامل بناءً على درجات الأزرق البترولي والدنيم الفاخرة المعتمدة لديك.
class SpecManagementCard extends StatelessWidget {
  final VoidCallback? onTap;

  const SpecManagementCard({super.key, this.onTap});


  @override
  Widget build(BuildContext context) {
    // 🌟 تفعيل اتجاه النص من اليمين إلى اليسار لدعم اللغة العربية بالكامل
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.only(top: 25),
        decoration: BoxDecoration(
          color: Colors.white, // جسم الكارد بلون أبيض ناصع ومريح
          borderRadius: BorderRadius.circular(32.0),
          boxShadow: [
            // ظلال ناعمة جداً مائلة للون الهوية الهادئ لمنع حدة اللون الأسود
            BoxShadow(
              color: ColorManager.splash3.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.01),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(32.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1️⃣ الأيقونة اليمنى: خلفية زرقاء ناعمة مشتقة من splash1 وأيقونة بلون primary الداكن
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: ColorManager.splash1.withOpacity(0.12), // درجة باهتة وراقية جداً من اللون
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: const Icon(
                    Icons.folder_special_outlined,
                    color: ColorManager.primary, // اللون الأساسي الداكن للأيقونة لتعزيز البصمة اللمسية
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),

                // 2️⃣ قسم النصوص والبيانات التفاعلية
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // السطر العلوي: العنوان ومؤشر عدد المستخدمين (Badge)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                            child: Text(
                              'إدارة اختصاصات\nالنظام',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B), // لون رمادي داكن فاخر جداً للنصوص الأساسية
                                height: 1.3,
                              ),
                            ),
                          ),

                        ],
                      ),
                      const SizedBox(height: 12),

                      // السطر السفلي: الوصف التفصيلي وسهم الانتقال
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Expanded(
                            child: Text(
                              'اضافة وتعديل وحذف وفلترة بيانات كافة الاختصاصات',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF94A3B8), // رمادي ناعم وخفيف للسطور التوضيحية المساعدة
                                height: 1.5,
                              ),
                            ),
                          ),

                          // سهم الانتقال الصغير الموجه لليمين/اليسار بلون splash3 الهادئ
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: ColorManager.splash3.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}