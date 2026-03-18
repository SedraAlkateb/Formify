import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/app/constants.dart';
import 'package:formify/presentation/conference/bloc/conference_bloc.dart';
import 'package:formify/presentation/home/widget/dialog_game_survey_widget.dart';
import 'package:formify/presentation/home/widget/grid_icon.dart';
import 'package:formify/presentation/home/widget/isMorning.dart';
import 'package:formify/presentation/home/widget/multi__bloc_for_conference_widget.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/responsive/breakpoints.dart';
import 'package:formify/presentation/resources/responsive/font_responseve.dart';
import 'package:formify/presentation/resources/values_manager.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<ConferenceBloc>().add(GetAllNotActiveConferenceEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: ColorManager.background,
        body: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            LayoutBuilder(
              builder: (_, c) {
                final isTabletPortrait = Breakpoints.isTabletPortrait(context);
                final isMobilePortrait = Breakpoints.isMobilePortrait(context);
                if (isTabletPortrait || isMobilePortrait) {

                  return HomeMobilePage();
                }
                return HomeTabletPage();
              },
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primary, // لون الخلفية
                  foregroundColor: Colors.white, // لون النص
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                onPressed: () {
                  showDialogGameSurveyWidget(
                    context: context,
                    title: "طريقة عرض الاستبيان",
                    message: "هل تريد ان تكون طريقة عرض الاستبيان لعبة ؟",
                  );
                },
                child: Text(
                  "   ابدأ المؤتمر   ",
                  style: TextStyle(
                    fontSize: FontResponsive.font(
                      context,
                      mobile: 14,
                      tablet: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeMobilePage extends StatelessWidget {
  const HomeMobilePage({super.key});

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        vertical: AppPadding.p10,
        horizontal: AppPadding.p16,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          Text(
            getGreeting(),
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
          ),
          Text(
            "Domina",
            style: TextStyle(
              color: ColorManager.secondary,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          Column(
            children: [
              CustomGridPage(),
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "المؤتمرات قيد المعالجة",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
                  ),
                  multiBlocConferenceWidget()
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HomeTabletPage extends StatelessWidget {
  const HomeTabletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
        Constants.isTablet?
        EdgeInsets.only(top: 20, left: 24, right: 24):EdgeInsets.only(top: 10, left: 0, right: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  getGreeting(),
                  style:  TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: FontResponsive.font(
                      context,
                      mobile: 30,
                      tablet: 35,

                    ),
                  ),
                ),
                Text(
                  "Domina",
                  style: TextStyle(
                    color: ColorManager.secondary,
                    fontWeight: FontWeight.w600,
                    fontSize: FontResponsive.font(
                      context,
                      mobile: 20,
                      tablet: 25,

                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  // العمود الأول
                  Expanded(
                    flex: 1, // هذا يعني أن العمود الأول سيأخذ نصف المساحة
                    child: CustomGridPage(),
                  ),
                  // العمود الثاني
                  Expanded(
                    flex: 1,

                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(

                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 30,right: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Text(
                                    "المؤتمرات قيد المعالجة",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: FontResponsive.font(
                                        context,
                                        mobile: 25,
                                        tablet: 30,

                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      const SizedBox(height: 30),
                                      multiBlocConferenceWidget()
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
