import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/presentation/conference/bloc/conference_bloc.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';

class ConferenceSurveyById extends StatelessWidget {
  const ConferenceSurveyById({super.key,required this.conferenceId});
final int conferenceId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text(
          "ربط الاستبيانات",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: ColorManager.black,
          ),
        ),
        actions: [
          IconButton(
            tooltip: "تحديث",

            onPressed: () => BlocProvider.of<ConferenceBloc>(
              context,
            ).add(GetAllSurveyByConferenceEvent()),
            icon: Icon(Icons.refresh_rounded, color: ColorManager.black),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<ConferenceBloc, ConferenceState>(
          builder: (context, state) {
            if (state is GetAllSurveyLoadingState) {
              return loadingFullScreen(context);
            }

            if (state is GetAllSurveyErrorState) {
              return errorFullScreen(
                context,
                func: () => BlocProvider.of<ConferenceBloc>(
                  context,
                ).add(GetAllSurveyByConferenceEvent()),
              );
            }
            if (state is GetAllSurveyState) {
              final surveys = state.allSurvey;
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                      child: _HeaderCard(
                        onAdd: () {
                          // TODO: Navigator to create survey
                        },
                      ),
                    ),
                  ),

                  if (surveys.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: _EmptyState(
                          onAdd: () {
                            // TODO: Navigator to create survey
                          },
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                      sliver: SliverList.separated(
                        itemCount: surveys.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) {
                          final s = surveys[i];
                          final bool isSelected =s.isActive;
                          return _SurveyTile(
                            title: s.title,
                            subtitle: (s.description ).trim(),
                            leadingColor: _parseColorSafe(s.color),
                            value: isSelected,
                            onChanged: (v) {
                              print("object");
                              BlocProvider.of<ConferenceBloc>(context).add(
                                LinkSurveyConferenceEvent( s.id,i,surveys,conferenceId),
                              );
                            },
                            onTap: () {
                              // optional: preview survey
                            },
                          );
                        },
                      ),
                    ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),

      // زر إضافة واضح وأنيق
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Navigator to create survey
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text(
              "إضافة استبيان جديد",
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: ColorManager.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.link_rounded, color: ColorManager.primary),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "اختر الاستبيانات",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 4),
                Text(
                  "فعّل السويتش لربط الاستبيان مع المؤتمر.",
                  style: TextStyle(fontSize: 12.8, color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: null, // استبدلها بـ onAdd إذا بدك زر صغير هنا
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: ColorManager.primary.withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.add_rounded, color: ColorManager.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _SurveyTile extends StatelessWidget {
  const _SurveyTile({
    required this.title,
    required this.subtitle,
    required this.leadingColor,
    required this.value,
    required this.onChanged,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final Color leadingColor;
  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE9ECF1)),
          ),
          child: Row(
            children: [
              // leading
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: leadingColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.fact_check_rounded, color: leadingColor),
              ),
              const SizedBox(width: 12),

              // text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.isEmpty ? "بدون عنوان" : title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle.isEmpty ? "بدون وصف" : subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.8,
                        color: Colors.black54,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // switch + label
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
                      fontWeight: FontWeight.w700,
                      color: value ? ColorManager.primary : Colors.black38,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: ColorManager.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.inbox_rounded, color: ColorManager.primary),
          ),
          const SizedBox(height: 10),
          const Text(
            "لا يوجد استبيانات",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          const Text(
            "أضف استبيان جديد ثم اربطه مع المؤتمر بالسويتش.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.8,
              color: Colors.black54,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                "إضافة استبيان",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// إذا عندك لون كنص (مثل "red") أو hex عدّل هون حسب داتاك
Color _parseColorSafe(dynamic color) {
  if (color == null) return ColorManager.primary;

  final c = color.toString().toLowerCase().trim();

  // hex مثل #ff0000 أو ff0000
  if (c.startsWith('#') || RegExp(r'^[0-9a-f]{6,8}$').hasMatch(c)) {
    final hex = c.replaceAll('#', '');
    final normalized = hex.length == 6 ? 'FF$hex' : hex;
    return Color(int.parse(normalized, radix: 16));
  }

  switch (c) {
    case 'red':
      return Colors.red;
    case 'blue':
      return Colors.blue;
    case 'green':
      return Colors.green;
    case 'orange':
      return Colors.orange;
    case 'purple':
      return Colors.purple;
    case 'teal':
      return Colors.teal;
    case 'indigo':
      return Colors.indigo;
    default:
      return ColorManager.primary;
  }
}
