import 'package:flutter/material.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/resources/color_manager.dart';

Widget surveyListWidget(MainSurveyModel survey) {
  return Card(
    color: ColorManager.white,
    shape: RoundedRectangleBorder(
      side: BorderSide( color: ColorManager.black.withOpacity(0.1), width: 1),
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 5,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Card(
            margin: const EdgeInsets.all(5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            color: survey.color.contains("0x")
                ? Color(int.parse(survey.color))
                : Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(
                Icons.description_outlined,
                color: Color(0xffffffff),
                size: 30,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        survey.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        survey.description,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: ColorManager.black.withOpacity(0.5),
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
