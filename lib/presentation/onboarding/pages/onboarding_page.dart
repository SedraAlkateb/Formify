import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/presentation/onboarding/bloc/onboarding_bloc.dart';
import 'package:formify/presentation/onboarding/widget/onboarding_widget.dart';
import 'package:formify/presentation/resources/assets_manager.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/unit/animation/animated_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: ColorManager.white,
        body: Column(
          children: [
            Expanded(
              child: PageView(
                // ✅ Arabic natural swipe (right -> left)
                reverse: true,
                controller: BlocProvider.of<OnboardingBloc>(context).controller,
                onPageChanged: (index) {
                  BlocProvider.of<OnboardingBloc>(context).isLastPageFun(index);
                },
                children: [
                  BuildPageLottie(
                    image: OnBoardingJsonAssets.survey,
                    title: "أنشئ استبياناتك بسهولة",
                    subtitle:
                    "أنشئ أي استبيان بشكل ديناميكي ودع المستخدمين يملؤونه مباشرةً عبر التطبيق.",
                  ),
                  BuildPageLottie(

                    image: OnBoardingJsonAssets.conference,
                    title: "أنشئ مؤتمرك أو فعاليتك",
                    subtitle:
                    "قم بإعداد المؤتمر أو الفعالية وإنشاء استبيانات للمشاركين ليقوموا بتعبئتها مباشرةً عبر التطبيق.",
                  ),
                  BuildPageLottie(
                    image: OnBoardingJsonAssets.analyses,
                    title: "حلّل النتائج فوراً",
                    subtitle:
                    "تابع الردود وحلّل الاستبيانات بسرعة لاتخاذ قرارات أفضل.",
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller:
                    BlocProvider.of<OnboardingBloc>(context).controller,
                    count: 3,
                    effect: WormEffect(
                      spacing: 12,
                      activeDotColor: ColorManager.black,
                      dotHeight: 10,
                      dotWidth: 10,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedButton(
                    text: BlocProvider.of<OnboardingBloc>(context).isLastPage
                        ? "ابدأ"
                        : "التالي",
                    onPressed: () {
                      if (BlocProvider.of<OnboardingBloc>(context).isLastPage) {

                        Navigator.pushReplacementNamed(context, Routes.loginPage);
                      } else {
                        BlocProvider.of<OnboardingBloc>(context)
                            .controller
                            .nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}