import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/app/app_preferences.dart';
import 'package:formify/app/di.dart';
import 'package:formify/presentation/onboarding/bloc/onboarding_bloc.dart';
import 'package:formify/presentation/onboarding/widget/onboarding_widget.dart';
import 'package:formify/presentation/resources/assets_manager.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/unit/animated_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: ColorManager.white,
        body: Column(
          children: [
            Expanded(
              child: PageView(
                //   reverse: true,
                controller: BlocProvider.of<OnboardingBloc>(context).controller,
                onPageChanged: (index) {
                  BlocProvider.of<OnboardingBloc>(context).isLastPageFun(index);
                },
                children: [
                  buildPageLottie(
                    image: OnBoardingJsonAssets.survey,
                    title: "Create Your Surveys Easily ",
                    //    "📋",
                    subtitle:
                        "Build any dynamic survey and let users fill them directly through the app.",
                  ),
                  buildPageLottie(
                    image: OnBoardingJsonAssets.conference,
                    title: "Create Your Event ",
                    //  "🎤",
                    subtitle:
                        "Set up your conference or event and generate surveys for participants to fill directly through the app.",
                  ),
                  buildPageLottie(
                    image: OnBoardingJsonAssets.analyses,
                    title: "Analyze Results Instantly",
                    subtitle:
                        "Track responses and analyze surveys fast to make better decisions.",
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: BlocProvider.of<OnboardingBloc>(
                      context,
                    ).controller,
                    count: 3,
                    effect: WormEffect(
                      spacing: 12,
                      activeDotColor: ColorManager.black,
                      dotHeight: 10,
                      dotWidth: 10,
                    ),
                  ),
                  SizedBox(height: 20),
                  AnimatedButton(
                    text: BlocProvider.of<OnboardingBloc>(context).isLastPage
                        ? "ابدأ"
                        : "التالي",
                    onPressed: () {
                      if (BlocProvider.of<OnboardingBloc>(context).isLastPage) {
                        instance<AppPreferences>().setLoggedIn(1);
                        Navigator.pushReplacementNamed(
                          context,
                        Routes.home
                        );
                      } else {
                        BlocProvider.of<OnboardingBloc>(
                          context,
                        ).controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                  SizedBox(height: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
