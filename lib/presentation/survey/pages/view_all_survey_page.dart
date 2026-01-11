import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
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
      appBar: AppBar(
        title: Text(
          "Active Conference",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 26),
        ),
      ),
      body: BlocBuilder<SurveyBloc, SurveyState>(
        builder: (context, state) {

          if (state is GetAllSurveyLoadingState) {
            return loadingFullScreen(context);
          } else if (state is GetAllSurveyErrorState) {
            return errorFullScreen(context);
          } else if (state is GetAllSurveyState) {
            return ListView.separated(
              shrinkWrap: true,
              itemCount: state.surveys.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.viewSurvey);
                  },
                  child: surveyListWidget(
                 state.surveys[index]

                  ),
                );
              },
            );
          } else if (state is GetAllEmptySurveyState) {
            return emptyFullScreen(context);
          } else
            return SizedBox();
        },
      ),
    );
  }
}
