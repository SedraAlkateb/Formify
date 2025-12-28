import 'package:flutter/material.dart';
import 'package:formify/presentation/unit/chimmer/CustomShimmerWidget.dart';


class LoadingChimmerWidget extends StatelessWidget {
  const LoadingChimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return buildNotificationShimmer(context);
  }
  Widget buildNotificationShimmer(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 10,right: 10),
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),

      ),
     // height: MediaQuery.of(context).size.height*0.1,
      child:
      Row(
        children: [
          Expanded(
            child: CustomShimmerWidget.rectangular(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          )
        ],
      ),


    ),
  );
}
