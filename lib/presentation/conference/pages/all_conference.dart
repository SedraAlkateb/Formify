import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/presentation/conference/bloc/conference_bloc.dart';
import 'package:formify/presentation/home/widget/conference_ended_widget.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';

class AllConferencePage extends StatefulWidget {
  const AllConferencePage({super.key});

  @override
  State<AllConferencePage> createState() => _AllConferencePageState();
}

class _AllConferencePageState extends State<AllConferencePage> {
  @override
  void initState() {
   BlocProvider.of<ConferenceBloc>(context).add(GetAllActiveConferenceEvent());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title:  Text(
        "Ended Conference",
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
      ),),
      body:
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
              itemCount: BlocProvider.of<ConferenceBloc>(context).allActiveConference.length,
              separatorBuilder: (context, index) =>
              const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return ConferenceEndedWidget(index: index,allConference:  BlocProvider.of<ConferenceBloc>(context).allActiveConference,);
              },
            );
          }else if(state is GetAllEmptyConferenceState){
            return emptyFullScreen(context);
          }else
            return SizedBox();
        },
      ),


    );
  }
}
