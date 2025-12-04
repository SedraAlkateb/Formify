import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 24),
      child: Column(
        children: [
          SizedBox(height: 40,),
          Align(
          alignment: Alignment.topRight,
          child: Text(
            "Skip",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),

          Expanded(
            child: Column(
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
                      ValueDelegate.color(
                         ['ADBE**',],
                        value: Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
