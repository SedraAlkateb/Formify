import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/app/app_preferences.dart';
import 'package:formify/app/di.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/conference/bloc/conference_bloc.dart';
import 'package:formify/presentation/conference/widget/conferm_dialog.dart';
import 'package:formify/presentation/home/widget/data_widget.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/responsive/breakpoints.dart';
import 'package:formify/presentation/resources/responsive/font_responseve.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';

class ConferenceEndedWidget extends StatelessWidget {
  const ConferenceEndedWidget({
    super.key,
    required this.index,
    required this.allConference,
    required this.value,
  });

  final int index;
  final int value;
  final List<GetAllConferenceModel> allConference;

  @override
  Widget build(BuildContext context) {
    // جلب قائمة الاختصاصات للمؤتمر الحالي بشكل آمن
    final conferenceSpecs = allConference[index].spec;

    return Container(
      padding: EdgeInsets.all(Breakpoints.isTabletPortrait(context) ? 18 : 16),
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
          // 1. عنوان المؤتمر
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(8),
                height: 20,
                width: 2,
                decoration: BoxDecoration(color: ColorManager.primary),
              ),
              Expanded(
                child: Text(
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  " ${allConference[index].name} ${index + 1}",
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

          // 🔥 2. قسم عرض الاختصاصات المتعددة (المضاف حديثاً)
          if (conferenceSpecs.isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Wrap(
                spacing: 6.0, // المسافة الأفقية بين البطاقات
                runSpacing: 4.0, // المسافة الرأسية عند النزول لسطر جديد
                children: conferenceSpecs.map((specItem) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: ColorManager.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: ColorManager.primary.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      specItem.title, // افتراض أن كلاس SpecModel يحتوي على حقل name
                      style: TextStyle(
                        color: ColorManager.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: FontResponsive.font(
                          context,
                          mobile: 11,
                          tablet: 15,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],

          const SizedBox(height: 12),

          // 3. تواريخ البدء والانتهاء
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
                        fontSize: FontResponsive.font(context, mobile: 13, tablet: 18),
                        color: Colors.grey.shade700,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      allConference[index].startDate,
                      style: TextStyle(
                        fontSize: FontResponsive.font(context, mobile: 13, tablet: 18),
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
                        fontSize: FontResponsive.font(context, mobile: 13, tablet: 18),
                        color: Colors.grey.shade700,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      allConference[index].endDate,
                      style: TextStyle(
                        fontSize: FontResponsive.font(context, mobile: 13, tablet: 18),
                        color: Colors.grey.shade700,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 4. أزرار التحكم (الحذف والتفعيل)
          ((instance<AppPreferences>().getIsConference() == null) ||
              (instance<AppPreferences>().getIsConference() == false))
              ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
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
                            message: "هل تريد حقا حذف المؤتمر",
                            onConfirm: () {
                              BlocProvider.of<ConferenceBloc>(context).add(
                                DeleteConferenceEvent(
                                  allConference[index].id,
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
                      Card(
                        elevation: 5,
                        color: ColorManager.success.withOpacity(0.25),
                        child: Radio<int>(
                          value: allConference[index].id,
                          groupValue: value,
                          fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                            if (states.contains(MaterialState.pressed) ||
                                states.contains(MaterialState.selected)) {
                              return Colors.white;
                            }
                            return Colors.green.shade800;
                          }),
                          splashRadius: 20,
                          focusColor: Colors.white,
                          onChanged: (v) {
                            showConfirmDialog(
                              context: context,
                              title: "تخزين المؤتمر داخليا",
                              message:
                              "هل انت متاكد من تفعيل المؤتمر , وتخزينه داخليا لبدء العمل عليه ورفع المؤتمر السابق اذا كان موجود ",
                              onConfirm: () {
                                BlocProvider.of<SyncBloc>(context).add(
                                  GetDataEvent(allConference[index].id, 0),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.arrow_forward, color: ColorManager.primary),
                ],
              ),
            ],
          )
              : const SizedBox(),
        ],
      ),
    );
  }
}