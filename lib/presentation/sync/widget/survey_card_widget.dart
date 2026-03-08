import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/app/app_preferences.dart';
import 'package:formify/app/di.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/resources/theme_bloc/theme_bloc.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';
import 'package:formify/presentation/sync/widget/card_list_up_down.dart';
import 'package:formify/presentation/unit/animation/button_animation_with_text.dart';

class SurveyCard extends StatelessWidget {
  final IsActiveMainSurveyModel survey;
  final int index;

  const SurveyCard({super.key, required this.survey, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: ColorManager.primary),
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardListUpDown(),
          const SizedBox(height: 10),
          Text(
            survey.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(survey.description,

              maxLines: 5,

              overflow: TextOverflow.ellipsis,
              style: const TextStyle(

                  fontSize: 15)),
          const SizedBox(height: 30),
          buttonAnimationWithText(
            context,
            survey.isActive == true
                ? null
                : () {
                    BlocProvider.of<SyncBloc>(context).add(
                      GetQuestionAnswersEvent(survey.id, survey.title,survey.description, index,survey.timer),
                    );
                    BlocProvider.of<ThemeBloc>(context).add(
                      ChangeThemeColorEvent(
                        Color(int.parse(survey.color)),
                        survey.color,
                      ),
                    );
                    instance<AppPreferences>().isGame() == 1
                        ? Navigator.pushNamed(context, Routes.gameInput)
                        : Navigator.pushNamed(context, Routes.surveyInput);
                  },
            "ابدأ الاستبيانات",
          ),
        ],
      ),
    );
  }
}
