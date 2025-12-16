import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/survey/bloc/survey_bloc.dart';
import 'package:formify/presentation/survey/widget/text_view.dart';

class CreateQuesSurveyPage extends StatelessWidget {
  CreateQuesSurveyPage({super.key});

  final List<Map<String, dynamic>> questionTypes = [
    {
      "title": "Text",
      "icon": Icons.text_fields,
      "navigator": Routes.textQuestion,
     // "widget":textView(index)
    },
    {
      "title": "Dropdown",
      "icon": Icons.arrow_drop_down_circle,
      "navigator": Routes.dropDownQuestion,
    },
    {"title": "Multiple Choice", "icon": Icons.check_circle_outline},
    {"title": "Checkbox", "icon": Icons.check_box_outlined},
    {"title": "Switch", "icon": Icons.toggle_on_outlined},
    {"title": "Date & Time", "icon": Icons.date_range},
    {"title": "Slider", "icon": Icons.linear_scale},
    {"title": "Range Slider", "icon": Icons.track_changes_rounded},
    {"title": "File Upload", "icon": Icons.upload_file},
    {"title": "Signature", "icon": Icons.edit_document},
    {"title": "Color Picker", "icon": Icons.color_lens_outlined},
    {"title": "Searchable List", "icon": Icons.search},
    {"title": "Stepper Number Field", "icon": Icons.exposure_plus_1},
    {"title": "Multi-Page Form (Stepper)", "icon": Icons.view_week_rounded},
    {"title": "Generic Field", "icon": Icons.edit_note_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,

      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: colorScheme.primary,
        elevation: 2,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Formify",
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Smart Survey Builder",
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimary.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.event_note_outlined,
                size: 34,
                color: colorScheme.onPrimary,
              ),
              const SizedBox(width: 10),
            ],
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Choose Question Type",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.separated(
                itemCount: questionTypes.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = questionTypes[index];
                  return InkWell(
                    onTap: () {
                      final item = questionTypes[index];
                      BlocProvider.of<SurveyBloc>(context).add(CreateEmptyQuesNameSurveyEvent(item['title']));

                      final String routeName = item["navigator"] as String;
                      Navigator.pushNamed(
                        context,
                        routeName,
                        arguments: {
                          "name": "title",
                          "valid": true,
                        },
                      );
                    },

                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 18,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.06),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: colorScheme.outline.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item["icon"] as IconData,
                            size: 26,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 14),
                          Text(
                            item["title"] as String,
                            style: textTheme.bodyMedium?.copyWith(
                              fontSize: 16,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                            color: Colors.grey.shade500,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
