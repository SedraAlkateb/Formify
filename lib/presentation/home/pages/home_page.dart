import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/presentation/conference/bloc/conference_bloc.dart';
import 'package:formify/presentation/home/widget/conference_ended_widget.dart';
import 'package:formify/presentation/home/widget/grid_icon.dart';
import 'package:formify/presentation/home/widget/isMorning.dart';
import 'package:formify/presentation/resources/color_manager.dart';
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
              SizedBox(height: 500,
                  child: CustomGridPage()),
              Text(
                "Ended Conference",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
              ),
              BlocBuilder<ConferenceBloc, ConferenceState>(
                builder: (context, state) {
                  if(state is GetAllConferenceLoadingState){
                    return loadingFullScreen(context);
                  }else if (state is GetAllConferenceErrorState){
                    return errorFullScreen(context);

                  }else if(state is GetAllConferenceState){
                    return ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: BlocProvider.of<ConferenceBloc>(context).allNotActiveConference.length,
                      separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return ConferenceEndedWidget(index: index,allConference: BlocProvider.of<ConferenceBloc>(context).allNotActiveConference,);
                      },
                    );
                  }else if(state is GetAllEmptyConferenceState){
                    return emptyFullScreen(context);
                  }else
                   return SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
