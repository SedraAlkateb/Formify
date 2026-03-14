import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/app/app_preferences.dart';
import 'package:formify/app/constants.dart';
import 'package:formify/app/di.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/responsive/breakpoints.dart';
import 'package:formify/presentation/resources/responsive/font_responseve.dart';
import 'package:formify/presentation/resources/responsive/sizer_responseve.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';
import 'package:formify/presentation/sync/widget/doforma_container_widget.dart';
import 'package:formify/presentation/sync/widget/gialog_add_password.dart';
import 'package:formify/presentation/unit/animation/button_animation_with_text.dart';
import 'package:formify/presentation/unit/animation/animation_container_widget.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';

class ShowConferencePage extends StatefulWidget {
  const ShowConferencePage({super.key});

  @override
  State<ShowConferencePage> createState() => _ShowConferencePageState();
}

class _ShowConferencePageState extends State<ShowConferencePage> {
  @override
  void initState() {
    BlocProvider.of<SyncBloc>(context).add(GetConferenceAsyncEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(
      context,
    ).size.height; // للحصول على ارتفاع الشاشة

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
                      padding:  EdgeInsets.all(
                         Constants.isTablet?30:
                          0),
                      child: Column(

                        children: [
                          FloatingContainer(),
                          LayoutBuilder(
                            builder: (_, c) {
                              final isTabletPortrait =
                                  Breakpoints.isTabletPortrait(context);
                              final isMobilePortrait =
                                  Breakpoints.isMobilePortrait(context);
                              return Container(
                                height:(isTabletPortrait || isMobilePortrait)? screenHeight * 0.7:null,
                                width: double.infinity,
                                padding:
                                EdgeInsets.only(
                                  left:

                                  20.sp,
                                  right: 20.sp,
                                  top: 20.sp,
                                  bottom: 20.sp
                                ),

                                margin: EdgeInsets.all(25.sp),
                                decoration: BoxDecoration(
                                  border: Border.all(color: ColorManager.border),
                                  color: ColorManager.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: ColorManager.black.withOpacity(0.2),
                                      blurRadius: 3,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 20.sp,
                                    right: 20.sp,
                                    top: 20.sp,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            conferenceModel.name,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: ColorManager.primary,
                                              fontSize: FontResponsive.font(
                                                context,
                                                mobile: 35,
                                                tablet: 41,
                                              ),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 5.sp),
                                          Text(
                                            conferenceModel.description,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: ColorManager.black,
                                              fontSize: FontResponsive.font(
                                                context,
                                                mobile: 15,
                                                tablet: 21,
                                              ),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),

                                          // Address
                                          AnimationContainerWidget(
                                            child: Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.all(12.sp),
                                              margin: EdgeInsets.symmetric(
                                                vertical: 12.sp,
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: ColorManager.border,
                                                ),
                                                color: ColorManager.primaryShadow
                                                    .withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(
                                                  25,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Card(
                                                    margin: EdgeInsets.all(5.sp),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(12),
                                                    ),
                                                    color: ColorManager.primary,
                                                    child: Padding(
                                                      padding: EdgeInsets.all(10.sp),
                                                      child: Icon(
                                                        Icons.location_on_outlined,
                                                        color: Color(0xffffffff),
                                                        size: 30.sp,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.all(8.0.sp),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "العنوان",
                                                            textAlign:
                                                            TextAlign.right,
                                                            style: TextStyle(
                                                              color: ColorManager
                                                                  .textSecondary,
                                                              fontSize:
                                                              FontResponsive.font(
                                                                context,
                                                                mobile: 15,
                                                                tablet: 21,
                                                              ),
                                                              fontWeight:
                                                              FontWeight.w500,
                                                            ),
                                                          ),
                                                          Text(
                                                            conferenceModel.address,
                                                            textAlign:
                                                            TextAlign.right,
                                                            style: TextStyle(
                                                              color:
                                                              ColorManager.black,
                                                              fontSize:
                                                              FontResponsive.font(
                                                                context,
                                                                mobile: 18,
                                                                tablet: 24,
                                                              ),
                                                              fontWeight:
                                                              FontWeight.bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 20.sp),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5.sp),
                                          // Date
                                          AnimationContainerWidget(
                                            child: Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.all(12.sp),
                                              margin: EdgeInsets.symmetric(
                                                vertical: 12.sp,
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: ColorManager.border,
                                                ),
                                                color: ColorManager.primaryShadow
                                                    .withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(
                                                  25,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Card(
                                                    margin: EdgeInsets.all(5.sp),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(12),
                                                    ),
                                                    color: ColorManager.primary,
                                                    child: Padding(
                                                      padding: EdgeInsets.all(10.sp),
                                                      child: Icon(
                                                        Icons.date_range_sharp,
                                                        color: Color(0xffffffff),
                                                        size: 30.sp,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.all(8.0.sp),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "التاريخ",
                                                            textAlign:
                                                            TextAlign.right,
                                                            style: TextStyle(
                                                              color: ColorManager
                                                                  .textSecondary,
                                                              fontSize:
                                                              FontResponsive.font(
                                                                context,
                                                                mobile: 15,
                                                                tablet: 21,
                                                              ),
                                                              fontWeight:
                                                              FontWeight.w500,
                                                            ),
                                                          ),
                                                          Text(
                                                            "تاريخ البدء: ${conferenceModel.startDate}",
                                                            textAlign:
                                                            TextAlign.right,
                                                            style: TextStyle(
                                                              color:
                                                              ColorManager.black,
                                                              fontSize:
                                                              FontResponsive.font(
                                                                context,
                                                                mobile: 18,
                                                                tablet: 24,
                                                              ),
                                                              fontWeight:
                                                              FontWeight.bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            "تاريخ الانتهاء: ${conferenceModel.endDate}",
                                                            textAlign:
                                                            TextAlign.right,
                                                            style: TextStyle(
                                                              color:
                                                              ColorManager.black,
                                                              fontSize:
                                                              FontResponsive.font(
                                                                context,
                                                                mobile: 18,
                                                                tablet: 24,
                                                              ),
                                                              fontWeight:
                                                              FontWeight.bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 20.sp),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          buttonAnimationWithText(context, () {
                                            Navigator.pushNamed(
                                              context,
                                              Routes.insertUser,
                                            );
                                          }, "ابدأ الاستبيانات"),
                                          const SizedBox(height: 10),
                                          buttonAnimationWithText(context, () {
                                            showPasswordDialog(
                                              context: context,
                                              onSuccess: () {
                                                BlocProvider.of<SyncBloc>(
                                                  context,
                                                ).add(GetInfoConferenceEvent());
                                                Navigator.pushNamed(
                                                  context,
                                                  Routes.settingPage,
                                                  arguments: conferenceModel.id,
                                                );
                                              },
                                              correctPassword:
                                                  instance<AppPreferences>()
                                                      .getPassword() ??
                                                  "لا يوجد كلمة سر",
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
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
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
