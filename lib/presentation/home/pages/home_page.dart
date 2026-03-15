import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/app/app_preferences.dart';
import 'package:formify/app/constants.dart';
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
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/resources/values_manager.dart';
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
                final isTabletPortrait = Breakpoints.isTabletPortrait(context);
                final isMobilePortrait = Breakpoints.isMobilePortrait(context);
                if (isTabletPortrait || isMobilePortrait) {

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
                      tablet: 20,
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
      padding: EdgeInsets.symmetric(
        vertical: AppPadding.p10,
        horizontal: AppPadding.p16,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
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
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "المؤتمرات قيد المعالجة",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
                  ),
                  MultiBlocListener(
                    listeners: [
                      BlocListener<SyncBloc, SyncState>(
                        listener: (context, state) {
                          if(state is CheckoutState){
                            Navigator.pushNamedAndRemoveUntil(
                                context,
                                Routes.loginPage,
                                    (route) => false
                            );
                          }
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
                        List<GetAllConferenceModel> items = context
                            .read<ConferenceBloc>()
                            .allNotActiveConference;
                        if (state is GetAllConferenceState) {
                          items = state.allConference;
                        }
                        return Padding(
                          padding: EdgeInsets.only(bottom: 40),
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
              ),
            ],
          ),
        ],
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
        padding:
        Constants.isTablet?
        EdgeInsets.only(top: 20, left: 24, right: 24):EdgeInsets.only(top: 10, left: 0, right: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  getGreeting(),
                  style:  TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: FontResponsive.font(
                      context,
                      mobile: 30,
                      tablet: 35,

                    ),
                  ),
                ),
                Text(
                  "Domina",
                  style: TextStyle(
                    color: ColorManager.secondary,
                    fontWeight: FontWeight.w600,
                    fontSize: FontResponsive.font(
                      context,
                      mobile: 20,
                      tablet: 25,

                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  // العمود الأول
                  Expanded(
                    flex: 1, // هذا يعني أن العمود الأول سيأخذ نصف المساحة
                    child: CustomGridPage(),
                  ),
                  // العمود الثاني
                  Expanded(
                    flex: 1,

                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(

                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 30,right: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Text(
                                    "المؤتمرات قيد المعالجة",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: FontResponsive.font(
                                        context,
                                        mobile: 25,
                                        tablet: 30,

                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      const SizedBox(height: 30),
                                      MultiBlocListener(
                                        listeners: [
                                          BlocListener<SyncBloc, SyncState>(
                                            listener: (context, state) {
                                              if(state is CheckoutState){
                                                Navigator.pushNamedAndRemoveUntil(
                                                    context,
                                                    Routes.loginPage,
                                                        (route) => false
                                                );
                                              }
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
                                            List<GetAllConferenceModel> items = context
                                                .read<ConferenceBloc>()
                                                .allNotActiveConference;
                                            if (state is GetAllConferenceState) {
                                              items = state.allConference;
                                            }
                                                return ListView.separated(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
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
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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
