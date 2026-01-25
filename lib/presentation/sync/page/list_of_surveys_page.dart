import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';
import 'package:formify/presentation/sync/widget/bouncing_icon_card.dart';
import 'package:formify/presentation/sync/widget/button_widget.dart';
import 'package:formify/presentation/sync/widget/card_list_up_down.dart';

class ListOfSurveysPage extends StatelessWidget {
  const ListOfSurveysPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorManager.firstScreenBackground2,
              ColorManager.firstScreenBackground1,
              ColorManager.firstScreenBackground1,
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 130,
              decoration: BoxDecoration(
                color: ColorManager.white,
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.primary,
                    offset: Offset(1, 1),
                    blurStyle: BlurStyle.outer,
                    blurRadius: 2,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    BouncingIconCard(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "الاستبيانات المتاحة",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: ColorManager.primary,
                          ),
                        ),
                        Text("اختر الاستبيان الذي تود المشاركة فيه",),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorManager.primary),
                    color: ColorManager.white,
                    //.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CardListUpDown(),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          BlocProvider.of<SyncBloc>(context).asyncModel!.surveys[index].title,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        BlocProvider.of<SyncBloc>(context).asyncModel!.surveys[index].description,
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      animatedButton(context, () {
                        Navigator.pushReplacementNamed(context, Routes.surveyInput);
                      },)
                    ],
                  ),
                ),
                itemCount: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
