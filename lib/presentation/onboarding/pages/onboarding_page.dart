import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/presentation/home/pages/home_page.dart';
import 'package:formify/presentation/onboarding/bloc/onboarding_bloc.dart';
import 'package:formify/presentation/resources/assets_manager.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return  false;
      },
      child: Scaffold(
        backgroundColor: ColorManager.white,
        body: PageView(
          reverse: true, // 👈 خلي الصفحات تمشي بالعكس (من اليسار لليمين)
          controller: BlocProvider.of<OnboardingBloc>(context).controller,
          onPageChanged: (index) {
            BlocProvider.of<OnboardingBloc>(context).isLastPageFun(index);
          },
          children: [
            buildPage(
              image: "ImageAssets",
              title: "كل ما تحتاجه في مكان واحد 🛍️",
              subtitle: "تسوق من متجرنا جميع المنتجات بمختلف الأنواع والأقسام بسهولة وسرعة.",
            ),

            buildPage(
              image:" ImageAssets.solder",
              title: "اطلب المفضلة لديك",
              subtitle: "استمتع بالخصومات والمكافآت.",
            ),
            buildPage(
              image:" ImageAssets.delivery1",
              title: "توصيل خلال 30 دقيقة",
              subtitle: "يصلك طلبك بأسرع وقت.",
            ),
          ],
        ),
        bottomSheet: Container(
          color:   ColorManager.black,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 120,
          child: Column(
            children: [
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..scale(-1.0, 1.0),
                child: SmoothPageIndicator(
                  controller: BlocProvider.of<OnboardingBloc>(context).controller,
                  count: 3,
                  effect: WormEffect(
                    spacing: 12,
                    activeDotColor: ColorManager.black,
                    dotHeight: 10,
                    dotWidth: 10,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  // ✅ المؤشر مع الانعكاس

                  TextButton(
                    child: Text(BlocProvider.of<OnboardingBloc>(context).isLastPage ? "ابدأ" : "التالي"),
                    onPressed: () {
                      if (BlocProvider.of<OnboardingBloc>(context).isLastPage) {
                        Navigator.pushReplacement(

                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 400),
                            pageBuilder: (context, animation,
                                secondaryAnimation) {
                              return  HomePage();
                            }
                            , // غيريها حسب الصفحة المطلوبة
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin =
                              Offset(1.0, 0.0); // من اليمين لليسار
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;

                              final tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),

                        );
                      } else {
                        BlocProvider.of<OnboardingBloc>(context).controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                  TextButton(
                    child: const Text("تخطي"),
                    onPressed: () => BlocProvider.of<OnboardingBloc>(context).controller.jumpToPage(2),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPage({
    required String image,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 250),
          const SizedBox(height: 30),
          Text(title,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
