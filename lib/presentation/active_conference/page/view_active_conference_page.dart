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
    final bloc = BlocProvider.of<ActiveConferenceBloc>(context);
    bloc.add(GetActiveConferenceByIdEvent(widget.conferenceId));
    bloc.add(GetAllUserByActiveConferenceEvent(widget.conferenceId));
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
        elevation: 0,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ==================== القسم الأول: تفاصيل المؤتمر والاستبيانات ====================
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                child: BlocBuilder<ActiveConferenceBloc, ActiveConferenceState>(
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
                      return _buildConferenceHeader(context, state);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),

            // ==================== القسم الثاني: فلاتر وبحث المستخدمين ====================
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: BlocBuilder<ActiveConferenceBloc, ActiveConferenceState>(
                  buildWhen: (previous, current) =>
                  current is GetAllUserActiveConferenceState ||
                      current is GetAllUserActiveConferenceLoadingState ||
                      current is GetAllUserActiveConferenceErrorState,
                  builder: (context, state) {
                    if (state is GetAllUserActiveConferenceState) {
                      return _buildUserFiltersAndSearch(context, state);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),

            // ==================== القسم الثالث: قائمة المستخدمين (Lazy Loading) ====================
            BlocBuilder<ActiveConferenceBloc, ActiveConferenceState>(
              buildWhen: (previous, current) =>
              current is GetAllUserActiveConferenceState ||
                  current is GetAllUserActiveConferenceLoadingState ||
                  current is GetAllUserActiveConferenceErrorState,
              builder: (context, state) {
                if (state is GetAllUserActiveConferenceLoadingState) {
                  return SliverToBoxAdapter(child: loadingFullScreen(context));
                } else if (state is GetAllUserActiveConferenceErrorState) {
                  return SliverToBoxAdapter(child: errorFullScreen(context));
                } else if (state is GetAllUserActiveConferenceState) {
                  if (state.userFilter.isEmpty) {
                    return SliverToBoxAdapter(
                      child: buildEmptySurveysWidget(
                        context,
                        "لا يوجد مشاركين",
                        "يبدو أن هذا المؤتمر لا يحتوي على مشاركين بهذا الاسم",
                      ),
                    );
                  }

                  // هنا السرعة! يتم بناء العناصر الظاهرة على الشاشة فقط مهما كان العدد
                  return SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final user = state.userFilter[index];
                          return InkWell(
                            onTap: state.newTitle == "المهمين - غائبين"
                                ? null
                                : () {
                              BlocProvider.of<ActiveConferenceBloc>(context)
                                  .add(GetUserSurveyEvent(user));
                              Navigator.pushNamed(context, Routes.viewUserSurvey);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.h),
                              child: userListItem(user, context),
                            ),
                          );
                        },
                        childCount: state.userFilter.length,
                      ),
                    ),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
          ],
        ),
      ),
    );
  }

  // ميثود فرعية لبناء هيدر المؤتمر لتنظيف كود الـ build الرئيسي
  Widget _buildConferenceHeader(BuildContext context, GetActiveConferenceByIdState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: AppPadding.p16, horizontal: AppPadding.p18),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [ColorManager.splash1, ColorManager.splash2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
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
                    fontSize: FontResponsive.font(context, mobile: 20, tablet: 24),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  state.conferenceModel.description,
                  style: TextStyle(
                    fontSize: FontResponsive.font(context, mobile: 16, tablet: 20),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Card(
          shadowColor: ColorManager.white,
          color: ColorManager.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(AppPadding.p12),
                child: Row(
                  children: [
                    Card(
                      margin: EdgeInsets.all(AppMargin.m4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      color: const Color(0xEDF4FDFF),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "تاريخ البدء: ",
                                style: TextStyle(
                                  fontSize: FontResponsive.font(context, mobile: 18, tablet: 22),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: state.conferenceModel.startDate,
                                style: TextStyle(
                                  fontSize: FontResponsive.font(context, mobile: 18, tablet: 22),
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "تاريخ الانتهاء: ",
                                style: TextStyle(
                                  fontSize: FontResponsive.font(context, mobile: 18, tablet: 22),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: state.conferenceModel.endDate,
                                style: TextStyle(
                                  fontSize: FontResponsive.font(context, mobile: 18, tablet: 22),
                                  color: Colors.black,
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
              Container(color: ColorManager.fieldBackground, height: 5),
              Padding(
                padding: EdgeInsets.all(AppPadding.p12),
                child: Row(
                  children: [
                    Card(
                      margin: EdgeInsets.all(AppMargin.m4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      color: const Color(0xFFFDF5EB),
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
                          fontSize: FontResponsive.font(context, mobile: 16, tablet: 20),
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
        const SizedBox(height: 12),
        if (state.conferenceModel.surveys.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.all(AppPadding.p8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.sticky_note_2_outlined, size: 30),
                    SizedBox(width: AppSize.s8),
                    Text(
                      "الاستبيانات",
                      style: TextStyle(
                        fontSize: FontResponsive.font(context, mobile: 18, tablet: 22),
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Text("${state.conferenceModel.surveys.length} استبيان"),
              ],
            ),
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: state.conferenceModel.surveys.length,
            itemBuilder: (context, index) {
              return surveyCardActiveConference(
                state.conferenceModel.surveys[index].toDomain(),
                state.conferenceModel.id,
              );
            },
          ),
        ] else
          buildEmptySurveysWidget(
            context,
            "لا توجد استبيانات",
            "يبدو أن هذا المؤتمر لا يحتوي على استبيانات فهو مؤتمر لعرض معلومات المشاركين في المؤتمر , كما في الاسفل",
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  // ميثود فرعية لبناء الفلاتر والبحث لتسهيل القراءة وتجنب الـ Rebuild الكلي
  Widget _buildUserFiltersAndSearch(BuildContext context, GetAllUserActiveConferenceState state) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(AppPadding.p8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.group_outlined, size: 30),
                  const SizedBox(width: 8),
                  Text(
                    state.newTitle,
                    style: TextStyle(
                      fontSize: FontResponsive.font(context, mobile: 18, tablet: 22),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 4),
                  PopupMenuButton<int>(
                    icon: const Icon(Icons.filter_list, color: Colors.blueGrey),
                    onSelected: (int value) {
                      BlocProvider.of<ActiveConferenceBloc>(context).add(
                        FilterDoctorEvent(value, state.users),
                      );
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(value: 0, child: Text("الكل")),
                      const PopupMenuItem(value: 1, child: Text("المهمين - حضروا")),
                      const PopupMenuItem(value: 2, child: Text("المهمين - لم يحضروا")),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Text(
                      state.userFilter.length.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    const Text(" مشارك ", style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(AppPadding.p8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SearchField(
                  searchController: searchController,
                  onPressed: (value) {
                    BlocProvider.of<ActiveConferenceBloc>(context).add(
                      SearchDoctorEvent(
                        search: value,
                        users: state.users,
                        filterType: state.newTitle,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, Routes.exelConference, arguments: state.newTitle);
                  BlocProvider.of<ExcelStBloc>(context).add(ExcelForConferenceEvent(state.userFilter));
                },
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.table_chart_outlined, color: Color(0xFF16A34A), size: 24),
                    SizedBox(height: 4),
                    Text(
                      'تصدير Excel',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF16A34A)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
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
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.all(20),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ColorManager.primaryShadow.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.assignment_late_outlined,
              size: 60,
              color: ColorManager.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorManager.primary,
              fontSize: FontResponsive.font(context, mobile: 22, tablet: 28),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            supTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: FontResponsive.font(context, mobile: 14, tablet: 18),
            ),
          ),
        ],
      ),
    ),
  );
}