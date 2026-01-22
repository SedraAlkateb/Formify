import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formify/presentation/resources/assets_manager.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/sync/widget/bouncing_icon_card.dart';
import 'package:formify/presentation/sync/widget/doforma_container_widget.dart';
import 'package:formify/presentation/sync/widget/press_scale.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:lottie/lottie.dart';

class ListOfSurveysPage extends StatelessWidget {
  const ListOfSurveysPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            ColorManager.firstScreenBackground2,
            ColorManager.firstScreenBackground1,
            ColorManager.firstScreenBackground1,
          ])
        ),
          child: Column(
            children: [
              Container(

                height: 100,
                decoration: BoxDecoration(
                    color: ColorManager.white,
                 boxShadow:[
                   BoxShadow(
                     color: ColorManager.primary,
                     offset: Offset(1, 1),
                     blurStyle: BlurStyle.outer,
                     blurRadius: 2,
                     spreadRadius: 2
                   )
                 ]
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      BouncingIconCard()
                    ],
                  ),
                ),
              ),
            Expanded(
              child: ListView.builder(itemBuilder: (context, index) =>
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorManager.primary),
                      color: ColorManager.white,
                      //.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                    child: Text("استبثيان رضا الحظور", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              ) , itemCount: 5),
            )
            ],
          ),

      ),
    );
  }
}
