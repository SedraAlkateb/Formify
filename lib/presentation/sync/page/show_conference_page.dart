import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formify/presentation/resources/assets_manager.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/sync/widget/button_widget.dart';
import 'package:formify/presentation/sync/widget/doforma_container_widget.dart';
import 'package:formify/presentation/sync/widget/press_scale.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:lottie/lottie.dart';

class ShowConferencePage extends StatelessWidget {
  const ShowConferencePage({super.key});

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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                FloatingContainer(),
                Container(

                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorManager.border),
                    color: ColorManager.white,
                    boxShadow:[
                      BoxShadow(
                          color: ColorManager.black.withOpacity(0.2),
                          blurRadius: 3,
                          offset: Offset(0, 1)
                      )
                    ] ,
                    //.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          "المؤتمر الدولي للابتكارات الطبية 2026 ",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: ColorManager.primary,
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "نرحب بكم في المؤتمر السنوي الذي يجمع نخبة من الخبراء والمتخصصين في المجال الطبي والصيدلاني. شارك معنا في رحلة استكشاف أحدث الابتكارات والتقنيات في صناعة الأدوية.",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: ColorManager.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        //   SizedBox(height: 8),
                        InteractiveAddressCard(

                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: ColorManager.border),
                              color: ColorManager.primaryShadow.withOpacity(0.2),
                              //.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              children: [
                                Card(
                                  margin: const EdgeInsets.all(5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  // elevation: 4,
                                  color: ColorManager.primary,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Icon(
                                      Icons.location_on_outlined,
                                      color: Color(0xffffffff),
                                      size: 30,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "العنوان",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: ColorManager.textSecondary,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "فندق الريتز كارلتون - دبي، الإمارات العربية المتحدة",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: ColorManager.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                              ],
                            ),
                          ),
                        ),
                        InteractiveAddressCard(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: ColorManager.border),
                              color: ColorManager.primaryShadow.withOpacity(0.2),
                              //.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              children: [
                                Card(
                                  margin: const EdgeInsets.all(5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  // elevation: 4,
                                  color: ColorManager.primary,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Icon(
                                      Icons.date_range_sharp,
                                      color: Color(0xffffffff),
                                      size: 30,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "التاريخ",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: ColorManager.textSecondary,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          " 15 مارس 2026 - 18",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: ColorManager.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          " 15 مارس ",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: ColorManager.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                              ],
                            ),
                          ),
                        ),
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            LottieBuilder.asset(ShowConferenceJsonAssets.bubbles,width: 200,
                            fit: BoxFit.cover,),
                            animatedButton(context, () {
                              Navigator.pushReplacementNamed(context, Routes.listOfSurveys);
                            },)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
