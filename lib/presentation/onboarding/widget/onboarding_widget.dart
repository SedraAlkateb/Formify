import 'package:flutter/material.dart';
import 'package:formify/app/app_preferences.dart';
import 'package:formify/app/di.dart';
import 'package:formify/presentation/resources/responsive/responsive_wrapper.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/unit/text_animation.dart';
import 'package:lottie/lottie.dart';

class BuildPageLottie extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const BuildPageLottie({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),

            // ✅ Arabic: "تخطي" aligned to the left in RTL layout
            Align(
              alignment: Alignment.topLeft,
              child: TextButton(
                onPressed: () {

                  Navigator.pushReplacementNamed(context, Routes.loginPage);
                },
                child: const Text(
                  "تخطي",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch, // ✅ full width
              children: [
                AdaptiveRowColumn(
                    left: Column(
                      children: [
                        const SizedBox(height: 40),

                        // ✅ Arabic alignment (right)
                        Align(
                          alignment: Alignment.centerRight,
                          child: SmoothBottomText(
                            text: title,
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            delay: Duration(milliseconds: 200),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerRight,
                          child: SmoothBottomText(
                            text: subtitle,
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            delay: Duration(milliseconds: 300),
                          ),
                        ),

                        const SizedBox(height: 30),

                      ],
                    ),
                    right: Lottie.asset(
                    image,
                    fit: BoxFit.fill,
                delegates: LottieDelegates(
                values: [
                ValueDelegate.color(['ADBE**'], value: Colors.black),
              ],
            ),
      ),
                ),


              ],
            ),
          ],
        ),
      ),
    );
  }
}