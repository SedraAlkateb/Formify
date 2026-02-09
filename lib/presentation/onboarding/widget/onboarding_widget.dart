import 'package:flutter/material.dart';
import 'package:formify/app/app_preferences.dart';
import 'package:formify/app/di.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/unit/text_animation.dart';
import 'package:lottie/lottie.dart';

class buildPageLottie extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const buildPageLottie({
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
            SizedBox(height: 40),
            InkWell(
              onTap: () {
                instance<AppPreferences>().setLoggedIn(1);
                Navigator.pushReplacementNamed(
                    context,
                    Routes.home
                );
              },
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    instance<AppPreferences>().setLoggedIn(1);
                    Navigator.pushReplacementNamed(
                        context,
                        Routes.home
                    );
                  },
                  child:Text("Skip",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),) ,
                  
                ),
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                SmoothBottomText(
                  text: title,
                  fontSize: 20,
                  color: Colors.black,
                  // fontWeight: FontWeight.w400,
                  delay: Duration(milliseconds: 200), // أول نص
                ),
                SizedBox(height: 10),
                SmoothBottomText(
                  text: subtitle,
                  fontSize: 20,
                  color: Colors.black,
                  delay: Duration(milliseconds: 300), // يظهر بعده بقليل
                ),
                const SizedBox(height: 30),
                Lottie.asset(
                  image,
                  fit: BoxFit.fill,
                  delegates: LottieDelegates(
                    values: [
                      ValueDelegate.color(['ADBE**'], value: Colors.black),
                    ],
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
