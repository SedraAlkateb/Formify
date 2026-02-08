import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/presentation/conference/bloc/conference_bloc.dart';
import 'package:formify/presentation/home/widget/conference_ended_widget.dart';
import 'package:formify/presentation/home/widget/grid_icon.dart';
import 'package:formify/presentation/home/widget/isMorning.dart';
import 'package:formify/presentation/resources/color_manager.dart';
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
    context.read<ConferenceBloc>().add(
      GetAllNotActiveConferenceEvent(),
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      body: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          SingleChildScrollView(
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
                  SizedBox(height: 500, child: CustomGridPage()),
                  Text(
                    "Ended Conference",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
                  ),
                  MultiBlocListener(
                    listeners: [
                      BlocListener<SyncBloc, SyncState>(
                        listener: (context, state) {
                          if (state is DataLoadingState) {
                            loading(context);
                          }  if (state is DataErrorState) {
                            error(
                              context,
                              state.failure.massage,
                              state.failure.code,
                            );
                          }  if (state is GetDataState) {
                            BlocProvider.of<SyncBloc>(
                              context,
                            ).add(UploadDataEvent(state.users,state.conference_id));
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
                            success(context);
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
                        final items = context
                            .read<ConferenceBloc>()
                            .allNotActiveConference;

                        return ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: items.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: ElevatedButton(onPressed: (){
              Navigator.pushNamedAndRemoveUntil(context,
              Routes.showConference,(route) => false,);
              BlocProvider.of<SyncBloc>(context).add(GetConferenceAsyncEvent());
            }, child:Text("start") ),
          ),

        ],
      ),
    );
  }
}
