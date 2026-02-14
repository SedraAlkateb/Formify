import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/resources/theme_bloc/theme_bloc.dart';
import 'package:formify/presentation/survey/bloc/survey_bloc.dart';
import 'package:formify/presentation/survey/widget/list_survey_widget.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';

class ViewAllSurveyPage extends StatefulWidget {
  const ViewAllSurveyPage({super.key});

  @override
  State<ViewAllSurveyPage> createState() => _ViewAllSurveyPageState();
}

class _ViewAllSurveyPageState extends State<ViewAllSurveyPage> {
  @override
  void initState() {
    BlocProvider.of<SurveyBloc>(context).add(GetAllSurveyEvent());
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
          "كل الاستبيانات",
          style: TextStyle(color: ColorManager.black),
        ),
        backgroundColor: ColorManager.white,
      ),

      body: BlocBuilder<SurveyBloc, SurveyState>(
        buildWhen: (previous, current) =>
            current is GetAllSurveyLoadingState ||
            current is GetAllEmptySurveyState ||
            current is GetAllSurveyErrorState ||
            current is GetAllSurveyState,
        builder: (context, state) {
          if (state is GetAllSurveyLoadingState) {
            return loadingFullScreen(context);
          } else if (state is GetAllEmptySurveyState) {
            return emptyFullScreen(context);
          } else if (state is GetAllSurveyErrorState) {
            return errorFullScreen(
              context,
              func: () =>
                  BlocProvider.of<SurveyBloc>(context).add(GetAllSurveyEvent()),
            );
          } else if (state is GetAllSurveyState) {
            List<MainSurveyModel> surveys = state.surveys;
            return Padding(
              padding: const EdgeInsets.all(12),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: surveys.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      BlocProvider.of<ThemeBloc>(context).add(
                        ChangeThemeColorEvent(
                          Color(int.parse(surveys[index].color)),
                          surveys[index].color,
                        ),
                      );
                      Navigator.pushNamed(context, Routes.viewSurvey);
                      BlocProvider.of<SurveyBloc>(
                        context,
                      ).add(ViewSurveyByIdEvent(surveys[index].id));
                    },
                    child: surveyListWidget(surveys[index]),
                  );
                },
              ),
            );
          } else
            return SizedBox();
        },
      ),
    );
  }
}
