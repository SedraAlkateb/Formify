import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/data/mapper/mapper.dart';
import 'package:formify/presentation/active_conference/bloc/active_conference_bloc.dart';
import 'package:formify/presentation/active_conference/widget/view_all_user.dart';
import 'package:formify/presentation/conference/bloc/conference_bloc.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/resources/theme_bloc/theme_bloc.dart';
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
          "Conference Participants",
          style: TextStyle(color: ColorManager.black),
        ),
        backgroundColor: ColorManager.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
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
                              Color(0xFF4C4EB9), // اللون الأول (أزرق)
                              Color(0xFF7A7EF4), // اللون الثاني (أزرق فاتح)
                              Color(0xFFa18cd1),
                            ],
                            begin: Alignment
                                .topLeft, // البداية من الزاوية العليا اليسرى
                            end: Alignment
                                .bottomRight, // النهاية عند الزاوية السفلى اليمنى
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        // إضافة أي محتوى هنا داخل الـ Container
                        padding: const EdgeInsets.all(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.conferenceModel.name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              // ActiveConference Description
                              Text(
                                state.conferenceModel.description,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 20),

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
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Card(
                                    margin: const EdgeInsets.all(4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 4,
                                    color: Color(0xEDF4FDFF),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.calendar_today,
                                        color: Colors.blue,
                                        size: 30,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 8),
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
                                                  "From: ", // النص الثابت "From:"
                                              style: TextStyle(
                                                fontSize: 18, // حجم الخط
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
                                                fontSize: 18, // حجم الخط
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
                                              text: "To: ", // النص الثابت "To:"
                                              style: TextStyle(
                                                fontSize: 18, // حجم الخط
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
                                                fontSize: 18, // حجم الخط
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
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Card(
                                    margin: const EdgeInsets.all(4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 4,

                                    color: Color(0xFFFDF5EB),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.orange,
                                        size: 30,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      state.conferenceModel.address,
                                      style: TextStyle(
                                        fontSize: 16,
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
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                BlocProvider.of<ActiveConferenceBloc>(
                                  context,
                                ).add(
                                  GetAllSurveyByActiveConferenceEvent(
                                    state.conferenceModel.id,
                                  ),
                                );

                                Navigator.pushNamed(
                                  context,
                                  Routes.conferenceSurveyById,
                                  arguments: {
                                    "conferenceId": state.conferenceModel.id,
                                  },
                                );
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.sticky_note_2_outlined, size: 30),
                                  SizedBox(width: 8),
                                  Text(
                                    "Surveys",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
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
                                Text(" surveys "),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4),
                      state.conferenceModel.surveys.isNotEmpty
                          ? ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: state
                                  .conferenceModel
                                  .surveys
                                  .length, // Number of surveys
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
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
                                  child: surveyListWidget(
                                    state.conferenceModel.surveys[index]
                                        .toDomain(),
                                  ),
                                );
                              },
                            )
                          : emptyFullScreen(context),
                      SizedBox(height: 4),
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
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                BlocProvider.of<ActiveConferenceBloc>(
                                  context,
                                ).add(
                                  GetAllSurveyByActiveConferenceEvent(
                                    widget.conferenceId,
                                  ),
                                );

                                Navigator.pushNamed(
                                  context,
                                  Routes.conferenceSurveyById,
                                  arguments: {
                                    "conferenceId": widget.conferenceId,
                                  },
                                );
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.group_outlined, size: 30),
                                  SizedBox(width: 8),
                                  Text(
                                    "Participants",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
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
                                Text(state.users.length.toString()),
                                Text(" Participants "),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4),
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
                                      GetUserSurveyEvent(

                                          state.users[index]),
                                    );
                                    Navigator.pushNamed(
                                      context,
                                      Routes.viewUserSurvey,
                                    );
                                  },
                                  child: allUserWidget(state.users[index]),
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
