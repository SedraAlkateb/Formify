import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/presentation/conference/bloc/conference_bloc.dart';
import 'package:formify/presentation/home/widget/conference_ended_widget.dart';
import 'package:formify/presentation/home/widget/grid_icon.dart';
import 'package:formify/presentation/home/widget/isMorning.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getGreeting(),
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
              ),
              Text(
                "Domina",
                style: TextStyle(
                  color: ColorManager.secondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                  height: 500,
                  child: CustomGridPage()
              ),
              Text(
                "Ended Conference",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
              ),
              BlocBuilder<ConferenceBloc, ConferenceState>(
                buildWhen: (previous, current) =>
                current is GetAllConferenceState ||
                    current is GetAllConferenceLoadingState||
                    current is GetAllConferenceErrorState
                    ||current is GetAllEmptyConferenceState,
                builder: (context, state) {
                  if (state is GetAllConferenceLoadingState) {
                    return loadingFullScreen(context);
                  }
                  else if (state is GetAllConferenceErrorState) {
                    return errorFullScreen(context,func:()=>BlocProvider.of<ConferenceBloc>(context).add(GetAllNotActiveConferenceEvent()));
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
                          onTap: () {
                            BlocProvider.of<ConferenceBloc>(
                              context,
                            ).add(GetConferenceByIdEvent(BlocProvider.of<ConferenceBloc>(
                              context,
                            ).allNotActiveConference[index]));
                            Navigator.pushNamed(context, Routes.viewConference);
                          },
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
            ],
          ),
        ),
      ),
    );
  }
}
