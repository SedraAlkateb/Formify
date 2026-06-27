import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formify/app/constants.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/active_conference/bloc/active_conference_bloc.dart';
import 'package:formify/presentation/conference/widget/conferm_dialog.dart';
import 'package:formify/presentation/home/widget/data_widget.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/responsive/font_responseve.dart';
import 'package:formify/presentation/resources/values_manager.dart';

class ActiveConferenceWidget extends StatelessWidget {
  const ActiveConferenceWidget({
    super.key,
    required this.conference,
    required this.index,
  });

  final GetAllConferenceModel conference;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
      padding: EdgeInsets.all(AppPadding.p16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // حواف أنعم وأحدث
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04), // ظل خفيف جداً وراقي
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==================== القسم العلوي: الرقم والعنوان ====================
        // ==================== القسم العلوي: الرقم والاسم بجانب بعضهما (مطور وأوضح) ====================
        Row(
        crossAxisAlignment: CrossAxisAlignment.center, // لضمان بقاء الرقم محاذياً لأول سطر من الاسم إذا كان طويلاً
        children: [
          // بطاقة رقم المؤتمر الصغيرة والأنيقة
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
            margin: EdgeInsets.only(top: 2.h), // وزنية بسيطة ليتناسق مع ارتفاع نص الاسم
            decoration: BoxDecoration(
              color: ColorManager.primary.withOpacity(0.08), // خلفية ناعمة بلون البريمري
              borderRadius: BorderRadius.circular(8), // حواف ناعمة حديثة بدلاً من الدائرة التقليدية
            ),
            child: Text(
              "#$index", // رمز الهاشتاق مع الرقم ليكون واضحاً ومختصراً
              style: TextStyle(
                fontSize: FontResponsive.font(context, mobile: 13, tablet: 16),
                fontWeight: FontWeight.bold, // خط عريض وبارز جداً للرقم
                color: ColorManager.primary,
              ),
            ),
          ),

          SizedBox(width: 12.w), // مسافة تفصل الرقم عن بداية الاسم

          // اسم المؤتمر الممتد
          Expanded(
            child: Text(
              conference.name,
              maxLines: 2, // يكتفي بسطرين ليعطي الكارد مظهراً متناسقاً ونظيفاً
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: FontResponsive.font(context, mobile: 16, tablet: 20),
                fontWeight: FontWeight.bold, // وضوح ممتاز للخط
                color: const Color(0xFF0F172A), // لون داكن فاخر يعطي أعلى درجات الوضوح للقراءة
                height: 1.3, // مسافة مريحة بين السطور إذا نزل الاسم للسطر الثاني
              ),
            ),
          ),
        ],
      ),

          SizedBox(height: AppSize.s16),

          // ==================== القسم الأوسط: التواريخ (عرض مرن ومنسق) ====================
          Row(
            children: [
              Expanded(
                child: _buildDateBadge(
                  context,
                  title: "البدء",
                  date: conference.startDate,
                  icon: Icons.calendar_today_outlined,
                  accentColor: ColorManager.success,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _buildDateBadge(
                  context,
                  title: "الانتهاء",
                  date: conference.endDate,
                  icon: Icons.history_toggle_off_rounded,
                  accentColor: ColorManager.error,
                ),
              ),
            ],
          ),

          SizedBox(height: AppSize.s12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)), // خط فاصل ناعم ورفيع
          SizedBox(height: AppSize.s12),

          // ==================== القسم السفلي: أزرار التحكم والـ Actions ====================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // زر الحذف بتصميم زجاجي ناعم وبدون حواف كارد حادة
              InkWell(
                onTap: () => showConfirmDialog(
                  context: context,
                  title: "حذف المؤتمر",
                  message: "هل تريد حقاً حذف مؤتمر منتهي؟",
                  onConfirm1: () {
                    BlocProvider.of<ActiveConferenceBloc>(context).add(
                      DeleteFinishedConferenceEvent(conference.id, index),
                    );
                  },
                ),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: ColorManager.error.withOpacity(0.08), // خلفية خفيفة وراقية جداً
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.delete_outline_rounded, // أيقونة أنعم
                    color: ColorManager.error,
                    size: 22,
                  ),
                ),
              ),

              // زر الانتقال أو السهم للإشارة إلى قابلية الضغط
              Row(
                children: [
                  Text(
                    "تفاصيل",
                    style: TextStyle(
                      fontSize: FontResponsive.font(context, mobile: 12, tablet: 15),
                      color: ColorManager.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.arrow_forward_ios_rounded, // سهم أنيق وعصري يناسب الأبعاد
                    color: ColorManager.primary,
                    size: Constants.isTablet ? 18 : 14,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ميثود مساعدة لبناء الـ Badges الخاصة بالتواريخ لضمان نظافة الكود وتناسقه
  Widget _buildDateBadge(
      BuildContext context, {
        required String title,
        required String date,
        required IconData icon,
        required Color accentColor,
      }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC), // خلفية رمادية خفيفة وموحدة للمحتوى
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8), // إطار خفيف
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: accentColor),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: FontResponsive.font(context, mobile: 11, tablet: 14),
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  date,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: FontResponsive.font(context, mobile: 12, tablet: 15),
                    color: const Color(0xFF334155),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}