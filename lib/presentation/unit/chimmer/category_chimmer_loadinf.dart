import 'package:flutter/material.dart';
import 'package:formify/presentation/unit/chimmer/CustomShimmerWidget.dart';


class CategoryChimmerLoading extends StatelessWidget {
  const CategoryChimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return buildNotificationShimmer(context);
  }
  Widget buildNotificationShimmer(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 10,right: 10),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      // height: MediaQuery.of(context).size.height*0.1,
      child:
      const CustomShimmerWidget.rectangular(
        width: 125,
        height: 35.0,
      )


    ),
  );
}
