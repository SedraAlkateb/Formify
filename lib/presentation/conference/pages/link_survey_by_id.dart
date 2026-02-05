import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/conference/bloc/conference_bloc.dart';
import 'package:formify/presentation/conference/widget/header_card_widget.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/survey/bloc/survey_bloc.dart';
import 'package:formify/presentation/unit/add_survey_button.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';

class ConferenceSurveyById extends StatelessWidget {
  const ConferenceSurveyById({super.key, required this.conferenceId});
  final int conferenceId;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<ConferenceBloc>(
          context,
        ).add(GetConferenceByIdEvent(conferenceId));
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          foregroundColor: Colors.black87,
          title: const Text(
            "Link Surveys",
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
              ).add(GetAllSurveyByConferenceEvent(conferenceId)),
              icon: Icon(Icons.refresh_rounded, color: ColorManager.black),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<ConferenceBloc, ConferenceState>(
            builder: (context, state) {
              List<IsActiveMainSurveyModel> surveys =
                  BlocProvider.of<ConferenceBloc>(context).surveys;
              if (state is GetAllSurveyConferenceLoadingState) {
                return loadingFullScreen(context);
              }
              if (state is GetAllSurveyConferenceErrorState) {
                return errorFullScreen(
                  context,
                  func: () => BlocProvider.of<ConferenceBloc>(
                    context,
                  ).add(GetAllSurveyByConferenceEvent(conferenceId)),
                );
              }
              if (state is GetAllSurveyConferenceState) {
                surveys = state.allSurvey;
              }
              if(state is GetAllSurveyConferenceEmptyState){
                return emptyFullScreen(context);
              }
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                      child: HeaderCard(),
                    ),
                  ),

                  if (surveys.isEmpty)
                    emptyFullScreen(context)
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                      sliver: SliverList.separated(
                        itemCount: surveys.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) {
                          final s = surveys[i];
                          return _SurveyTile(
                            index: i,
                            title: s.title,
                            subtitle: (s.description).trim(),
                            leadingColor: s.color.contains("0x")
                                ? Color(int.parse(s.color))
                                : Color(0xE5D796CE),
                            value: s.isActive,
                            onChanged: (v) {
                              BlocProvider.of<ConferenceBloc>(context).add(
                                LinkSurveyConferenceEvent(
                                  s.id,
                                  i,
                                  surveys,
                                  conferenceId,
                                ),
                              );
                            },
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.viewSurvey,
                              );
                              BlocProvider.of<SurveyBloc>(context).add(
                                ViewSurveyByIdEvent(
                                  surveys[i].id,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ),

        // زر إضافة واضح وأنيق
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: surveyButton(context),
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
    required this.index
  });

  final String title;
  final String subtitle;
  final Color leadingColor;
  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback? onTap;
  final int index;

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
              Card(
                margin: const EdgeInsets.all(5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                color: leadingColor,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    Icons.description_outlined,
                    color: Color(0xffffffff),
                    size: 30,
                  ),
                ),
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

              BlocBuilder<ConferenceBloc, ConferenceState>(
                builder: (context, state) {
                  return (state is LinkSurveyConferenceLoadingState &&state.index==index)
                      ? CircularProgressIndicator()
                      : Column(
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
                                color: value
                                    ? ColorManager.primary
                                    : Colors.black38,
                              ),
                            ),
                          ],
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
