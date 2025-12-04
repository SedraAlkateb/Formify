import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formify/presentation/home/widget/button_type.dart';
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
      appBar: AppBar(),
      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                  color: ColorManager.textHint,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                  height: 500,
                  child: CustomGridPage()),
            ],
          ),
        ),
      ),
    );
  }
}
