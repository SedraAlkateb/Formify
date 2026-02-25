import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/app/app_preferences.dart';
import 'package:formify/app/di.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/conference/bloc/conference_bloc.dart';
import 'package:formify/presentation/home/widget/conference_ended_widget.dart';
import 'package:formify/presentation/home/widget/dialog_game_survey_widget.dart';
import 'package:formify/presentation/home/widget/grid_icon.dart';
import 'package:formify/presentation/home/widget/isMorning.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/responsive/breakpoints.dart';
import 'package:formify/presentation/resources/responsive/font_responseve.dart';
import 'package:formify/presentation/resources/responsive/responsive_wrapper.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<ConferenceBloc>().add(GetAllNotActiveConferenceEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: ColorManager.background,
        body: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            LayoutBuilder(
              builder: (_, c) {
                final isTabletPortrait =
                    Breakpoints.isTabletPortrait(context) ;
                final isMobilePortrait =
                Breakpoints.isMobilePortrait(context) ;
                if (isTabletPortrait||isMobilePortrait) {
                  return HomeMobilePage();
                }
                return HomeTabletPage();
              },
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primary, // لون الخلفية
                  foregroundColor: Colors.white, // لون النص
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                onPressed: () {
                  showDialogGameSurveyWidget(
                    context: context,
                    title: "طريقة عرض الاستبيان",
                    message: "هل تريد ان تكون طريقة عرض الاستبيان لعبة ؟",
                  );
                },
                child: Text(
                  "   ابدأ المؤتمر   ",
                  style: TextStyle(
                    fontSize: FontResponsive.font(
                      context,
                      mobile: 14,
                      tablet: 18,
                      desktop: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeMobilePage extends StatelessWidget {
  const HomeMobilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getGreeting(),
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
            ),
            Text(
              "Domina",
              style: TextStyle(
                color: ColorManager.secondary,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            Column(
              children: [
                CustomGridPage(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "المؤتمرات قيد المعالجة",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                      ),
                    ),
                    MultiBlocListener(
                      listeners: [
                        BlocListener<SyncBloc, SyncState>(
                          listener: (context, state) {
                            if (state is DataLoadingState) {
                              loading(context);
                            }
                            if (state is DataErrorState) {
                              error(
                                context,
                                state.failure.massage,
                                state.failure.code,
                              );
                            }
                            if (state is GetDataState) {
                              BlocProvider.of<SyncBloc>(context).add(
                                UploadDataEvent(
                                  state.users,
                                  state.conference_id,
                                  0,
                                ),
                              );
                            } else if (state is UploadDataState) {
                              BlocProvider.of<SyncBloc>(
                                context,
                              ).add(DeleteDataEvent());
                            } else if (state is DeleteDataState) {
                              BlocProvider.of<SyncBloc>(
                                context,
                              ).add(AsyncDataEvent());
                            } else if (state is AsyncConferenceState) {
                              BlocProvider.of<SyncBloc>(
                                context,
                              ).add(InsertDataSqlEvent(state.asyncModel));
                            } else if (state is InsertSucState) {
                              BlocProvider.of<ConferenceBloc>(
                                context,
                              ).add(UpdateConferenceEvent(1));
                              success(context);
                              instance<AppPreferences>().setIConference(true);
                            }
                          },
                        ),
                      ],

                      child: BlocBuilder<ConferenceBloc, ConferenceState>(
                        buildWhen: (previous, current) =>
                        current is GetAllConferenceState ||
                            current is GetAllConferenceLoadingState ||
                            current is GetAllConferenceErrorState ||
                            current is GetAllEmptyConferenceState ||
                            current is SelectEndedConferenceState,
                        builder: (context, state) {
                          if (state is GetAllConferenceLoadingState) {
                            return loadingFullScreen(context);
                          } else if (state is GetAllConferenceErrorState) {
                            return errorFullScreen(
                              context,
                              func: () => context.read<ConferenceBloc>().add(
                                GetAllNotActiveConferenceEvent(),
                              ),
                            );
                          } else if (state is GetAllEmptyConferenceState) {
                            return emptyFullScreen(context);
                          }
                          // else if(state is GetConferenceAsyncEmptyState){
                          //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:  const SnackBar(
                          //     content: Text(
                          //       "No Conference Found",
                          //     ),
                          //   ),));
                          // }
                          List<GetAllConferenceModel> items = context
                              .read<ConferenceBloc>()
                              .allNotActiveConference;
                          if (state is GetAllConferenceState) {
                            items = state.allConference;
                          }
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 40),
                            child: ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: items.length,
                              separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.viewConference,
                                      arguments: items[index].id,
                                    );
                                  },
                                  child: ConferenceEndedWidget(
                                    value:
                                    context
                                        .read<ConferenceBloc>()
                                        .selectConferenceId ??
                                        0,
                                    index: index,
                                    allConference: items,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              ],
            )

          ],
        ),
      ),
    );
  }
}

class HomeTabletPage extends StatelessWidget {
  const HomeTabletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getGreeting(),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 35),
            ),
            Text(
              "Domina",
              style: TextStyle(
                color: ColorManager.secondary,
                fontWeight: FontWeight.w600,
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 6,
                    child: SizedBox.expand(child: CustomGridPage()),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 5,
                    child: SizedBox.expand(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "المؤتمرات قيد المعالجة",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 35,
                            ),
                          ),
                          const SizedBox(height: 40),

                          Expanded(
                            child: MultiBlocListener(
                              listeners: [
                                BlocListener<SyncBloc, SyncState>(
                                  listener: (context, state) {
                                    if (state is DataLoadingState) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                            loading(context);
                                          });
                                    }
                                    if (state is DataErrorState) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                            error(
                                              context,
                                              state.failure.massage,
                                              state.failure.code,
                                            );
                                          });
                                    }

                                    if (state is GetDataState) {
                                      context.read<SyncBloc>().add(
                                        UploadDataEvent(
                                          state.users,
                                          state.conference_id,
                                          0,
                                        ),
                                      );
                                    } else if (state is UploadDataState) {
                                      context.read<SyncBloc>().add(
                                        DeleteDataEvent(),
                                      );
                                    } else if (state is DeleteDataState) {
                                      context.read<SyncBloc>().add(
                                        AsyncDataEvent(),
                                      );
                                    } else if (state is AsyncConferenceState) {
                                      context.read<SyncBloc>().add(
                                        InsertDataSqlEvent(state.asyncModel),
                                      );
                                    } else if (state is InsertSucState) {
                                      BlocProvider.of<ConferenceBloc>(
                                        context,
                                      ).add(UpdateConferenceEvent(1));
                                      success(context);
                                      instance<AppPreferences>().setIConference(
                                        true,
                                      );
                                    }
                                  },
                                ),
                              ],
                              child:
                                  BlocBuilder<ConferenceBloc, ConferenceState>(
                                    builder: (context, state) {
                                      final items = context
                                          .read<ConferenceBloc>()
                                          .allNotActiveConference;
                                      return ListView.separated(
                                        padding: EdgeInsets.only(bottom: 40),
                                        itemCount: items.length,
                                        separatorBuilder: (_, __) =>
                                            const SizedBox(height: 10),
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                Routes.viewConference,
                                                arguments: items[index].id,
                                              );
                                            },
                                            child: ConferenceEndedWidget(
                                              value:
                                                  context
                                                      .read<ConferenceBloc>()
                                                      .selectConferenceId ??
                                                  0,
                                              index: index,
                                              allConference: items,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
