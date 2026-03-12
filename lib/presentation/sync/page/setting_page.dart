import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/app/app_preferences.dart';
import 'package:formify/app/di.dart';
import 'package:formify/presentation/conference/widget/conferm_dialog.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/resources/strings_manager.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';
import 'package:formify/presentation/unit/animation/animation_container_widget.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorManager.firstScreenBackground2,
              ColorManager.firstScreenBackground1,
              ColorManager.firstScreenBackground1,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 90,
                decoration: BoxDecoration(
                  color: ColorManager.white,
                  boxShadow: [
                    BoxShadow(
                      color: ColorManager.primary,
                      offset: const Offset(1, 1),
                      blurStyle: BlurStyle.outer,
                      blurRadius: 2,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 20),
                    Icon(
                      Icons.settings_outlined,
                      color: ColorManager.primary,
                      size: 35,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      StringsManager.setting,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorManager.primary,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              BlocListener<SyncBloc, SyncState>(
                listener: (context, state) {
                  if (state is DataLoadingState) {
                    loading(context);
                  }
                  //////////////////
                  if (state is GetDataState) {
                    BlocProvider.of<SyncBloc>(context).add(
                      UploadDataEvent(
                        state.users,
                        state.conference_id,
                        state.isActive,
                      ),
                    );
                  } else if (state is UploadDataState) {
                    if (state.isUpload == 0) {
                      BlocProvider.of<SyncBloc>(context).add(DeleteUserEvent());
                    } else {
                      BlocProvider.of<SyncBloc>(context).add(DeleteDataEvent());
                    }
                  } else if (state is DeleteDataState) {
                    instance<AppPreferences>().setIConference(
                      state.isActive == 0 ? false : true,
                    );
                    Navigator.of(context).pushReplacementNamed(Routes.home);
                    instance<AppPreferences>().setLoggedIn(1);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.home,
                      (route) => false,
                    );
                  }
                },
                child: Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            border: Border.all(color: ColorManager.border),
                            color: ColorManager.white,
                            boxShadow: [
                              BoxShadow(
                                color: ColorManager.black.withOpacity(0.2),
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.table_rows_rounded,
                                      color: ColorManager.primary,
                                      size: 35,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      StringsManager.manageConference,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: ColorManager.primary,
                                        fontSize: 23,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                InkWell(
                                  onTap: () {
                                    showConfirmDialog(
                                      context: context,

                                      title: "حفظ بيانات المؤتمر",
                                      message:
                                          "هل انت متاكد من انك انتهيت من ملئ معلومات المؤتمر وتريد رفعه , تأكد من اتصالك بالانترنت لرفع البيانات",

                                      onConfirm: () {
                                        BlocProvider.of<SyncBloc>(
                                          context,
                                        ).add(GetDataEvent(id, 0));
                                      },
                                    );
                                  },
                                  child: AnimationContainerWidget(
                                    child: Container(

                                      width: double.infinity,
                                      padding: const EdgeInsets.all(20),
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: ColorManager.border,
                                        ),
                                        color: ColorManager.primary,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Card(
                                            margin: const EdgeInsets.only(
                                              left: 15,
                                              top: 15,
                                              bottom: 15,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            color: ColorManager.accent,
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 15,
                                                horizontal: 15,
                                              ),
                                              child: Icon(
                                                Icons.cloud_upload_outlined,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  StringsManager.saveConference,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: ColorManager.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  StringsManager
                                                      .uploadConferenceDesc,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: ColorManager.white,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward,
                                            color: ColorManager.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                /////////////////////////tyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyh
                                InkWell(
                                  onTap: () {
                                    showConfirmDialog(
                                      context: context,

                                      title: "رفع بيانات المؤتمر",
                                      message:
                                      "هل انت متاكد من انك انتهيت من ملئ معلومات المؤتمر وتريد رفعه , تأكد من اتصالك بالانترنت لرفع البيانات",

                                      onConfirm: () {
                                        BlocProvider.of<SyncBloc>(
                                          context,
                                        ).add(GetDataEvent(id, 1));
                                      },
                                    );
                                  },
                                  child: AnimationContainerWidget(
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(20),
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: ColorManager.border,
                                        ),
                                        color: ColorManager.primary,
                                        borderRadius: BorderRadius.circular(
                                          25,
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: [
                                          Card(
                                            margin: const EdgeInsets.only(
                                              left: 15,
                                              top: 15,
                                              bottom: 15,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(12),
                                            ),
                                            color: ColorManager.accent,
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 15,
                                                horizontal: 15,
                                              ),
                                              child: Icon(
                                                Icons.cloud_upload_outlined,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  StringsManager
                                                      .uploadConference,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: ColorManager.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  StringsManager
                                                      .uploadConferenceDesc,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: ColorManager.white,
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward,
                                            color: ColorManager.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                InkWell(
                                  onTap: () {
                                    instance<AppPreferences>().setLoggedIn(1);
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      Routes.home,
                                      (route) => false,
                                    );
                                  },
                                  child: AnimationContainerWidget(
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(20),
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: ColorManager.border,
                                        ),
                                        color: ColorManager.primary,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: [
                                          Card(
                                            margin: const EdgeInsets.only(
                                              left: 15,
                                              top: 15,
                                              bottom: 15,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            color: ColorManager.accent,
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 15,
                                                horizontal: 15,
                                              ),
                                              child: Icon(
                                                Icons.logout,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  StringsManager
                                                      .logoutConference,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: ColorManager.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  StringsManager
                                                      .logoutConferenceDesc,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: ColorManager.white,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward,
                                            color: ColorManager.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: ColorManager.border,
                                    ),
                                    color: ColorManager.primaryShadow
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Icon(
                                          Icons.error_outline,
                                          color: ColorManager.splash1,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              StringsManager.importantNote,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: ColorManager.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              StringsManager.importantNoteDesc,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color:
                                                    ColorManager.textSecondary,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
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
                        ),

                        BlocBuilder<SyncBloc, SyncState>(
                          builder: (context, state) {
                            if (state is GetInfoConferenceErrorState) {
                              return errorFullScreen(context);
                            } else if (state is GetInfoConferenceSuccessState) {
                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ColorManager.border,
                                  ),
                                  color: ColorManager.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: ColorManager.black.withOpacity(
                                        0.2,
                                      ),
                                      blurRadius: 3,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.bar_chart,
                                            color: ColorManager.primary,
                                            size: 35,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            StringsManager.total,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: ColorManager.primary,
                                              fontSize: 23,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      AnimationContainerWidget(
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(30),
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: ColorManager.border,
                                            ),
                                            color: ColorManager.primary,
                                            borderRadius: BorderRadius.circular(
                                              25,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                state.infoConference.totalUser
                                                    .toString(),
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: ColorManager.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                StringsManager.totalUser,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: ColorManager.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      AnimationContainerWidget(
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(30),
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: ColorManager.border,
                                            ),
                                            color: ColorManager.primary,
                                            borderRadius: BorderRadius.circular(
                                              25,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                state.infoConference.totalSurvey
                                                    .toString(),
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: ColorManager.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                StringsManager.totalSurvey,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: ColorManager.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      AnimationContainerWidget(
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(30),
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: ColorManager.border,
                                            ),
                                            color: ColorManager.primary,
                                            borderRadius: BorderRadius.circular(
                                              25,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                state
                                                    .infoConference
                                                    .totalCompletedSurvey
                                                    .toString(),
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: ColorManager.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                StringsManager
                                                    .totalCompletedSurvey,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: ColorManager.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox();
                            }
                          },
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
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
