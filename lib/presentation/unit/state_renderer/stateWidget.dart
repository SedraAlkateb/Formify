import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:formify/presentation/unit/state_renderer/state_renderer.dart';
import 'package:formify/presentation/unit/state_renderer/state_renderer_imp.dart';
import 'package:shimmer/shimmer.dart';
Widget loadingFullScreen(BuildContext context) {
 return LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState)
      .getScreenWidget(context, SizedBox(), (){});
}
Widget errorFullScreen(BuildContext context,{Function? func,String? mes}) {
  return ErrorState(StateRendererType.fullScreenErrorState, mes??"")
      .getScreenWidget(context, SizedBox(), func??(){});
}
Widget emptyFullScreen(BuildContext context,{String ? message}) {
  return ErrorState(StateRendererType.fullScreenEmptyState,message?? "لا يوجد بيانات")
      .getScreenWidget(context, SizedBox(),(){});
}
Widget loadingShimmer(BuildContext context, int count, double? width,
    double? height, BorderRadiusGeometry? borderRadius) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          margin:  EdgeInsets.all(AppPadding.p8),
          padding:  EdgeInsets.all(AppPadding.p16),
          decoration: BoxDecoration(
            border: Border.all(color: ColorManager.darkTextSecondary),
            color: const Color.fromARGB(255, 250, 254, 255),
            borderRadius: borderRadius,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: width,
                height: height,
                color: Colors.grey[300],
              ),
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  color: Colors.grey[300],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
void error(BuildContext context, String massage, int code) {
  dismissDialog(context);
  ErrorState(StateRendererType.popupErrorState, massage)
      .showPopup(context, StateRendererType.popupErrorState, massage);
}
void loading(BuildContext context, {String? text}) {
  LoadingState(stateRendererType: StateRendererType.popupLoadingState)
      .showPopup(context, StateRendererType.popupLoadingState, "loading $text");
}
Future<bool> success(BuildContext context) async{
  try {
    ContentState().dismissDialog(context);
    return true;
  } catch (e) {
    print("ssssssssssssssssss: $e");
    return false;
  }
}
void successWithMessage(BuildContext context, String message) {
  SuccessState(message)//
      .showPopup(context, StateRendererType.popupSuccess, message);
}
Future<bool> dismissDialog(BuildContext context) async {
  try {
    if (_isCurrentDialogShowing(context)) {
      Navigator.of(context, rootNavigator: true).pop(true);
      print("Dialog dismissed successfully.");
    }
    return true;
  } catch (e) {
    print("ssssssssssssssssss: $e");
    return false;
  }
}
bool _isCurrentDialogShowing(BuildContext context) {
  return ModalRoute.of(context)?.isCurrent != true;
}
