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
  const ViewConferencePage({super.key, required this.conferenceId});
  final int conferenceId;

  @override
  State<ViewConferencePage> createState() => _ViewConferencePageState();
}

class _ViewConferencePageState extends State<ViewConferencePage> {
  @override
  void initState() {
    BlocProvider.of<ConferenceBloc>(context).add(GetConferenceByIdEvent(widget.conferenceId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConferenceBloc, ConferenceState>(
      buildWhen: (previous, current) =>
      current is GetConferenceByIdState ||
          current is GetConferenceByIdLoadingState ||
          current is GetConferenceByIdErrorState,
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
                        ColorManager.splash1,
                        ColorManager.splash2,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          conference!.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Conference Description
                        Text(
                          conference.description,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // 🔥 قسم عرض الاختصاصات المتعددة (المضاف والمعدل حديثاً بشكل جميل)
                        if ( conference.spec.isNotEmpty) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.bookmarks_outlined,
                                color: Colors.white70,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                "الاختصاصات: ",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6.0, // المسافة الأفقية بين البطاقات
                            runSpacing: 6.0, // المسافة الرأسية عند النزول لسطر جديد
                            children: conference.spec.map((specItem) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2), // خلفية بيضاء شفافة لتناسب التدرج
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  specItem.title??"",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ] else ...[
                          // في حال عدم وجود اختصاصات
                          const Text(
                            "الاختصاص: غير محدد",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],

                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              Routes.updateConference,
                              arguments: conference,
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(Icons.edit, color: ColorManager.white),
                              const SizedBox(width: 10),
                              Text(
                                "تعديل",
                                style: TextStyle(color: ColorManager.white),
                              )
                            ],
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
                  shape: RoundedRectangleBorder(
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
                              color: const Color(0xEDF4FDFF),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.calendar_today,
                                  color: Colors.blue,
                                  size: 30,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "تاريخ البدء: ",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: conference.startDate,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "تاريخ الانتهاء: ",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: conference.endDate,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
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
                              color: const Color(0xFFFDF5EB),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
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
                                style: const TextStyle(
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
                const SizedBox(height: 4),
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
                              color: const Color(0xED6ED9F1),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
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
                      Row(
                        children: [
                          Text(conference.surveys.length.toString()),
                          const Text(" استبيان "),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                conference.surveys.isNotEmpty
                    ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: conference.surveys.length,
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
                            Color(int.parse(conference.surveys[index].color)),
                            conference.surveys[index].color,
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
              : const SizedBox(),
        );
      },
    );
  }
}