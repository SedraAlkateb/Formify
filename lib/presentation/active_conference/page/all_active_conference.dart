import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/active_conference/bloc/active_conference_bloc.dart';
import 'package:formify/presentation/active_conference/widget/activce_conference.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/responsive/font_responseve.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/resources/values_manager.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';

class AllActiveConferencePage extends StatelessWidget {
  const AllActiveConferencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: ColorManager.black),
        ),
        title: Text(
          "المؤتمرات المنتهية",

          style: TextStyle(
            color: ColorManager.black,
            fontSize: FontResponsive.font(context, mobile: 20, tablet: 24),
          ),
        ),
        backgroundColor: ColorManager.white,
      ),

      body: BlocConsumer<ActiveConferenceBloc, ActiveConferenceState>(
        listener: (context, state) {
          if(state is DeleteFinishedConferenceErrorState){
            error(context, state.failure.massage, state.failure.code);
          }else if(state is DeleteFinishedConferenceLoadingState){
            loading(context);
          }
        },
        builder: (context, state) {
          List<GetAllConferenceModel> allConferences =
              BlocProvider.of<ActiveConferenceBloc>(
                context,
              ).allActiveConference;
          if (state is GetAllActiveConferenceLoadingState) {
            return loadingFullScreen(context);
          } else if (state is GetAllActiveConferenceErrorState) {
            return errorFullScreen(context);
          } else if (state is GetAllActiveConferenceState) {
            allConferences = state.allActiveConference;
          } else if (state is GetAllActiveEmptyConferenceState) {
            return emptyFullScreen(context);
          }
          return Padding(
            padding: EdgeInsets.all(AppPadding.p16),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: allConferences.length,
              separatorBuilder: (context, index) =>
                  SizedBox(height: AppPadding.p10),
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
                    index: index,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
