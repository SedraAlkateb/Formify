import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/resources/theme_bloc/theme_bloc.dart';
import 'package:formify/presentation/survey/bloc/survey_bloc.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';

class CreateSurveyPage extends StatelessWidget {
   CreateSurveyPage({super.key});
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    titleController.text=BlocProvider.of<SurveyBloc>(context).surveyModel.title;
    descriptionController.text=BlocProvider.of<SurveyBloc>(context).surveyModel.description;

    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Dynamic FormBuilder Example'),
        backgroundColor: colors.primary,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorManager.border),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Survey Title", // 🔹 عنوان فوق الحقل
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        onChanged:(value) => BlocProvider.of<SurveyBloc>(context).surveyModel.title= value,
                        controller: titleController,
                        decoration: InputDecoration(
                          hintText: "entre survey title",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Survey Description", // 🔹 عنوان فوق الحقل
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        onChanged:(value) => BlocProvider.of<SurveyBloc>(context).surveyModel.description= value,
                        controller: descriptionController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: "entre survey description",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorManager.border),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "اختر لون التطبيق",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 12),

                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          /// 🔥 مجموعة ألوان أساسية
                          buildColorOption(Colors.blue,context),
                          buildColorOption(Colors.red,context),
                          buildColorOption(Colors.green,context),
                          buildColorOption(Colors.orange,context),
                          buildColorOption(Colors.purple,context),
                          buildColorOption(Colors.teal,context),
                          buildColorOption(Colors.indigo,context),

                          /// 🌈 Pastel Colors
                          buildColorOption(Color(0xFFFFC1CC),context), // Pink Pastel
                          buildColorOption(Color(0xFFB5EAEA),context), // Aqua Pastel
                          buildColorOption(Color(0xFFFFE6A7),context), // Light Orange
                          buildColorOption(Color(0xFFD9E4DD),context), // Grey Pastel
                          buildColorOption(Color(0xFFE4C1F9),context), // Purple Pastel

                          /// 🚀 Modern Flat Colors
                          buildColorOption(Color(0xFF0A97B0),context),
                          buildColorOption(Color(0xFF0099CC),context),
                          buildColorOption(Color(0xFF0061A8),context),
                          buildColorOption(Color(0xFF1B998B),context),
                          buildColorOption(Color(0xFF2D3047),context),

                          /// Dark Mode Friendly
                          buildColorOption(Color(0xFF232D3F),context),
                          buildColorOption(Color(0xFF0F0F0F),context),
                          buildColorOption(Color(0xFF1E1E2E),context),
                          buildColorOption(Color(0xFF2A2A2A),context),
                        ],
                      ),
                    ],
                  )
                ),
              ],
            ),
            BlocListener<SurveyBloc, SurveyState>(
  listener: (context, state) {
  if(state is CreateSurveyLoadingState){
    loading(context);
  }else if(state is CreateSurveyErrorState){
    error(context,state.failure.massage,state.failure.code);
  }else if(state is CreateSurveyState){
    Navigator.pushReplacementNamed(
      context,
      Routes.createQuesSurvey,
    );
  }
  },
  child: ElevatedButton(
              onPressed: () {
                final selectedColor = BlocProvider.of<ThemeBloc>(context).seedColor;
                BlocProvider.of<SurveyBloc>(context).add(CreateSurveyEvent(selectedColor.toString()
                  , titleController.text,
                  descriptionController.text,));
                               },
              child: const Text('Next'),
            ),
),

          ],
        ),
      ),
    );
  }
}

// 🔹 نفس الويجت السابق (مع توحيد التصميم)
Widget buildColorOption(Color color, BuildContext context) {
  return GestureDetector(
    onTap:  (){
      BlocProvider.of<ThemeBloc>(context).add(ChangeThemeColorEvent(color));
    },
    child: Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black12, width: 2),
      ),
    ),
  );
}