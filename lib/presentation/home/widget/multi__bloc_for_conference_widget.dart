import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/app/app_preferences.dart';
import 'package:formify/app/di.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/conference/bloc/conference_bloc.dart';
import 'package:formify/presentation/home/widget/conference_ended_widget.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';

Widget multiBlocConferenceWidget(){
  return  MultiBlocListener(
    listeners: [
      BlocListener<SyncBloc, SyncState>(
        listener: (context, state) {
          if(state is CheckoutState){
            initOnBoardingModule();
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
  );
}