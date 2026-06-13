import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // استيراد حزمة الـ ScreenUtil للـ Responsive

// استيرادات تطبيق DoForm (formify) الخاصة بك
import 'package:formify/app/constants.dart';
import 'package:formify/presentation/conference/bloc/conference_bloc.dart';
import 'package:formify/presentation/home/widget/dialog_game_survey_widget.dart';
import 'package:formify/presentation/home/widget/grid_icon.dart';
import 'package:formify/presentation/home/widget/isMorning.dart';
import 'package:formify/presentation/home/widget/multi__bloc_for_conference_widget.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/responsive/breakpoints.dart';
import 'package:formify/presentation/resources/values_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // إطلاق حدث جلب المؤتمرات غير النشطة عند بناء الشاشة
    context.read<ConferenceBloc>().add(GetAllNotActiveConferenceEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // استخدام PopScope الحديث كبديل لـ WillPopScope المهجور لحماية الشاشة من الإغلاق العشوائي
    return PopScope(
      canPop: false, // منع الرجوع للخلف لحماية حالة المؤتمر
      child: Scaffold(
        backgroundColor: ColorManager.background,
        body: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            // بناء محتوى الصفحة بناءً على نوع الجهاز الحالي (جوال أو تابلت)
            LayoutBuilder(
              builder: (_, constraints) {
                final isTabletPortrait = Breakpoints.isTabletPortrait(context);
                final isMobilePortrait = Breakpoints.isMobilePortrait(context);

                if (isTabletPortrait || isMobilePortrait) {
                  return const HomeMobilePage();
                }
                return const HomeTabletPage();
              },
            ),

            // زر "ابدأ المؤتمر" العائم في أسفل اليسار بأبعاد ريسبونسف مكيّفة
            Padding(
              padding: EdgeInsets.all(30.r), // تباعد ريسبونسف دائري متناسق للزر
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primary, // لون الخلفية الأساسي لشركة دومِنا
                  foregroundColor: Colors.white, // لون النص
                  padding: EdgeInsets.symmetric(vertical: 10.h), // تباعد عمودي مرن
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r), // تدوير الحواف بشكل متناسق
                  ),
                  elevation: 4,
                ),
                onPressed: () {
                  showDialogGameSurveyWidget(
                    context: context,
                    title: "طريقة عرض الاستبيان",
                    message: "هل تريد ان تكون طريقة عرض الاستبيان لعبة ؟",
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w), // بديل للمسافات الفارغة النصية لتأمين ثبات التصميم
                  child: Text(
                    "ابدأ المؤتمر",
                    style: TextStyle(
                      fontSize: 15.sp, // خط مرن يتكيف تلقائياً مع أحجام الشاشات
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// =========================================================================
/// 📱 تصميم واجهة الجوال (HomeMobilePage) المعتمدة على ScreenUtil
/// =========================================================================
class HomeMobilePage extends StatelessWidget {
  const HomeMobilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        vertical: AppPadding.p10.h, // تحويل تباعد القيمة العمودية للـ Responsive
        horizontal: AppPadding.p16.w, // تحويل تباعد القيمة الأفقية للـ Responsive
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30.h), // مسافة عمودية مرنة
          Text(
            getGreeting(),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 28.sp, // خط متكيف لعنوان الترحيب الصباحي/المسائي
            ),
          ),
          Text(
            "Domina",
            style: TextStyle(
              color: ColorManager.secondary,
              fontWeight: FontWeight.w600,
              fontSize: 18.sp, // خط متكيف لاسم الشركة
            ),
          ),
          Column(
            children: [
              SizedBox(height: 10.h),
              const CustomGridPage(),
              SizedBox(height: 20.h),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "المؤتمرات قيد المعالجة",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp, // حجم خط متناسق ومعتمد على الـ sp
                    ),
                  ),
                  SizedBox(height: 10.h),
                  multiBlocConferenceWidget(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// =========================================================================
/// 平板 تصميم واجهة التابلت (HomeTabletPage) المعتمدة على ScreenUtil
/// =========================================================================
class HomeTabletPage extends StatelessWidget {
  const HomeTabletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: Constants.isTablet
            ? EdgeInsets.only(top: 20.h, left: 24.w, right: 24.w) // أبعاد التابلت بـ ScreenUtil
            : EdgeInsets.only(top: 10.h, left: 0, right: 10.w),
        child: Column(
          children: [
            // السطر العلوي للترحيب والشعار في التابلت
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  getGreeting(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 32.sp, // خط تابلت متكيف ومحمي من التضخم المفرط
                  ),
                ),
                Text(
                  "Domina",
                  style: TextStyle(
                    color: ColorManager.secondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            // تقسيم الشاشة إلى عمودين متساويين في التابلت باستخدام Expanded
            Expanded(
              child: Row(
                children: [
                  // العمود الأول: يحتوي على أزرار وشبكة الأيقونات الأساسية
                  const Expanded(
                    flex: 1,
                    child: CustomGridPage(),
                  ),
                  // العمود الثاني: يحتوي على قائمة المؤتمرات قيد المعالجة
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.only(top: 20.h, right: 20.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "المؤتمرات قيد المعالجة",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 24.sp, // حجم خط مخصص للتابلت عبر الـ sp
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(height: 20.h),
                                      multiBlocConferenceWidget(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}