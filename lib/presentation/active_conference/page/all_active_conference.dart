import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/presentation/active_conference/bloc/active_conference_bloc.dart';
import 'package:formify/presentation/active_conference/widget/activce_conference.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';

class AllActiveConferencePage extends StatelessWidget {
  const AllActiveConferencePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ActiveConferenceBloc>(context);

    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: ColorManager.black),
        ),
        title: Text(
          "المؤتمرات المنتهية",
          style: TextStyle(color: ColorManager.black),
        ),
        backgroundColor: ColorManager.white,
      ),

      body: BlocBuilder<ActiveConferenceBloc, ActiveConferenceState>(
        buildWhen: (previous, current) {
          return current is GetAllActiveConferenceState ||
              current is GetAllActiveEmptyConferenceState ||
              current is GetAllActiveConferenceLoadingState ||
              current is GetAllActiveConferenceErrorState;
        },
        builder: (context, state) {
          if (state is GetAllActiveConferenceLoadingState) {
            return loadingFullScreen(context);
          } else if (state is GetAllActiveConferenceErrorState) {
            return errorFullScreen(context);
          } else if (state is GetAllActiveConferenceState) {
            final allConferences = state.allActiveConference;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: allConferences.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.viewActiveConference,
                        arguments: allConferences[index].id,
                      );
                    },
                    child: ActiveConferenceWidget(
                      conference: allConferences[index],
                    ),
                  );
                },
              ),
            );
          } else if (state is GetAllActiveEmptyConferenceState) {
            return emptyFullScreen(context);
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
