import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/conference/widget/conferm_dialog.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';
import 'package:formify/presentation/sync/widget/bouncing_icon_card.dart';
import 'package:formify/presentation/sync/widget/button_widget.dart';
import 'package:formify/presentation/sync/widget/card_list_up_down.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';

class ListOfSurveysPage extends StatelessWidget {
  const ListOfSurveysPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
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
                          Text("اختر الاستبيان الذي تود المشاركة فيه"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              BlocBuilder<SyncBloc, SyncState>(
                buildWhen: (previous, current) =>
                    current is GetSurveyAsyncErrorState ||
                    current is GetSurveyAsyncLoadingState ||
                    current is GetSurveyAsyncState ||
                    current is SurveySubmitSuccessState,
                builder: (context, state) {
                  if (state is GetSurveyAsyncErrorState) {
                    return errorFullScreen(context);
                  } else if (state is GetSurveyAsyncLoadingState) {
                    return loadingFullScreen(context);
                  } else if (state is GetSurveyAsyncState ||
                      state is SurveySubmitSuccessState) {
                    List<IsActiveMainSurveyModel> surveys =[];
                    if(state is SurveySubmitSuccessState ){
                      surveys=state.surveys;
                    }
                    if(state is GetSurveyAsyncState ){
                      surveys=state.surveys;
                    }
                    return Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.builder(

                              itemBuilder: (context, index) => Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: ColorManager.primary),
                                  color: ColorManager.white,
                                  //.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.all(20),
                                margin: EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 20,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CardListUpDown(),
                                    SizedBox(height: 10),
                                    Text(
                                      surveys[index].title,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      surveys[index].description,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    SizedBox(height: 30),
                                    animatedButton(context,
                                            surveys[index].isActive==true?null:
                                            () {
                                      BlocProvider.of<SyncBloc>(context).add(
                                        GetQuestionAnswersEvent(
                                          surveys[index].id,
                                          surveys[index].title,
                                          index,
                                        ),
                                      );
                                      Navigator.pushNamed(context, Routes.surveyInput);
                                    }, "ابدأ الاستبيانات"),
                                  ],
                                ),
                              ),
                              itemCount: surveys.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30,bottom: 30),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamedAndRemoveUntil(context, Routes.showConference, (route) => false,);
                                },

                                icon: const Icon(Icons.arrow_back),

                                iconAlignment: IconAlignment.start,
                                label: const Text(' الرجوع الى المؤتمر '),
                                style: ElevatedButton.styleFrom(

                                  padding: const EdgeInsets.symmetric(vertical: 14,horizontal: 20),

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),

                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else
                    return SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
