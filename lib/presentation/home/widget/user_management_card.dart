import 'package:flutter/material.dart';

class UserManagementCard extends StatelessWidget {
  final VoidCallback? onTap;

  const UserManagementCard({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // تفعيل اتجاه النص من اليمين إلى اليسار بما يتناسب مع لغة واجهة صورة image_eeda97.png
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.only(top: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32.0),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
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
                // 1. الأيقونة على اليمين بخلفية بنفسجية ناعمة
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E8FF), // بنفسجي فاتح جداً ناعم
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: const Icon(
                    Icons.people_alt_outlined,
                    color: Color(0xFF7C3AED), // بنفسجي داكن للأيقونة
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),

                // 2. النصوص والـ Badge في المنتصف واليسار
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // السطر العلوي: يحوي العنوان والـ Badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                            child: Text(
                              'إدارة مستخدمي\nالنظام',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B), // لون داكن مريح للعين
                                height: 1.3,
                              ),
                            ),
                          ),
                          // الـ Badge البنفسجي لعدد المستخدمين
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1E7FE),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '60\nمستخدم',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8B5CF6),
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // السطر السفلي: الوصف والسهم الصغير جهة اليسار
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Expanded(
                            child: Text(
                              'فلترة وتعديل بيانات كافة الأطباء والمشاركين المسجلين في النظام، مع معاينة الاستبيانات.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF94A3B8), // رمادي فاتح للوصف المساعد
                                height: 1.5,
                              ),
                            ),
                          ),
                          // السهم الصغير في أقصى اليسار
                          Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 14,
                            color: const Color(0xFF8B5CF6).withOpacity(0.5),
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