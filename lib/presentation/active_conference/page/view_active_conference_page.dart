import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/app/constants.dart';
import 'package:formify/data/mapper/mapper.dart';
import 'package:formify/presentation/active_conference/bloc/active_conference_bloc.dart';
import 'package:formify/presentation/active_conference/widget/view_all_user.dart';
import 'package:formify/presentation/excel/bloc/excel_st_bloc.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/responsive/font_responseve.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/resources/theme_bloc/theme_bloc.dart';
import 'package:formify/presentation/resources/values_manager.dart';
import 'package:formify/presentation/survey/bloc/survey_bloc.dart';
import 'package:formify/presentation/survey/widget/list_survey_widget.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';

class ViewActiveConferencePage extends StatefulWidget {
  const ViewActiveConferencePage({super.key, required this.conferenceId});
  final int conferenceId;

  @override
  State<ViewActiveConferencePage> createState() =>
      _ViewActiveConferencePageState();
}

class _ViewActiveConferencePageState extends State<ViewActiveConferencePage> {
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
        padding: EdgeInsets.symmetric(
          vertical: AppPadding.p16,
          horizontal: AppPadding.p18,
        ),
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
                        // إضافة أي محتوى هنا داخل الـ Container
                        padding: EdgeInsets.all(AppPadding.p16),
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
                      InkWell(
                        child: Container(
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
                          // إضافة أي محتوى هنا داخل الـ Container
                          padding: EdgeInsets.all(AppPadding.p16),
                          child: Padding(
                            padding: EdgeInsets.all(AppPadding.p16),
                            child: Row(
                              children: [
                                Text(
                                  "عرض احصائيات المؤتمر",
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
                                SizedBox(width: 20),
                                Icon(
                                  Icons.arrow_forward,
                                  color: ColorManager.white,
                                  size: 30,
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, Routes.exelConference);
                          BlocProvider.of<ExcelStBloc>(context).add(
                            UsersAnswersStatisticsEvent(
                              state.conferenceModel.surveys[0].id,
                            ),
                          );
                        },
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
                      Padding(
                        padding: EdgeInsets.all(AppPadding.p8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.sticky_note_2_outlined, size: 30),
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
                      ),
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
                                return surveyListWidget(
                                  state.conferenceModel.surveys[index]
                                      .toDomain(),
                                  () {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.viewSurvey,
                                    );
                                    BlocProvider.of<ThemeBloc>(context).add(
                                      ChangeThemeColorEvent(
                                        Color(
                                          int.parse(
                                            state
                                                .conferenceModel
                                                .surveys[index]
                                                .color,
                                          ),
                                        ),
                                        state
                                            .conferenceModel
                                            .surveys[index]
                                            .color,
                                      ),
                                    );
                                    BlocProvider.of<SurveyBloc>(context).add(
                                      ViewSurveyByIdEvent(
                                        state.conferenceModel.surveys[index].id,
                                      ),
                                    );
                                  },
                                );
                              },
                            )
                          : emptyFullScreen(context),
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
                  current is GetAllUserActiveConferenceErrorState ||
                  current is GetAllUserActiveEmptyConferenceState,
              builder: (context, state) {
                if (state is GetAllUserActiveConferenceErrorState) {
                  return errorFullScreen(context);
                } else if (state is GetAllUserActiveConferenceLoadingState) {
                  return loadingFullScreen(context);
                } else if (state is GetAllUserActiveEmptyConferenceState) {
                  return emptyFullScreen(context);
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
                                SizedBox(width: 8),
                                Text(
                                  "المشاركون",
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
                            Row(
                              children: [
                                Text(state.users.length.toString()),
                                Text(" مشارك "),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSize.s4),
                      state.users.isNotEmpty
                          ? ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  state.users.length, // Number of surveys
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    BlocProvider.of<ActiveConferenceBloc>(
                                      context,
                                    ).add(
                                      GetUserSurveyEvent(state.users[index]),
                                    );
                                    Navigator.pushNamed(
                                      context,
                                      Routes.viewUserSurvey,
                                    );
                                  },

                                  child: userListItem(
                                    state.users[index],
                                    context,
                                  ),
                                );
                              },
                            )
                          : emptyFullScreen(context),
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
    );
  }
}
