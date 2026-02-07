import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/data/mapper/mapper.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/active_conference/bloc/active_conference_bloc.dart';
import 'package:formify/presentation/active_conference/widget/view_all_user.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/resources/theme_bloc/theme_bloc.dart';
import 'package:formify/presentation/survey/bloc/survey_bloc.dart';
import 'package:formify/presentation/survey/widget/list_survey_widget.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';

class ViewUserSurveyPage extends StatelessWidget {
  const ViewUserSurveyPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveConferenceBloc, ActiveConferenceState>(
      builder: (context, state) {
        if (state is GetUserSurveyState) {
          return Scaffold(
            backgroundColor: ColorManager.background,
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios_new, color: ColorManager.black),
              ),
              title: Text(
                "Participant Surveys",
                style: TextStyle(color: ColorManager.black),
              ),
              backgroundColor: ColorManager.white,
            ),

            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  userWidget(state.userModel),
                  Column(
                    children: [
                      SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
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
                         Row(
                              children: [
                                Text(
                                  state.surveys.length
                                      .toString(),
                                ),
                                Text(" surveys "),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4),
                      state.surveys.isNotEmpty
                          ? ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: state

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

                                                .surveys[index]
                                                .color,
                                          ),
                                        ),
                                        state

                                            .surveys[index]
                                            .color,
                                      ),
                                    );
                                    BlocProvider.of<SurveyBloc>(context).add(
                                      ViewSurveyByIdEvent(
                                        state.surveys[index].id,
                                      ),
                                    );
                                  },
                                  child: surveyListWidget(
                                    state.surveys[index]
                                        .toDomain(),
                                  ),
                                );
                              },
                            )
                          : emptyFullScreen(context),
                      SizedBox(height: 4),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}
