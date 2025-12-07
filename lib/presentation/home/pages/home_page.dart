import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:formify/presentation/home/widget/conference_ended_widget.dart';
import 'package:formify/presentation/home/widget/grid_icon.dart';
import 'package:formify/presentation/home/widget/isMorning.dart';
import 'package:formify/presentation/resources/color_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

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
              SizedBox(height: 500, child: CustomGridPage()),
              Text(
                "Ended Conference",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
              ),
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 5,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return ConferenceEndedWidget(index: index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
