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
                          /// 🔥 مجموعة ألوان أساسية (Primary Colors and Their Shades)
                          buildColorOption(Colors.blue, context, "0xFF2196F3"),   // Blue
                          buildColorOption(Color(0xFF0288D1), context, "0xFF0288D1"), // Royal Blue
                          buildColorOption(Color(0xFF1976D2), context, "0xFF1976D2"), // Blue
                          buildColorOption(Color(0xFF00C8FF), context, "0xFF00C8FF"), // Sky Blue
                          buildColorOption(Color(0xFFB5EAEA), context, "0xFFB5EAEA"), // Aqua Pastel
                          buildColorOption(Colors.purple, context, "0xFF9C27B0"), // Purple
                          buildColorOption(Color(0xFF6A4C93), context, "0xFF6A4C93"), // Lavender
                          buildColorOption(Color(0xFF3949AB), context, "0xFF3949AB"), // Blue Indigo
                          buildColorOption(Color(0xFF512DA8), context, "0xFF512DA8"), // Indigo Purple
                          buildColorOption(Colors.red, context, "0xFFF44336"),    // Red
                          buildColorOption(Colors.orange, context, "0xFFFF9800"), // Orange
                          buildColorOption(Colors.yellow, context, "0xFFFFEB3B"), // Yellow
                          buildColorOption(Color(0xFFFFE6A7), context, "0xFFFFE6A7"), // Light Orange
                          buildColorOption(Color(0xFFFFF8E1), context, "0xFFFFF8E1"), // Light Yellow
                          buildColorOption(Color(0xFFFAF3F0), context, "0xFFFAF3F0"), // Light Peach
                          buildColorOption(Colors.green, context, "0xFF4CAF50"),  // Green
                          buildColorOption(Color(0xFF1B998B), context, "0xFF1B998B"), // Greenish Teal
                          buildColorOption(Color(0xFFD9E4DD), context, "0xFFD9E4DD"), // Grey Pastel
                          buildColorOption(Color(0xFFF1F8E9), context, "0xFFF1F8E9"), // Light Green
                          buildColorOption(Color(0xFFE4C1F9), context, "0xFFE4C1F9"), // Purple Pastel
                          buildColorOption(Color(0xFFFFC1CC), context, "0xFFFFC1CC"), // Pink Pastel
                          buildColorOption(Colors.brown, context, "0xFF795548"),   // Brown
                          buildColorOption(Colors.grey, context, "0xFF9E9E9E"),    // Grey

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
                final selectedColor = BlocProvider.of<ThemeBloc>(context).colorName;
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
Widget buildColorOption(Color color, BuildContext context,String colorName) {
  return GestureDetector(
    onTap:  (){
      BlocProvider.of<ThemeBloc>(context).add(ChangeThemeColorEvent(color,colorName));
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