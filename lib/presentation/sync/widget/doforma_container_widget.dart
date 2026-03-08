import 'package:flutter/material.dart';
import 'package:formify/presentation/resources/assets_manager.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/responsive/font_responseve.dart';
import 'package:formify/presentation/resources/responsive/sizer_responseve.dart';

class FloatingContainer extends StatefulWidget {
  const FloatingContainer({super.key});

  @override
  _FloatingContainerState createState() => _FloatingContainerState();
}

class _FloatingContainerState extends State<FloatingContainer> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    // إعداد الـ AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true); // الحركة تتكرر للأعلى والأسفل بشكل دوري

    // إعداد الـ Tween لتحريك العنصر عموديًا
    _animation = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, 0.1))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose(); // تأكد من تنظيف الـ AnimationController بعد التخلص من الويدجت
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation, // تطبيق الـ SlideTransition
      child: Container(
        width: double.infinity,
        padding:  EdgeInsets.all(20.sp),
        margin:  EdgeInsets.all(40.sp),
        decoration: BoxDecoration(
          boxShadow:[
            BoxShadow(
              color: ColorManager.primaryShadow,
              blurRadius: 1,
              offset: Offset(0, 1)
            )
          ] ,
          border: Border.all(color: ColorManager.border),
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(25),
        ),

        child: Row(
          children: [
          Image.asset(ImageAssets.logoDomina,height: 80.sp,width: 60.sp,),
            Expanded(
              child: Padding(
                padding:  EdgeInsets.all(8.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "DoForma",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: ColorManager.primary,
                        fontSize: FontResponsive.font(
                          context,
                          mobile: 40,
                          tablet: 45,

                        ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "by Domina Pharmaceuticals",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: ColorManager.black,
                        fontSize: FontResponsive.font(
                          context,
                          mobile: 12,
                          tablet: 17,
                        ),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 20.sp),
          ],
        ),
      ),
    );
  }
}
