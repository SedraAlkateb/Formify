import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formify/app/constants.dart';
import 'package:formify/data/mapper/mapper.dart';
import 'package:formify/presentation/active_conference/bloc/active_conference_bloc.dart';
import 'package:formify/presentation/active_conference/widget/card_survey.dart';
import 'package:formify/presentation/active_conference/widget/view_all_user.dart';
import 'package:formify/presentation/excel/bloc/excel_st_bloc.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/responsive/font_responseve.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/resources/values_manager.dart';
import 'package:formify/presentation/unit/search_field.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';

class ViewActiveConferencePage extends StatefulWidget {
  const ViewActiveConferencePage({super.key, required this.conferenceId});
  final int conferenceId;

  @override
  State<ViewActiveConferencePage> createState() =>
      _ViewActiveConferencePageState();
}

class _ViewActiveConferencePageState extends State<ViewActiveConferencePage> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<ActiveConferenceBloc>(
      context,
    ).add(GetActiveConferenceByIdEvent(widget.conferenceId));
    BlocProvider.of<ActiveConferenceBloc>(
      context,
    ).add(GetAllUserByActiveConferenceEvent(widget.conferenceId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: ColorManager.black),
        ),
        title: Text(
          "مشاركو المؤتمر",
          style: TextStyle(
            fontSize: FontResponsive.font(context, mobile: 20, tablet: 24),
            color: ColorManager.black,
          ),
        ),
        backgroundColor: ColorManager.white,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ActiveConference header section (Card with ActiveConference Info)
              BlocBuilder<ActiveConferenceBloc, ActiveConferenceState>(
                buildWhen: (previous, current) =>
                    current is GetActiveConferenceByIdState ||
                    current is GetActiveConferenceByIdLoadingState ||
                    current is GetActiveConferenceByIdErrorState,
                builder: (context, state) {
                  if (state is GetActiveConferenceByIdErrorState) {
                    return errorFullScreen(context);
                  } else if (state is GetActiveConferenceByIdLoadingState) {
                    return loadingFullScreen(context);
                  } else if (state is GetActiveConferenceByIdState) {
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: AppPadding.p16,
                            horizontal: AppPadding.p18,
                          ),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                ColorManager.splash1,
                                ColorManager.splash2,
                                //  ColorManager.splash3,
                              ],
                              begin: Alignment
                                  .topLeft, // البداية من الزاوية العليا اليسرى
                              end: Alignment
                                  .bottomRight, // النهاية عند الزاوية السفلى اليمنى
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(AppPadding.p16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.conferenceModel.name,
                                  style: TextStyle(
                                    fontSize: FontResponsive.font(
                                      context,
                                      mobile: 20,
                                      tablet: 24,
                                    ),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // ActiveConference Description
                                Text(
                                  state.conferenceModel.description,
                                  style: TextStyle(
                                    fontSize: FontResponsive.font(
                                      context,
                                      mobile: 16,
                                      tablet: 20,
                                    ),
                                    color: Colors.white,
                                  ),
                                ),

                                // Date and location section
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        Card(
                          shadowColor: ColorManager.white,
                          color: ColorManager.white,
                          shape: RoundedRectangleBorder(
                            // side: BorderSide(color: ColorManager.fieldBackground, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Date Section
                              Padding(
                                padding: EdgeInsets.all(AppPadding.p12),
                                child: Row(
                                  children: [
                                    Card(
                                      margin: EdgeInsets.all(AppMargin.m4),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 4,
                                      color: Color(0xEDF4FDFF),
                                      child: Padding(
                                        padding: EdgeInsets.all(AppPadding.p8),
                                        child: Icon(
                                          Icons.calendar_today,
                                          color: Colors.blue,
                                          size: Constants.isTablet ? 34 : 30,
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: AppSize.s8),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    "تاريخ البدء: ", // النص الثابت "From:"
                                                style: TextStyle(
                                                  fontSize: FontResponsive.font(
                                                    context,
                                                    mobile: 18,
                                                    tablet: 22,
                                                  ),
                                                  fontWeight:
                                                      FontWeight.bold, // خط عريض
                                                  color: Colors.black, // اللون
                                                ),
                                              ),
                                              TextSpan(
                                                text: state
                                                    .conferenceModel
                                                    .startDate, // التاريخ أو النص الذي ترغب في عرضه
                                                style: TextStyle(
                                                  fontSize: FontResponsive.font(
                                                    context,
                                                    mobile: 18,
                                                    tablet: 22,
                                                  ),
                                                  fontWeight: FontWeight
                                                      .normal, // خط عادي
                                                  color: Colors
                                                      .black, // اللون المخصص
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    "تاريخ الانتهاء: ", // النص الثابت "To:"
                                                style: TextStyle(
                                                  fontSize: FontResponsive.font(
                                                    context,
                                                    mobile: 18,
                                                    tablet: 22,
                                                  ),
                                                  fontWeight:
                                                      FontWeight.bold, // خط عريض
                                                  color: Colors.black, // اللون
                                                ),
                                              ),
                                              TextSpan(
                                                text: state
                                                    .conferenceModel
                                                    .endDate, // التاريخ أو النص الذي ترغب في عرضه
                                                style: TextStyle(
                                                  fontSize: FontResponsive.font(
                                                    context,
                                                    mobile: 18,
                                                    tablet: 22,
                                                  ),
                                                  fontWeight: FontWeight
                                                      .normal, // خط عادي
                                                  color: Colors
                                                      .black, // اللون المخصص
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                color: ColorManager.fieldBackground,
                                height: 5,
                              ),
                              // Location Section
                              Padding(
                                padding: EdgeInsets.all(AppPadding.p12),
                                child: Row(
                                  children: [
                                    Card(
                                      margin: EdgeInsets.all(AppMargin.m4),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 4,

                                      color: Color(0xFFFDF5EB),
                                      child: Padding(
                                        padding: EdgeInsets.all(AppPadding.p8),
                                        child: Icon(
                                          Icons.location_on_outlined,
                                          color: Colors.orange,
                                          size: Constants.isTablet ? 35 : 30,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        state.conferenceModel.address,
                                        style: TextStyle(
                                          fontSize: FontResponsive.font(
                                            context,
                                            mobile: 16,
                                            tablet: 20,
                                          ),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4),
                        state.conferenceModel.surveys.isNotEmpty
                            ? Padding(
                                padding: EdgeInsets.all(AppPadding.p8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.sticky_note_2_outlined,
                                          size: 30,
                                        ),
                                        SizedBox(width: AppSize.s8),
                                        Text(
                                          "الاستبيانات",
                                          style: TextStyle(
                                            fontSize: FontResponsive.font(
                                              context,
                                              mobile: 18,
                                              tablet: 22,
                                            ),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Row(
                                    //   children: [
                                    //     Icon(Icons.description_outlined),
                                    //     SizedBox(width: 8),
                                    //     Text(
                                    //       "Surveys",
                                    //       style: TextStyle(
                                    //         fontSize: 18,
                                    //         fontWeight: FontWeight.bold,
                                    //         color: Colors.black87,
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    Row(
                                      children: [
                                        Text(
                                          state.conferenceModel.surveys.length
                                              .toString(),
                                        ),
                                        Text(" استبيان "),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(),
                        SizedBox(height: AppSize.s4),
                        state.conferenceModel.surveys.isNotEmpty
                            ? ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: state
                                    .conferenceModel
                                    .surveys
                                    .length, // Number of surveys
                                itemBuilder: (context, index) {
                                  return surveyCardActiveConference(
                                    state.conferenceModel.surveys[index]
                                        .toDomain(),
                                    state.conferenceModel.id,
                                  );
                                },
                              )
                            : buildEmptySurveysWidget(
                                context,
                                "لا توجد استبيانات",
                                "يبدو أن هذا المؤتمر لا يحتوي على استبيانات فهو مؤتمر لعرض معلومات المشاركين في المؤتمر , كما في الاسفل",
                              ),
                        SizedBox(height: AppSize.s4),
                      ],
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
              BlocBuilder<ActiveConferenceBloc, ActiveConferenceState>(
                buildWhen: (previous, current) =>
                    current is GetAllUserActiveConferenceState ||
                    current is GetAllUserActiveConferenceLoadingState ||
                    current is GetAllUserActiveConferenceErrorState,
                builder: (context, state) {
                  if (state is GetAllUserActiveConferenceErrorState) {
                    return errorFullScreen(context);
                  } else if (state is GetAllUserActiveConferenceLoadingState) {
                    return loadingFullScreen(context);
                  } else if (state is GetAllUserActiveConferenceState) {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(AppPadding.p8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.group_outlined, size: 30),
                                  const SizedBox(width: 8),
                                  Text(
                                    state.newTitle,
                                    style: TextStyle(
                                      fontSize: FontResponsive.font(
                                        context,
                                        mobile: 18,
                                        tablet: 22,
                                      ),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  // زر الفلتر
                                  PopupMenuButton<int>(
                                    icon: const Icon(
                                      Icons.filter_list,
                                      color: Colors.blueGrey,
                                    ),
                                    onSelected: (int value) {
                                      BlocProvider.of<ActiveConferenceBloc>(
                                        context,
                                      ).add(
                                        FilterDoctorEvent(value, state.users),
                                      );
                                      print("Selected Filter: $value");
                                    },
                                    itemBuilder: (BuildContext context) => [
                                      const PopupMenuItem(
                                        value: 0,
                                        child: Text("الكل"),
                                      ),
                                      const PopupMenuItem(
                                        value: 1,
                                        child: Text("المهمين - حضروا"),
                                      ),
                                      const PopupMenuItem(
                                        value: 2,
                                        child: Text("المهمين - لم يحضروا"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // القسم الأيسر (العدد)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      state.userFilter.length.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    const Text(
                                      " مشارك ",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppSize.s4),
                        Padding(
                          padding: EdgeInsets.all(AppPadding.p8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: SearchField(
                                  searchController: searchController,
                                  onPressed: (value) {
                                    BlocProvider.of<ActiveConferenceBloc>(
                                      context,
                                    ).add(
                                      SearchDoctorEvent(
                                        search: value,
                                        users: state.users,
                                        filterType: state.newTitle,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              InkWell(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.table_chart_outlined,
                                      color: const Color(0xFF16A34A),
                                      size: 24,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'تصدير Excel',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF16A34A),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.exelConference,
                                    arguments: state.newTitle,
                                  );
                                  BlocProvider.of<ExcelStBloc>(context).add(ExcelForConferenceEvent(state.userFilter));

                                },
                                ///////////////////////
                              ),
                              // القسم الأيسر (العدد)
                            ],
                          ),
                        ),
                        SizedBox(height: AppSize.s4),
                        state.userFilter.isNotEmpty
                            ? ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    state.userFilter.length, // Number of surveys
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: state.newTitle == "المهمين - غائبين"
                                        ? null
                                        : () {
                                            BlocProvider.of<ActiveConferenceBloc>(
                                              context,
                                            ).add(
                                              GetUserSurveyEvent(
                                                state.userFilter[index],
                                              ),
                                            );
                                            Navigator.pushNamed(
                                              context,
                                              Routes.viewUserSurvey,
                                            );
                                          },

                                    child: userListItem(
                                      state.userFilter[index],
                                      context,
                                    ),
                                  );
                                },
                              )
                            : buildEmptySurveysWidget(
                                context,
                                "لا يوجد مشاركين",
                                "يبدو أن هذا المؤتمر لا يحتوي على مشاركين بهذا الاسم",
                              ),
                      ],
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildEmptySurveysWidget(
  BuildContext context,
  String title,
  String supTitle,
) {
  return Center(
    child: Container(
      padding: EdgeInsets.all(25),
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // ليأخذ الحاوية حجم المحتوى فقط
        children: [
          // أيقونة جذابة مع خلفية دائرية خفيفة
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ColorManager.primaryShadow.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.assignment_late_outlined, // أيقونة استبيان مفقود
              size: 60,
              color: ColorManager.primary,
            ),
          ),
          SizedBox(height: 20),
          // العنوان الرئيسي
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorManager.primary,
              fontSize: FontResponsive.font(context, mobile: 22, tablet: 28),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          // نص توضيحي
          Text(
            supTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorManager.textSecondary,
              fontSize: FontResponsive.font(context, mobile: 14, tablet: 18),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    ),
  );
}
