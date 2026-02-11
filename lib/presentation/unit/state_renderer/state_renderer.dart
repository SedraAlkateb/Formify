
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:formify/presentation/resources/assets_manager.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/font_manager.dart';
import 'package:formify/presentation/resources/style_manage.dart';
import 'package:formify/presentation/resources/values_manager.dart';
import 'package:lottie/lottie.dart';

enum StateRendererType{
///popup states (dialog)

  popupLoadingState,
  popupErrorState,
 popupSuccess,
  /// full screen stated (full screen)
  fullScreenLoadingState,
  fullScreenErrorState,
  fullScreenEmptyState,
/// general
  contentState
}
class StateRenderer extends StatelessWidget {
 final StateRendererType stateRendererType;
  final String message;
  final String title;
 final  Function retryActionFunction;

  StateRenderer(
      {
        required  this.stateRendererType,
        required this.message,
        this.title="",
        required this.retryActionFunction});
  @override
  Widget build(BuildContext context) {
    return _getStateWidget(context);
  }
  Widget _getStateWidget(BuildContext context){
    switch(stateRendererType){
      case StateRendererType.popupLoadingState:
        return _getPopupDialog(context,[_getAnimatedImage(JsonAssets.loading1)]);
      case StateRendererType.popupSuccess:
        return _getPopupDialog(context,[
          _getAnimatedImage(JsonAssets.suc2),
          _getMessage(message),
          _getRetryButton("موافق",context)
        ]);
      case StateRendererType.popupErrorState:
        return _getPopupDialog(context,[
            _getAnimatedImage(JsonAssets.error),
            _getMessage(message),
            _getRetryButton("موافق",context)
        ]);
      case StateRendererType.fullScreenLoadingState:
      return _getItemsColumn([_getAnimatedImage(JsonAssets.loading2)]);
      case StateRendererType.fullScreenErrorState:
        return _getItemsColumn(
            [
              _getAnimatedImage(JsonAssets.error),
              _getMessage(message),
              _getRetryButton("retry again",context)
            ]
        );
      case StateRendererType.fullScreenEmptyState:
        return _getItemsColumn([
          _getAnimatedImage(JsonAssets.empty1),
          _getMessage(message)
        ]);
      case StateRendererType.contentState:
      return Container();
    }
  }
Widget _getItemsColumn(List<Widget>children){
 return Center(
   child: Column(
     mainAxisAlignment: MainAxisAlignment.center,
     crossAxisAlignment: CrossAxisAlignment.center,
     children: children,
   ),
 );
}
Widget _getAnimatedImage(String animationName){
    return SizedBox(
      height: AppSize.s200,
      width: AppSize.s200,
      child:Lottie.asset(animationName )
    );
}
Widget _getMessage(String? message){
    return Center(
      child: Padding(
        padding:  EdgeInsets.all(AppPadding.p8),
        child: Text(
          message??"",
          style: getRegularStyle(
              color: ColorManager.black,
            fontSize: FontSize.s18
          )
          ,
        ),
      ),
    );
}
Widget _getRetryButton(String buttonTitle,BuildContext context){

  return Padding(
    padding:  EdgeInsets.all(AppPadding.p18),
    child: SizedBox(
      width: double.infinity,

    child:  ElevatedButton(
        // style: ButtonStyle(
        //   //
        //   // backgroundColor:
        //   // MaterialStateProperty.all(ColorManager.primary),
        // ),
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.primary, // لون الخلفية
          foregroundColor: Colors.white,          // لون النص
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        onPressed: (){
      if(stateRendererType==StateRendererType.fullScreenErrorState){
        retryActionFunction.call();
      }else{
        //popup error state
        Navigator.of(context).pop();
      }
    },
        child: Text(buttonTitle)),

    ),
  );
  }
Widget _getPopupDialog(BuildContext context,List<Widget> children){
    return  WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s14),

        ),
        elevation: AppSize.s1_5,
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: ColorManager.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(AppSize.s14),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26
              )
            ]
          ),
          child: _getDialogContent(context,children) ,
        ),
      ),
    );
}
Widget  _getDialogContent (BuildContext context,List<Widget>children){
  return Column(
    mainAxisSize: MainAxisSize.min,
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: children,
  );
}
getMessage(String ){

}
}

