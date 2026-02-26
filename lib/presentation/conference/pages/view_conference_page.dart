import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/data/mapper/mapper.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/conference/bloc/conference_bloc.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/resources/theme_bloc/theme_bloc.dart';
import 'package:formify/presentation/survey/bloc/survey_bloc.dart';
import 'package:formify/presentation/survey/widget/list_survey_widget.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';

class ViewConferencePage extends StatefulWidget {
  const ViewConferencePage({super.key,required this.conferenceId});
final int conferenceId;

  @override
  State<ViewConferencePage> createState() => _ViewConferencePageState();
}

class _ViewConferencePageState extends State<ViewConferencePage> {
  @override
  void initState() {
    BlocProvider.of<ConferenceBloc>(
      context,
    ).add(GetConferenceByIdEvent(widget.conferenceId));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConferenceBloc, ConferenceState>(
      buildWhen: (previous, current) => current is GetConferenceByIdState
          ||current is GetConferenceByIdLoadingState || current is GetConferenceByIdErrorState,
      builder: (context, state) {
        final GetAllConferenceByIdModel? conference =
            state is GetConferenceByIdState ? state.conferenceModel : null;
        return Scaffold(
          backgroundColor: ColorManager.background,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios_new, color: ColorManager.black),
            ),
            title: Text(
              "تفاصيل المؤتمر",
              style: TextStyle(color: ColorManager.black),
            ),
            backgroundColor: ColorManager.white,
          ),

          body: state is GetConferenceByIdState
              ? SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Conference header section (Card with Conference Info)
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF4C4EB9), // اللون الأول (أزرق)
                              Color(0xFF7A7EF4), // اللون الثاني (أزرق فاتح)
                              Color(0xFFA4A6E1),
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
                                conference!.name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Conference Description
                              Text(
                                conference.description,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.updateConference,
                                    arguments: conference.id,
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [Icon(Icons.edit,color: ColorManager.white,),
                                    SizedBox(width: 10,)
                                    , Text("تعديل",style: TextStyle(
                                      color: ColorManager.white
                                    ),)],
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
                                                  "تاريخ البدء: ", // النص الثابت "From:"
                                              style: TextStyle(
                                                fontSize: 18, // حجم الخط
                                                fontWeight:
                                                    FontWeight.bold, // خط عريض
                                                color: Colors.black, // اللون
                                              ),
                                            ),
                                            TextSpan(
                                              text: conference
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
                                              text: "تاريخ الانتهاء: ", // النص الثابت "To:"
                                              style: TextStyle(
                                                fontSize: 18, // حجم الخط
                                                fontWeight:
                                                    FontWeight.bold, // خط عريض
                                                color: Colors.black, // اللون
                                              ),
                                            ),
                                            TextSpan(
                                              text: conference
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
                                      conference.address,
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
                                BlocProvider.of<ConferenceBloc>(context).add(
                                  GetAllSurveyByConferenceEvent(conference.id),
                                );

                                Navigator.pushNamed(
                                  context,
                                  Routes.conferenceSurveyById,
                                  arguments: {
                                    "conferenceId": conference.id,

                                  },
                                );
                              },
                              child: Row(
                                children: [
                                  Card(
                                    margin: const EdgeInsets.all(4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 4,
                                    color: Color(0xED6ED9F1),

                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "اضافة استبيانات جديدة",
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
                                Text(conference.surveys.length.toString()),
                                Text(" استبيان "),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4),
                      conference.surveys.isNotEmpty
                          ? ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: conference
                                  .surveys
                                  .length, // Number of surveys
                              itemBuilder: (context, index) {
                                return surveyListWidget(
                                  conference.surveys[index].toDomain(),
                                      () {
                                    Navigator.pushNamed(

                                      context,
                                      Routes.viewSurvey,
                                    );
                                    BlocProvider.of<ThemeBloc>(context).add(
                                      ChangeThemeColorEvent(
                                        Color(int.parse(conference
                                            .surveys[index].color)),
                                        conference
                                            .surveys[index].color,
                                      ),
                                    );
                                    BlocProvider.of<SurveyBloc>(context).add(
                                      ViewSurveyByIdEvent(
                                        conference.surveys[index].id,
                                      ),
                                    );

                                  },
                                );
                              },
                            )
                          : emptyFullScreen(context),
                    ],
                  ),
                )
              : state is GetConferenceByIdErrorState
              ? errorFullScreen(context)
              : state is GetConferenceByIdLoadingState
              ? const Center(child: CircularProgressIndicator())
              : SizedBox(),
        );
      },
    );
  }
}
