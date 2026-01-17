import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/presentation/active_conference/bloc/active_conference_bloc.dart';
import 'package:formify/presentation/conference/bloc/conference_bloc.dart';
import 'package:formify/presentation/home/widget/conference_ended_widget.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';

class AllActiveConferencePage extends StatelessWidget {
  const AllActiveConferencePage({super.key});

  @override

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
          "Active Conference",
          style: TextStyle(color: ColorManager.black),
        ),
        backgroundColor: ColorManager.white,
      ),

      body: BlocConsumer<ActiveConferenceBloc, ActiveConferenceState>(
        listener: (context, state) {
          if (state is GetActiveConferenceByIdState) {
            Navigator.pushNamed(context, Routes.viewConference);
          }

        },
        builder: (context, state) {

          if (state is GetAllActiveConferenceLoadingState) {
            return loadingFullScreen(context);
          } else if (state is GetAllActiveConferenceErrorState) {
            return errorFullScreen(context);
          } else if (state is GetAllActiveConferenceState) {
            return ListView.separated(
              shrinkWrap: true,
              itemCount: BlocProvider.of<ActiveConferenceBloc>(
                context,
              ).allActiveConference.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => BlocProvider.of<ActiveConferenceBloc>(
                    context,
                  ).add(GetActiveConferenceByIdEvent(BlocProvider.of<ActiveConferenceBloc>(
                    context,
                  ).allActiveConference[index])),
                  child: ConferenceEndedWidget(
                    index: index,
                    allConference: BlocProvider.of<ActiveConferenceBloc>(
                      context,
                    ).allActiveConference,
                  ),
                );
              },
            );
          } else if (state is GetAllActiveEmptyConferenceState) {
            return emptyFullScreen(context);
          } else
            return SizedBox();
        },
      ),
    );
  }
}
