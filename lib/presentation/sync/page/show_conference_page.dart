import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/app/app_preferences.dart';
import 'package:formify/app/di.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/conference/widget/conferm_dialog.dart';
import 'package:formify/presentation/resources/assets_manager.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';
import 'package:formify/presentation/sync/widget/button_widget.dart';
import 'package:formify/presentation/sync/widget/doforma_container_widget.dart';
import 'package:formify/presentation/sync/widget/press_scale.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';
import 'package:lottie/lottie.dart';

class ShowConferencePage extends StatefulWidget {
  const ShowConferencePage({super.key});

  @override
  State<ShowConferencePage> createState() => _ShowConferencePageState();
}

class _ShowConferencePageState extends State<ShowConferencePage> {
  @override
  void initState() {
    BlocProvider.of<SyncBloc>(context).add(GetConferenceAsyncEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
            child: BlocBuilder<SyncBloc, SyncState>(
              buildWhen: (previous, current) =>
              current is GetConferenceAsyncLoadingState ||
                  current is AsyncConferenceErrorState ||
                  current is GetConferenceAsyncState ||
                  current is GetConferenceAsyncEmptyState,
              builder: (context, state) {
                if (state is GetConferenceAsyncLoadingState) {
                  return loadingFullScreen(context);
                } else if (state is AsyncConferenceErrorState) {
                  return errorFullScreen(context);
                } else if (state is GetConferenceAsyncState) {
                  instance<AppPreferences>().setLoggedIn(2);
                  GetAllConferenceModel conferenceModel = state.conferenceModel;

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        FloatingContainer(),
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
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  conferenceModel.name,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: ColorManager.primary,
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  conferenceModel.description,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: ColorManager.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),

                                // Address
                                InteractiveAddressCard(
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    margin: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: ColorManager.border),
                                      color: ColorManager.primaryShadow.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Row(
                                      children: [
                                        Card(
                                          margin: const EdgeInsets.all(5),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          color: ColorManager.primary,
                                          child: const Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Icon(
                                              Icons.location_on_outlined,
                                              color: Color(0xffffffff),
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "العنوان",
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    color: ColorManager.textSecondary,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  conferenceModel.address,
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    color: ColorManager.black,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                      ],
                                    ),
                                  ),
                                ),

                                // Date
                                InteractiveAddressCard(
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    margin: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: ColorManager.border),
                                      color: ColorManager.primaryShadow.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Row(
                                      children: [
                                        Card(
                                          margin: const EdgeInsets.all(5),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          color: ColorManager.primary,
                                          child: const Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Icon(
                                              Icons.date_range_sharp,
                                              color: Color(0xffffffff),
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "التاريخ",
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    color: ColorManager.textSecondary,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "تاريخ البدء: ${conferenceModel.startDate}",
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    color: ColorManager.black,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "تاريخ الانتهاء: ${conferenceModel.endDate}",
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    color: ColorManager.black,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                      ],
                                    ),
                                  ),
                                ),

                                Column(
                                  children: [
                                    animatedButton(
                                      context,
                                          () {
                                        Navigator.pushNamed(context, Routes.insertUser);
                                      },
                                      "ابدأ الاستبيانات",
                                    ),
                                    const SizedBox(height: 10),
                                    animatedButton(
                                      context,
                                          () {
                                        BlocProvider.of<SyncBloc>(context)
                                            .add(GetInfoConferenceEvent());
                                        Navigator.pushNamed(
                                          context,
                                          Routes.settingPage,
                                          arguments: conferenceModel.id,
                                        );
                                      },
                                      "إعدادات المؤتمر",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is GetConferenceAsyncEmptyState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      emptyFullScreen(context),
                      const SizedBox(height: 100),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            Routes.home,
                                (route) => false,
                          );
                        },
                        child: const Text("العودة إلى الرئيسية"),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}