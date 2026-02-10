import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/app/app_preferences.dart';
import 'package:formify/app/di.dart';
import 'package:formify/presentation/conference/widget/conferm_dialog.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';

import '../widget/button_widget.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            BlocListener<SyncBloc, SyncState>(
              listener: (context, state) {
                if (state is GetDataState) {
                  BlocProvider.of<SyncBloc>(
                    context,
                  ).add(UploadDataEvent(state.users, state.conference_id));
                } else if (state is UploadDataState) {
                  BlocProvider.of<SyncBloc>(context).add(DeleteDataEvent());
                } else if (state is DeleteDataState) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.home,
                        (route) => false,
                  );
                }
              },
              child: animatedButton(context, () {
                showConfirmDialog(
                  context: context,
                  title: "offline conference",
                  message:
                  "Are you sure you want to save conference offline",
                  onConfirm: () {
                    BlocProvider.of<SyncBloc>(
                      context,
                    ).add(
                      GetDataEvent(id),
                    );

                    //    BlocProvider.of<ConferenceBloc>(context).add(SelectEndedConferenceEvent( allConference[index].id));
                  },
                );
              }, "رفع الاستبيان"),
            ),
            const SizedBox(height: 10),
            animatedButton(context, () {
              instance<AppPreferences>().setLoggedIn(1);
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.home,
                    (route) => false,
              );
            }, "الخروج من المؤتمر"),
          ],
        ),
      ),
    );
  }
}
