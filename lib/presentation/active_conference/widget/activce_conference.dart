import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/app/constants.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/active_conference/bloc/active_conference_bloc.dart';
import 'package:formify/presentation/conference/widget/conferm_dialog.dart';
import 'package:formify/presentation/home/widget/data_widget.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/responsive/font_responseve.dart';
import 'package:formify/presentation/resources/values_manager.dart';

class ActiveConferenceWidget extends StatelessWidget {
  const ActiveConferenceWidget({super.key, required this.conference,required this.index});
  final GetAllConferenceModel conference;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppPadding.p16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(8),
                height: 20,
                width: 2,
                decoration: BoxDecoration(color: ColorManager.primary),
              ),
              Expanded(
                child: Text(
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  " ${conference.name}",
                  style: TextStyle(
                    fontSize: FontResponsive.font(
                      context,
                      mobile: 18,
                      tablet: 23,
                    ),
                    fontWeight: FontWeight.w600,
                    color: ColorManager.primary,
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              dataWidget(
                ColorManager.success,
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "البدء: ",
                      style: TextStyle(
                        fontSize: FontResponsive.font(
                          context,
                          mobile: 13,
                          tablet: 18,
                        ),
                        color: Colors.grey.shade700,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      conference.startDate,
                      style: TextStyle(
                        fontSize: FontResponsive.font(
                          context,
                          mobile: 13,
                          tablet: 18,
                        ),
                        color: Colors.grey.shade700,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
              dataWidget(
                ColorManager.error,
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "الانتهاء: ",
                      style: TextStyle(
                        fontSize: FontResponsive.font(
                          context,
                          mobile: 13,
                          tablet: 18,
                        ),
                        color: Colors.grey.shade700,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      conference.endDate,
                      style: TextStyle(
                        fontSize: FontResponsive.font(
                          context,
                          mobile: 13,
                          tablet: 18,
                        ),
                        color: Colors.grey.shade700,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: AppSize.s10),
          Divider(),
          SizedBox(height: AppSize.s10),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.arrow_forward, color: ColorManager.primary,size: Constants.isTablet?30:26,),
              Card(
                elevation: 5,
                color: ColorManager.error.withOpacity(0.25),
                child: IconButton(
                  color: ColorManager.white,
                  autofocus: true,
                  splashRadius: 200,
                  onPressed: () => showConfirmDialog(
                    context: context,
                    title: "حذف المؤتمر",
                    message: "هل تريد حقا حذف مؤتمر منتهي ؟؟",
                    onConfirm1: () {
                      BlocProvider.of<ActiveConferenceBloc>(
                        context,
                      ).add(
                        DeleteFinishedConferenceEvent(
                          conference.id,

                          index,
                        ),
                      );
                    },
                  ),

                  icon: Icon(
                    Icons.delete_outlined,
                    color: ColorManager.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
