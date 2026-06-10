import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/app/app_preferences.dart';
import 'package:formify/app/di.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/conference/bloc/conference_bloc.dart';
import 'package:formify/presentation/conference/widget/conferm_dialog.dart';
import 'package:formify/presentation/offline_sync/bloc/offline_sync_bloc.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/responsive/breakpoints.dart';
import 'package:formify/presentation/resources/responsive/font_responseve.dart';

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
    final conference = allConference[index];
    final conferenceSpecs = conference.spec;
    final bool isTablet = Breakpoints.isTabletPortrait(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withOpacity(0.03),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. ترويسة الكرت: الأيقونة الذكية وعنوان المؤتمر
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ColorManager.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.event_available_rounded, color: ColorManager.primary, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        conference.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: FontResponsive.font(context, mobile: 16, tablet: 21),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                          height: 1.3,
                        ),
                      ),
                      if (conference.description != null && conference.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          conference.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: FontResponsive.font(context, mobile: 12, tablet: 15),
                            color: const Color(0xFF64748B),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            // 2. قسم الأوسمة الطبية للاختصاصات (عرض أفقي مرن)
            if (conferenceSpecs.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 6.0,
                runSpacing: 6.0,
                children: conferenceSpecs.map((specItem) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: ColorManager.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ColorManager.primary.withOpacity(0.12),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      specItem.title??"",
                      style: TextStyle(
                        color: ColorManager.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: FontResponsive.font(context, mobile: 11, tablet: 14),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 14),

            // خط فاصل داخلي خفيف للتنظيم الهندسي
            Divider(color: Colors.grey.shade100, height: 1),
            const SizedBox(height: 12),

            // 3. الخط الزمني لفترة المؤتمر (من - إلى) بشكل مدمج واحترافي
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_rounded, size: 16, color: Color(0xFF94A3B8)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          "من: ${conference.startDate}",
                          style: TextStyle(
                            fontSize: FontResponsive.font(context, mobile: 12, tablet: 15),
                            color: const Color(0xFF475569),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(Icons.arrow_left_outlined, size: 16, color: Color(0xFF94A3B8)),
                        ),
                        Text(
                          "إلى: ${conference.endDate}",
                          style: TextStyle(
                            fontSize: FontResponsive.font(context, mobile: 12, tablet: 15),
                            color: const Color(0xFF475569),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 4. لوحة أزرار التحكم السفلى (تظهر عند صلاحية التحكم بالمؤتمر)
            if ((instance<AppPreferences>().getIsConference() == null) ||
                (instance<AppPreferences>().getIsConference() == false)) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Material(
                        color: ColorManager.error.withOpacity(0.08),
                        shape: const CircleBorder(),
                        child: IconButton(
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(10),
                          onPressed: () => showConfirmDialog(
                            context: context,
                            title: "حذف المؤتمر",
                            message: "هل تريد حقاً حذف المؤتمر؟",
                            onConfirm1: () {
                              BlocProvider.of<ConferenceBloc>(context).add(
                                DeleteConferenceEvent(conference.id, index),
                              );
                            },
                          ),
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            color: ColorManager.error,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Material(
                        color: ColorManager.success.withOpacity(0.08),
                        shape: const CircleBorder(),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Radio<int>(
                            value: conference.id,
                            groupValue: value,
                            activeColor: ColorManager.success,
                            onChanged: (v) {
                              showConfirmDialog(
                                context: context,
                                title: "تخزين المؤتمر داخلياً",
                                message: "هل أنت متأكد من تفعيل المؤتمر، وتخزينه داخلياً لبدء العمل عليه ورفع المؤتمر السابق إذا كان موجوداً؟",
                                onConfirm1: () {
                                  BlocProvider.of<OfflineSyncBloc>(context).add(
                                    AsyncDataEvent(conference.id),
                                  );
                                },
                                // onConfirm2: () {
                                //   BlocProvider.of<OfflineSyncBloc>(context).add(
                                //       AsyncDataEvent(conference.id),
                                // },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  // سهم جانبي يعطي إيحاء بقابلية الضغط أو الانتقال
                  const Icon(
                    Icons.chevron_left_rounded,
                    color: Color(0xFF94A3B8),
                    size: 24,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}