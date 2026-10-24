import 'package:flutter/material.dart';
import 'package:formify/presentation/unit/state_renderer/state_renderer.dart';
import 'package:formify/presentation/unit/state_renderer/state_renderer_imp.dart';

export 'package:formify/presentation/unit/state_renderer/state_renderer.dart'
    show StateTexts;

// ─────────────────────────── Full screen states ───────────────────────────

/// حالة التحميل بملء الشاشة (Skeleton).
Widget loadingFullScreen(BuildContext context) => const StateRenderer(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );

/// حالة الخطأ بملء الشاشة. يظهر زر «إعادة المحاولة» فقط إذا مُرّرت [func].
Widget errorFullScreen(BuildContext context, {Function? func, String? mes}) {
  return StateRenderer(
    stateRendererType: StateRendererType.fullScreenErrorState,
    message: mes ?? '',
    retryActionFunction: func == null ? null : () => func(),
  );
}

/// حالة عدم وجود بيانات. يظهر زر «إعادة المحاولة» فقط إذا مُرّرت [onRefresh].
Widget emptyFullScreen(
  BuildContext context, {
  String? message,
  VoidCallback? onRefresh,
}) {
  return StateRenderer(
    stateRendererType: StateRendererType.fullScreenEmptyState,
    message: message ?? StateTexts.empty,
    retryActionFunction: onRefresh,
  );
}

/// مؤشر تحميل صغير (داخل زر أو بطاقة) بدلاً من CircularProgressIndicator المتفرقة.
Widget loadingInline({Color? color, double size = 22}) {
  return SizedBox(
    width: size,
    height: size,
    child: CircularProgressIndicator(strokeWidth: 2.4, color: color),
  );
}

Widget loadingShimmer(
  BuildContext context,
  int count,
  double? width,
  double? height,
  BorderRadiusGeometry? borderRadius,
) => loadingFullScreen(context);

// ───────────────────────────── Popup states ───────────────────────────────

void error(BuildContext context, String massage, int code) {
  PopupManager.show(context, StateRendererType.popupErrorState, massage);
}

void loading(BuildContext context, {String? text}) {
  PopupManager.show(
    context,
    StateRendererType.popupLoadingState,
    text ?? StateTexts.loading,
  );
}

void successWithMessage(BuildContext context, String message) {
  PopupManager.show(context, StateRendererType.popupSuccess, message);
}

/// يغلق نافذة التحميل (إن وُجدت) بعد نجاح العملية.
Future<bool> success(BuildContext context) async {
  PopupManager.dismiss();
  return true;
}

Future<bool> dismissDialog(BuildContext context) async {
  PopupManager.dismiss();
  return true;
}
