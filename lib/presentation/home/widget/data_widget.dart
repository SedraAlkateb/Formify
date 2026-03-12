import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formify/app/constants.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/values_manager.dart';

Widget dataWidget(Color color, Widget colum){
  return Card(

      margin: const EdgeInsets.all(5),
  shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(12),
  ),
  elevation: 4,
  color: ColorManager.background,
  child: Row(
    children: [
      Padding(
      padding: const EdgeInsets.only(right: 5),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 4,
          color: ColorManager.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 10),
            child: Icon(

              Icons.date_range,
              color: color,
              size:Constants.isTablet?30: 20,
            ),
          ),
        ),
      ),
      Padding(
        padding:  EdgeInsets.all(AppPadding.p10),
        child: colum,
      )
    ],
  ),

  );
}