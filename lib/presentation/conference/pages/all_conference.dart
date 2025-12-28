import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/presentation/conference/bloc/conference_bloc.dart';
import 'package:formify/presentation/home/widget/conference_ended_widget.dart';

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
      body:   Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          physics: AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 30,
          separatorBuilder: (context, index) =>
          const SizedBox(height: 10),
          itemBuilder: (context, index) {
            return ConferenceEndedWidget(index: index);
          },
        ),
      ),
    );
  }
}
