import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/presentation/conference/bloc/conference_bloc.dart';
import 'package:formify/presentation/conference/widget/survey_widget.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';

class ConferenceSurveyById1 extends StatelessWidget {
  const ConferenceSurveyById1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        title:  Text(
          "ربط الاستبيانات بالمؤتمر",
          style: TextStyle(fontWeight: FontWeight.w800,color: ColorManager.black),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header (شرح واضح + زر إضافة)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorManager.primary.withOpacity(0.12),
                      Colors.white,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: ColorManager.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: ColorManager.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.link_rounded,
                        color: ColorManager.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "اختر الاستبيانات المرتبطة",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            "فعّل السويتش بجانب الاستبيان لربطه مع هذا المؤتمر.",
                            style: TextStyle(
                              fontSize: 12.8,
                              color: Colors.black54,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: null, // ضع التنقل لإضافة Survey جديد
                      icon: Icon(Icons.add),
                      label: Text("إضافة"),
                      style: ButtonStyle(
                        backgroundColor:
                        WidgetStatePropertyAll(ColorManager.primary),
                        foregroundColor:
                        WidgetStatePropertyAll(Colors.white),
                        padding: WidgetStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(14)),
                          ),
                        ),
                        elevation: WidgetStatePropertyAll(0),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Counter / Hint line
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ColorManager.border),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline,
                            size: 16, color: Colors.black54),
                        SizedBox(width: 6),
                        Text(
                          "اسحب للأسفل للتحديث",
                          style: TextStyle(fontSize: 12.5, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // List
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: ColorManager.border),
                ),
                child: BlocBuilder<ConferenceBloc, ConferenceState>(
                  builder: (context, state) {
                    if (state is GetAllSurveyLoadingState) {
                      return loadingFullScreen(context);
                    }

                    if (state is GetAllSurveyErrorState) {
                      return errorFullScreen(
                        context,
                        func: () => BlocProvider.of<ConferenceBloc>(context)
                            .add(GetAllSurveyEvent()),
                      );
                    }

                    if (state is GetAllSurveyState) {
                      final surveys = state.allSurvey;

                      if (surveys.isEmpty) {
                        return _EmptySurveys(
                          onAdd: () {
                            // ضع التنقل لإضافة Survey جديد
                          },
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          BlocProvider.of<ConferenceBloc>(context)
                              .add(GetAllSurveyEvent());
                        },
                        child: ListView.separated(
                          padding: const EdgeInsets.all(12),
                          itemCount: surveys.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (_, i) {
                            final s = surveys[i];

                            // ملاحظة: بدّك حقّل يحدد إذا هذا الاستبيان مربوط بالمؤتمر
                            // مثال: s.isSelected أو s.isLinked
                            final bool isSelected =
                            ( false); // عدّل حسب موديلك

                            return _SurveySelectTile(
                              child: SurveyItemWidget(surveyModel: s),
                              value: isSelected,
                              onChanged: (v) {

                                BlocProvider.of<ConferenceBloc>(context).add(
                                  LinkSurveyConferenceEvent( s.id,i),
                                );
                              },
                            );
                          },
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      // زر إضافة واضح بأسفل الشاشة
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                // ضع التنقل لإضافة Survey جديد
              },
              icon: const Icon(Icons.add),
              label: const Text(
                "إضافة استبيان جديد",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SurveySelectTile extends StatelessWidget {
  const _SurveySelectTile({
    required this.child,
    required this.value,
    required this.onChanged,
  });

  final Widget child;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorManager.border),
      ),
      child: Row(
        children: [
          Expanded(child: child),
          const SizedBox(width: 10),
          Column(
            children: [
              Switch.adaptive(
                value: value,
                onChanged: onChanged,
                activeColor: ColorManager.primary,
              ),
              Text(
                value ? "مربوط" : "غير مربوط",
                style: TextStyle(
                  fontSize: 11.5,
                  color: value ? ColorManager.primary : Colors.black45,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptySurveys extends StatelessWidget {
  const _EmptySurveys({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: ColorManager.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inbox_outlined,
                  size: 44, color: ColorManager.primary.withOpacity(0.9)),
              const SizedBox(height: 10),
              const Text(
                "لا يوجد استبيانات بعد",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                "قم بإضافة استبيان جديد ثم ارجعه للمؤتمر عبر السويتش.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.8,
                  color: Colors.grey.shade700,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                  label: const Text("إضافة استبيان"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
