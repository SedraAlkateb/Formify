import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/presentation/home/pages/home_page.dart';
import 'package:formify/presentation/onboarding/bloc/onboarding_bloc.dart';
import 'package:formify/presentation/onboarding/widget/onboarding_widget.dart';
import 'package:formify/presentation/resources/assets_manager.dart';
import 'package:formify/presentation/resources/color_manager.dart';
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
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 400),
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                                  return HomePage();
                                }, // غيريها حسب الصفحة المطلوبة
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  const begin = Offset(
                                    1.0,
                                    0.0,
                                  ); // من اليمين لليسار
                                  const end = Offset.zero;
                                  const curve = Curves.easeInOut;

                                  final tween = Tween(
                                    begin: begin,
                                    end: end,
                                  ).chain(CurveTween(curve: curve));

                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                          ),
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
