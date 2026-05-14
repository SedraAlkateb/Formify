import 'package:flutter/material.dart';
import 'package:formify/app/app_preferences.dart';
import 'package:formify/app/constants.dart';
import 'package:formify/app/di.dart';
import 'package:formify/presentation/resources/assets_manager.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/resources/strings_manager.dart';
import 'package:formify/presentation/resources/values_manager.dart';
import 'package:formify/presentation/unit/animation/animation_container_widget.dart';
import 'package:formify/presentation/unit/animation/button_animation_with_text.dart';
import 'package:lottie/lottie.dart';

class FinishedInputSurveysPage extends StatelessWidget {
  const FinishedInputSurveysPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorManager.firstScreenBackground2,
                ColorManager.firstScreenBackground1,
                ColorManager.firstScreenBackground1,
              ],
            ),
          ),
          child: SafeArea(
            child:SingleChildScrollView(
              child: Column(
                children: [

                  Lottie.asset(JsonAssets.suc,
                 height:Constants.isTablet?400:200 ,
                  ),
                  Container(
                    width: double.infinity,
                    padding:  EdgeInsets.all(AppPadding.p20),
                    margin:  EdgeInsets.all(AppMargin.m25),
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorManager.border),
                      color: ColorManager.white,
                      boxShadow: [
                        BoxShadow(
                          color: ColorManager.black.withOpacity(0.2),
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                      //.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Padding(
                      padding:  EdgeInsets.all(AppPadding.p20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Text(
                            StringsManager.thanksForShare,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorManager.primary,
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: AppSize.s12),
                          Text(
                            StringsManager.descThankForShare,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorManager.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: AppSize.s12F),
                          AnimationContainerWidget(
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: ColorManager.border,
                                ),
                                color: ColorManager.primaryShadow
                                    .withOpacity(0.2),
                                //.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child:   Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Text(
                                    StringsManager.makeFuture,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: ColorManager.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    StringsManager.doForma,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: ColorManager
                                          .textSecondary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: AppSize.s12F),
                          buttonAnimationWithText(

                              context

                              , () {
                            Navigator.pushNamedAndRemoveUntil(context, Routes.showConference, (route) => false,);
                            instance<AppPreferences>().setLoggedIn(2);
                          }, StringsManager.goBackToHome),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}
