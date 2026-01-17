import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/presentation/conference/bloc/conference_bloc.dart';
import 'package:formify/presentation/home/widget/conference_ended_widget.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';

class AllActiveConferencePage extends StatelessWidget {
  const AllActiveConferencePage({super.key});

  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Active Conference",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 26),
        ),
      ),
      body: BlocConsumer<ConferenceBloc, ConferenceState>(
        listener: (context, state) {
          if (state is GetConferenceByIdState) {
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
              itemCount: BlocProvider.of<ConferenceBloc>(
                context,
              ).allActiveConference.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => BlocProvider.of<ConferenceBloc>(
                    context,
                  ).add(GetConferenceByIdEvent(BlocProvider.of<ConferenceBloc>(
                    context,
                  ).allActiveConference[index])),
                  child: ConferenceEndedWidget(
                    index: index,
                    allConference: BlocProvider.of<ConferenceBloc>(
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
