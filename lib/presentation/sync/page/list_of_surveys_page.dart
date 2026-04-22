import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/app/constants.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/responsive/breakpoints.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';
import 'package:formify/presentation/sync/widget/header_section_widget.dart';
import 'package:formify/presentation/sync/widget/survey_card_widget.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';

class ListOfSurveysPage extends StatefulWidget {
  const ListOfSurveysPage({super.key});

  @override
  State<ListOfSurveysPage> createState() => _ListOfSurveysPageState();
}

class _ListOfSurveysPageState extends State<ListOfSurveysPage> {
  final ScrollController _controller = ScrollController();

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
          child: Column(
            children: [
              HeaderSection(),
              Expanded(
                child: BlocConsumer<SyncBloc, SyncState>(
                  listener: (context, state) {
                    if (state is FinishedSurveyState) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.finishedSurvey,
                            (route) => false,
                      );
                    }
                    if (state is InsertUserErrorState) {
                     error(context, state.failure.massage, state.failure.code);
                    }
                  },
                  buildWhen: (previous, current) =>
                  current is GetSurveyAsyncLoadingState ||
                      current is GetSurveyAsyncErrorState ||
                      current is GetSurveyAsyncState ||
                      current is SurveySubmitSuccessState,
                  builder: (context, state) {
                    if (state is GetSurveyAsyncLoadingState) {
                      return loadingFullScreen(context);
                    }
                    if (state is GetSurveyAsyncErrorState) {
                      return errorFullScreen(context);
                    }
                    if (state is GetSurveyAsyncState ||
                        state is SurveySubmitSuccessState) {
                      List<IsActiveMainSurveyModel> surveys =
                      (state is SurveySubmitSuccessState)
                          ? state.surveys
                          : (state as GetSurveyAsyncState).surveys;

                      // باستخدام LayoutBuilder لاكتشاف حجم الشاشة وتغيير طريقة العرض بناءً عليه
                      return LayoutBuilder(

                        builder: (context, constraints) {
                          final isTabletLandscape =
                          Breakpoints.isTabletLandscape(context);
                          return
                            Constants.isTablet?
                            GridView.builder(
                            controller: _controller,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // عدد الأعمدة
                              crossAxisSpacing: 0, // المسافة بين الأعمدة
                              mainAxisSpacing: 0, // المسافة بين الصفوف
                              childAspectRatio:isTabletLandscape?1.4: 1, // نسبة العرض إلى الارتفاع
                            ),
                            itemCount: surveys.length,
                            itemBuilder: (context, index) {
                              return SurveyCard(
                                survey: surveys[index],
                                index: index,
                              );
                            },
                          ):
                            ListView.builder(
                              controller: _controller,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              itemCount: surveys.length,
                              itemBuilder: (context, index) {
                                return SurveyCard(
                                  survey: surveys[index],
                                  index: index,
                                );
                              },
                            );
                        },
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/*

class ListOfSurveysPage extends StatelessWidget {
  const ListOfSurveysPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
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
          child: Column(
            children: [
              Container(
                height: 130,
                decoration: BoxDecoration(
                  color: ColorManager.white,
                  boxShadow: [
                    BoxShadow(
                      color: ColorManager.primary,
                      offset: Offset(1, 1),
                      blurStyle: BlurStyle.outer,
                      blurRadius: 2,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      BouncingIconCard(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "الاستبيانات المتاحة",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: ColorManager.primary,
                            ),
                          ),
                          Text("اختر الاستبيان الذي تود المشاركة فيه"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              BlocConsumer<SyncBloc, SyncState>(
                listener: (context, state) {
                  if(state is FinishedSurveyState){
                    Navigator.pushNamedAndRemoveUntil(context, Routes.finishedSurvey, (route) => false,);
                  }
                },
                buildWhen: (previous, current) =>
                    current is GetSurveyAsyncErrorState ||
                    current is GetSurveyAsyncLoadingState ||
                    current is GetSurveyAsyncState ||
                    current is SurveySubmitSuccessState,
                builder: (context, state) {

                  if (state is GetSurveyAsyncErrorState) {
                    return errorFullScreen(context);
                  } else if (state is GetSurveyAsyncLoadingState) {
                    return loadingFullScreen(context);
                  } else if (state is GetSurveyAsyncState ||
                      state is SurveySubmitSuccessState) {
                    List<IsActiveMainSurveyModel> surveys =[];
                    if(state is SurveySubmitSuccessState ){
                      surveys=state.surveys;
                    }
                    if(state is GetSurveyAsyncState ){
                      surveys=state.surveys;
                    }
                    return Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.builder(

                              itemBuilder: (context, index) => Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: ColorManager.primary),
                                  color: ColorManager.white,
                                  //.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.all(20),
                                margin: EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 20,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CardListUpDown(),
                                    SizedBox(height: 10),
                                    Text(
                                      surveys[index].title,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      surveys[index].description,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    SizedBox(height: 30),
                                    animatedButton(context,
                                            surveys[index].isActive==true?null:
                                            () {
                                      BlocProvider.of<SyncBloc>(context).add(
                                        GetQuestionAnswersEvent(
                                          surveys[index].id,
                                          surveys[index].title,
                                          index,
                                        ),
                                      );
                                      Navigator.pushNamed(context, Routes.surveyInput);
                                    }, "ابدأ الاستبيانات"),
                                  ],
                                ),
                              ),
                              itemCount: surveys.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                            ),
                           // (( BlocProvider.of<SyncBloc>(context).finished)==(surveys.length))?
                           //  Align(
                           //
                           //    child: Padding(
                           //      padding: const EdgeInsets.only(right: 30,bottom: 30),
                           //      child: ElevatedButton.icon(
                           //
                           //        onPressed: () {
                           //
                           //        },
                           //
                           //        icon: const Icon(Icons.arrow_forward),
                           //
                           //        iconAlignment: IconAlignment.end,
                           //        label: const Text('تم انهاء العملية بنجاح'),
                           //        style: ElevatedButton.styleFrom(
                           //
                           //          padding: const EdgeInsets.symmetric(vertical: 14,horizontal: 20),
                           //
                           //          shape: RoundedRectangleBorder(
                           //            borderRadius: BorderRadius.circular(12),
                           //          ),
                           //
                           //        ),
                           //      ),
                           //    ),
                           //    alignment: Alignment.topRight,
                           //  ):SizedBox(),
                          ],
                        ),
                      ),
                    );
                  } else
                    return SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

 */
