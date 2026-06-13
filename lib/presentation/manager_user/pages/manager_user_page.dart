import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ManagerUserPage extends StatelessWidget {
  const ManagerUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC), // خلفية ناعمة مريحة للعين مثل الصورة
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E293B)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. رأس الصفحة (Header Area)
                  _buildHeader(),
                  SizedBox(height: 16.h),

                  // 2. كروت الإحصائيات (KPI Dashboard Cards)
                  _buildKpiGrid(context),
                  SizedBox(height: 20.h),

                  // 3. قسم خيارات البحث والفلترة المتقدمة
                  _buildAdvancedFilters(context),
                  SizedBox(height: 24.h),

                  // 4. ترويسة جدول المسجلين النشطين
                  _buildListTitle(),
                  SizedBox(height: 12.h),

                  // 5. قائمة الأطباء والمستخدمين (User List Cards)
                  _buildUserCard(
                    context: context,
                    index: "1",
                    letter: "أ",
                    name: "د. أحمد علي",
                    phone: "0911111111",
                    email: "user1@example.com",
                    location: "دمشق - المزة",
                    time: "سجل في: ٢٠٢٦/٦/١٣ ١١:٣٣ ص",
                    role: "طبيب",
                    isPresent: false,
                  ),
                  SizedBox(height: 12.h),
                  _buildUserCard(
                    context: context,
                    index: "2",
                    letter: "س",
                    name: "د. سارة محمود",
                    phone: "0912345678",
                    email: "user2@example.com",
                    location: "حلب - العزيزية",
                    time: "سجل في: ٢٠٢٦/٦/١٣ ١١:٤٠ ص",
                    role: "صيدلاني",
                    isPresent: false,
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // مكوّن رأس الصفحة
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.people_alt_outlined, color: Color(0xFF7C3AED), size: 28),
                SizedBox(width: 8.w),
                const Text(
                  "إدارة مستخدمي النظام",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            const Text(
              "التحكم بالبيانات، الفلترة المتقدمة، وتعديل وتصدير معلومات الحضور",
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ],
    );
  }

  // شبكة كروت الإحصائيات (KPI Grid)
  Widget _buildKpiGrid(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildKpiItem(
                title: "المسجلون الكلي",
                value: "60",
                icon: Icons.people_outline_rounded,
                iconBgColor: const Color(0xFFF3E8FF),
                iconColor: const Color(0xFF7C3AED),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildKpiItem(
                title: "حاضرون %0",
                value: "0",
                icon: Icons.person_add_alt_1_outlined,
                iconBgColor: const Color(0xFFDCFCE7),
                iconColor: const Color(0xFF15803D),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildKpiItem(
                title: "المشاركون بالاستبيان",
                value: "1",
                icon: Icons.assignment_outlined,
                iconBgColor: const Color(0xFFDBEAFE),
                iconColor: const Color(0xFF1D4ED8),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildKpiItem(
                title: "المطابق للفلاتر",
                value: "60",
                icon: Icons.tune_rounded,
                iconBgColor: const Color(0xFFFEF3C7),
                iconColor: const Color(0xFFB45309),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        // زر إضافة مستخدم جديد الممتد بشكل عرضي جذاب
        ElevatedButton.icon(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8B5CF6),
            minimumSize: Size(double.infinity, 48.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
            elevation: 0,
          ),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            "إضافة مستخدم جديد",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
      ],
    );
  }

  Widget _buildKpiItem({
    required String title,
    required String value,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                SizedBox(height: 2.h),
                Text(title, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(16.r)),
            child: Icon(icon, color: iconColor, size: 24),
          ),
        ],
      ),
    );
  }

  // وحدة الفلترة والبحث المتقدم
  Widget _buildAdvancedFilters(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 12, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.tune_rounded, color: Color(0xFF8B5CF6), size: 20),
                    SizedBox(width: 6.w),
                    Expanded(child: const Text("خيارات البحث والفلترة المتقدمة", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B)))),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.refresh_rounded, size: 16, color: Color(0xFF64748B)),
                label: const Text("إعادة تعيين الفلاتر", style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
              )
            ],
          ),
          SizedBox(height: 12.h),
          // حقل البحث الذكي
          TextFormField(
            decoration: InputDecoration(
              hintText: "البحث السريع بـ الاسم، الهاتف، الـ ID",
              hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
              prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF94A3B8)),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r), borderSide: BorderSide.none),
            ),
          ),
          SizedBox(height: 16.h),
          _buildFilterDropdown(label: "تصفية حسب الاختصاص", value: "كل الاختصاصات", icon: Icons.filter_alt_outlined),
          SizedBox(height: 12.h),
          _buildFilterDropdown(label: "تصفية حسب المدينة", value: "كل المدن والمناطق", icon: Icons.location_on_outlined),
          SizedBox(height: 12.h),
          _buildFilterDropdown(label: "حالة تسجيل الحضور", value: "الكل (حاضر وغائب)", icon: Icons.person_search_outlined),
          SizedBox(height: 12.h),
          _buildFilterDropdown(label: "حالة تعبئة الاستبيانات", value: "الكل (حسب تفاعلهم)", icon: Icons.assignment_turned_in_outlined),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({required String label, required String value, required IconData icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
        SizedBox(height: 4.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(14.r)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B), fontWeight: FontWeight.w500)),
              Icon(icon, color: const Color(0xFF8B5CF6), size: 18),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("جدول المسجلين النشطين", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            SizedBox(height: 2.h),
            const Text("تم عرض 60 مستخدم من أصل 60", style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10.r)),
          child: const Text("تعديل حي وتفاعلي", style: TextStyle(color: Color(0xFF475569), fontSize: 11, fontWeight: FontWeight.bold)),
        )
      ],
    );
  }

  // كارد المستخدم الطبي التفاعلي الكامل
  Widget _buildUserCard({
    required BuildContext context,
    required String index,
    required String letter,
    required String name,
    required String phone,
    required String email,
    required String location,
    required String time,
    required String role,
    required bool isPresent,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الحرف الأول مع مؤشر الترتيب الرقمي المبتكر في الزاوية
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 56.w,
                      height: 56.h,
                      decoration: BoxDecoration(color: const Color(0xFFF8F5FF), borderRadius: BorderRadius.circular(16.r)),
                      alignment: Alignment.center,
                      child: Text(letter, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF8B5CF6))),
                    ),
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(color: Color(0xFF334155), shape: BoxShape.circle),
                        child: Text(index, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
                SizedBox(width: 14.w),
                // البيانات النصية للمستخدم الطبية
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(color: const Color(0xFFE0F2FE), borderRadius: BorderRadius.circular(6.r)),
                            child: Text(role, style: const TextStyle(color: Color(0xFF0369A1), fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(width: 6.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6.r)),
                            child: const Text("لم يحضر X", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      _buildInfoRow(Icons.phone_outlined, phone),
                      _buildInfoRow(Icons.mail_outline_rounded, email),
                      _buildInfoRow(Icons.location_on_outlined, location),
                      SizedBox(height: 6.h),
                      Text(time, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                    ],
                  ),
                )
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          // أزرار العمليات السفلية للتحكم بالداتا
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Row(
              children: [
                // زر حالة الاستبيان الأخضر المخصص
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8FDF0),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFFBFF6D4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.assignment_turned_in_outlined, color: Color(0xFF15803D), size: 16),
                      SizedBox(width: 6.w),
                      const Text("أكمل الاستبيانات", style: TextStyle(color: Color(0xFF15803D), fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const Spacer(),
                // أزرار الإجراءات السريعة (تعديل، ترقية، حذف)
                _buildActionButton(Icons.edit_outlined, const Color(0xFF64748B)),
                SizedBox(width: 8.w),
                _buildActionButton(Icons.person_outline_rounded, const Color(0xFF64748B)),
                SizedBox(width: 8.w),
                _buildActionButton(Icons.delete_outline_rounded, const Color(0xFFEF4444)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3.h),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFF94A3B8)),
          SizedBox(width: 6.w),
          Text(text, style: const TextStyle(fontSize: 13, color: Color(0xFF475569))),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}