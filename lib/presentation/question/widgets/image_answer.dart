import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:formify/app/constants.dart';
import 'package:formify/domain/models/models.dart';

Widget imageAnswer(AnswerModel a) {
  return ((a.img == null) && (a.imgName == null))
      ? SizedBox()
      : a.img != null
      ? Container(
    padding: EdgeInsets.only(bottom: 10, top: 10),
    decoration:
    BoxDecoration(borderRadius: BorderRadius.circular(12)),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.file(
          File(a.img!.path),
          fit: BoxFit.cover,
        ),
      ),
    ),
  )
      : Container(
    width: 200,       // العرض الثابت
    height: 150,      // الارتفاع الثابت
    margin: EdgeInsets.symmetric(vertical: 10),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        "${Constants.imageUrl}${a.imgName}",
        fit: BoxFit.cover,
      ),
    ),
  );
}
Widget imageAnswerNetwork(AnswerModel a) {
  return (a.imgName == null)
      ? SizedBox()
      :  Container(
    width: 200,       // العرض الثابت
    height: 150,      // الارتفاع الثابت
    margin: EdgeInsets.symmetric(vertical: 10),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        "${Constants.imageUrl}${a.imgName}",
        fit: BoxFit.cover,
      ),
    ),
  );
}
