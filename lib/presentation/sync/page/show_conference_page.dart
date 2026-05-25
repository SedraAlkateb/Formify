import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/app/app_preferences.dart';
import 'package:formify/app/constants.dart';
import 'package:formify/app/di.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/responsive/font_responseve.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';
import 'package:formify/presentation/sync/widget/doforma_container_widget.dart';
import 'package:formify/presentation/sync/widget/gialog_add_password.dart';
import 'package:formify/presentation/unit/animation/button_animation_with_text.dart';
import 'package:formify/presentation/unit/animation/animation_container_widget.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // حزمة الـ ScreenUtil لإدارة الأحجام الذكية

class ShowConferencePage extends StatefulWidget {
  const ShowConferencePage({super.key});

  @override
  State<ShowConferencePage> createState() => _ShowConferencePageState();
}

class _ShowConferencePageState extends State<ShowConferencePage> {
  @override
  void initState() {
    // السلوك واللوجيك البرمجي مئة بالمئة دون أي تغيير
    BlocProvider.of<SyncBloc>(context).add(GetConferenceAsyncEvent());
    BlocProvider.of<SyncBloc>(context).add(GetSurveyAsyncEvent());
    BlocProvider.of<SyncBloc>(context).add(SpecEvent());
    BlocProvider.of<SyncBloc>(context).add(DoctorEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          height: screenHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorManager.firstScreenBackground2,
                ColorManager.firstScreenBackground1,
                ColorManager.firstScreenBackground1,
              ],
            ),
          ),
          child: SafeArea(
            child: BlocBuilder<SyncBloc, SyncState>(
              buildWhen: (previous, current) =>
              current is GetConferenceAsyncLoadingState ||
                  current is AsyncConferenceErrorState ||
                  current is GetConferenceAsyncState ||
                  current is GetConferenceAsyncEmptyState,
              builder: (context, state) {
                if (state is GetConferenceAsyncLoadingState) {
                  return loadingFullScreen(context);
                } else if (state is AsyncConferenceErrorState) {
                  return errorFullScreen(context);
                } else if (state is GetConferenceAsyncState) {
                  instance<AppPreferences>().setLoggedIn(2);
                  GetAllConferenceModel conferenceModel = state.conferenceModel;

                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(Constants.isTablet ? 16.r : 0),
                      child: Column(
                        children: [
                          FloatingContainer(),
                          LayoutBuilder(
                            builder: (_, c) {
                              return Container(
                                height: null, // الحفاظ على مرونة الارتفاع لمنع الـ Overflow
                                width: double.infinity,
                                padding: EdgeInsets.all(16.r),
                                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ColorManager.border,
                                  ),
                                  color: ColorManager.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: ColorManager.black.withOpacity(0.12),
                                      blurRadius: 4.r,
                                      offset: Offset(0, 2.h),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 8.w,
                                    right: 8.w,
                                    top: 8.h,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // اسم المؤتمر
                                          Text(
                                            conferenceModel.name,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: ColorManager.primary,
                                              fontSize: FontResponsive.font(
                                                context,
                                                mobile: 22,
                                                tablet: 28,
                                              ).sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          // وصف المؤتمر
                                          Text(
                                            conferenceModel.description,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: ColorManager.black,
                                              fontSize: FontResponsive.font(
                                                context,
                                                mobile: 13,
                                                tablet: 16,
                                              ).sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(height: 12.h),

                                          // كارت العنوان (Address)
                                          AnimationContainerWidget(
                                            child: Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.all(10.r),
                                              margin: EdgeInsets.symmetric(vertical: 4.h),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: ColorManager.border,
                                                ),
                                                color: ColorManager.primaryShadow.withOpacity(0.12),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                children: [
                                                  Card(
                                                    margin: EdgeInsets.all(4.r),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    color: ColorManager.primary,
                                                    child: Padding(
                                                      padding: EdgeInsets.all(6.r),
                                                      child: Icon(
                                                        Icons.location_on_outlined,
                                                        color: const Color(0xffffffff),
                                                        size: 20.r,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "العنوان",
                                                            textAlign: TextAlign.right,
                                                            style: TextStyle(
                                                              color: ColorManager.textSecondary,
                                                              fontSize: FontResponsive.font(
                                                                context,
                                                                mobile: 12,
                                                                tablet: 14,
                                                              ).sp,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                          Text(
                                                            conferenceModel.address,
                                                            textAlign: TextAlign.right,
                                                            style: TextStyle(
                                                              color: ColorManager.black,
                                                              fontSize: FontResponsive.font(
                                                                context,
                                                                mobile: 14,
                                                                tablet: 17,
                                                              ).sp,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          // كارت التاريخ (Date)
                                          AnimationContainerWidget(
                                            child: Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.all(10.r),
                                              margin: EdgeInsets.symmetric(vertical: 4.h),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: ColorManager.border,
                                                ),
                                                color: ColorManager.primaryShadow.withOpacity(0.12),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                children: [
                                                  Card(
                                                    margin: EdgeInsets.all(4.r),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    color: ColorManager.primary,
                                                    child: Padding(
                                                      padding: EdgeInsets.all(6.r),
                                                      child: Icon(
                                                        Icons.date_range_sharp,
                                                        color: const Color(0xffffffff),
                                                        size: 20.r,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "التاريخ",
                                                            textAlign: TextAlign.right,
                                                            style: TextStyle(
                                                              color: ColorManager.textSecondary,
                                                              fontSize: FontResponsive.font(
                                                                context,
                                                                mobile: 12,
                                                                tablet: 14,
                                                              ).sp,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                          Text(
                                                            "تاريخ البدء: ${conferenceModel.startDate}",
                                                            textAlign: TextAlign.right,
                                                            style: TextStyle(
                                                              color: ColorManager.black,
                                                              fontSize: FontResponsive.font(
                                                                context,
                                                                mobile: 13,
                                                                tablet: 16,
                                                              ).sp,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            "تاريخ الانتهاء: ${conferenceModel.endDate}",
                                                            textAlign: TextAlign.right,
                                                            style: TextStyle(
                                                              color: ColorManager.black,
                                                              fontSize: FontResponsive.font(
                                                                context,
                                                                mobile: 13,
                                                                tablet: 16,
                                                              ).sp,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          // 🛡️ كارت الاختصاصات الطبية (تمت إعادته ليكون داخل حاوية كالعادة)
                                          AnimationContainerWidget(
                                            child: Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.all(10.r),
                                              margin: EdgeInsets.symmetric(vertical: 4.h),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: ColorManager.border,
                                                ),
                                                color: ColorManager.primaryShadow.withOpacity(0.12),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Card(
                                                    margin: EdgeInsets.all(4.r),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    color: ColorManager.primary,
                                                    child: Padding(
                                                      padding: EdgeInsets.all(6.r),
                                                      child: Icon(
                                                        Icons.bookmarks_outlined,
                                                        color: const Color(0xffffffff),
                                                        size: 20.r,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "الاختصاصات الطبية",
                                                            textAlign: TextAlign.right,
                                                            style: TextStyle(
                                                              color: ColorManager.textSecondary,
                                                              fontSize: FontResponsive.font(
                                                                context,
                                                                mobile: 12,
                                                                tablet: 14,
                                                              ).sp,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                          SizedBox(height: 6.h),
                                                          // عرض الاختصاصات كـ نص منسق داخل الحاوية السابقة
                                                          conferenceModel.spec != null && conferenceModel.spec.isNotEmpty
                                                              ? Text(
                                                            conferenceModel.spec.map((e) => e.title).join(' ، '),
                                                            textAlign: TextAlign.right,
                                                            style: TextStyle(
                                                              color: ColorManager.black,
                                                              fontSize: FontResponsive.font(
                                                                context,
                                                                mobile: 13,
                                                                tablet: 16,
                                                              ).sp,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          )
                                                              : Text(
                                                            "لا توجد اختصاصات محددة",
                                                            textAlign: TextAlign.right,
                                                            style: TextStyle(
                                                              color: Colors.grey.shade600,
                                                              fontSize: FontResponsive.font(
                                                                context,
                                                                mobile: 12,
                                                                tablet: 14,
                                                              ).sp,
                                                              fontWeight: FontWeight.bold,
                                                              fontStyle: FontStyle.italic,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 16.h),

                                      // أزرار التحكم
                                      Column(
                                        children: [
                                          buttonAnimationWithText(context, () {
                                            Navigator.pushNamed(
                                              context,
                                              Routes.insertUser,
                                            );
                                          }, "ابدأ الاستبيانات"),
                                          SizedBox(height: 8.h),
                                          buttonAnimationWithText(context, () {
                                            showPasswordDialog(
                                              context: context,
                                              onSuccess: () {
                                                BlocProvider.of<SyncBloc>(context).add(GetInfoConferenceEvent());
                                                BlocProvider.of<SyncBloc>(context).add(GetAllUserEvent());

                                                Navigator.pushNamed(
                                                  context,
                                                  Routes.settingPage,
                                                  arguments: conferenceModel.id,
                                                );
                                              },
                                              correctPassword: instance<AppPreferences>().getPassword() ?? "لا يوجد كلمة سر",
                                            );
                                          }, "إعدادات المؤتمر"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state is GetConferenceAsyncEmptyState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      emptyFullScreen(context),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: 10.h,
                            horizontal: 16.w,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 3,
                        ),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            Routes.home,
                                (route) => false,
                          );
                        },
                        child: const Text("العودة إلى الرئيسية"),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}