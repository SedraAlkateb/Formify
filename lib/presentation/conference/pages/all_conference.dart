import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/presentation/conference/bloc/conference_bloc.dart';
import 'package:formify/presentation/home/widget/conference_ended_widget.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';

class AllConferencePage extends StatelessWidget {
  const AllConferencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ended Conference",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
        ),
      ),
      body: BlocConsumer<ConferenceBloc, ConferenceState>(
        buildWhen: (previous, current) =>
        current is GetAllConferenceState ||
            current is GetAllConferenceLoadingState||
            current is GetAllConferenceErrorState
        ||current is GetAllEmptyConferenceState
        ,
        listener: (context, state) {
          if (state is GetConferenceByIdState) {
            Navigator.pushNamed(context, Routes.viewConference);
          }
          },
        builder: (context, state) {

          if (state is GetAllConferenceLoadingState) {
            return loadingFullScreen(context);
          } else if (state is GetAllConferenceErrorState) {
            return errorFullScreen(context);
          } else if (state is GetAllConferenceState) {
            return ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: BlocProvider.of<ConferenceBloc>(
                context,
              ).allNotActiveConference.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => BlocProvider.of<ConferenceBloc>(
                    context,
                  ).add(GetConferenceByIdEvent(BlocProvider.of<ConferenceBloc>(
                    context,
                  ).allNotActiveConference[index])),
                  child: ConferenceEndedWidget(
                    index: index,
                    allConference: BlocProvider.of<ConferenceBloc>(
                      context,
                    ).allNotActiveConference,
                  ),
                );
              },
            );
          } else if (state is GetAllEmptyConferenceState) {
            return emptyFullScreen(context);
          } else
            return Container(
              height: 100,
              width: 100,
              color: ColorManager.black,
            );
        },
      ),
    );
  }
}
