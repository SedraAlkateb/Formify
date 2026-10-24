import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:formify/presentation/unit/state_renderer/state_renderer.dart';

/// يدير نافذة الحالة المنبثقة (loading / error / success) بحيث:
///  - لا تظهر أكثر من نافذة واحدة في نفس الوقت (الجديدة تستبدل القديمة).
///  - لا نغلق أبداً صفحة عادية بالخطأ: نغلق فقط النافذة التي فتحناها نحن.
class PopupManager {
  PopupManager._();

  static bool _isShowing = false;
  static NavigatorState? _navigator;
  static Object? _token;

  static bool get isShowing => _isShowing;

  static void show(
    BuildContext context,
    StateRendererType type,
    String message, {
    String title = '',
  }) {
    _runSafely(() {
      if (!context.mounted) return;
      _show(context, type, message, title);
    });
  }

  static void _show(
    BuildContext context,
    StateRendererType type,
    String message,
    String title,
  ) {
    dismiss();
    final navigator = Navigator.of(context, rootNavigator: true);
    final token = Object();
    _token = token;
    _navigator = navigator;
    _isShowing = true;
    navigator
        .push(
          DialogRoute<void>(
            context: navigator.context,
            barrierDismissible: false,
            builder: (_) => StateRenderer(
              stateRendererType: type,
              message: message,
              title: title,
            ),
          ),
        )
        .whenComplete(() {
          // لا نلمس الحالة إذا كانت نافذة أحدث قد حلّت مكان هذه
          if (identical(_token, token)) {
            _isShowing = false;
            _navigator = null;
            _token = null;
          }
        });
  }

  /// يغلق النافذة المنبثقة الحالية فقط إن وُجدت.
  static void dismiss() => _runSafely(_dismissNow);

  /// تعديل الـ Navigator أثناء مرحلة البناء يرمي استثناء، لذا نؤجله لما بعد الإطار.
  static void _runSafely(VoidCallback action) {
    final phase = SchedulerBinding.instance.schedulerPhase;
    if (phase == SchedulerPhase.persistentCallbacks ||
        phase == SchedulerPhase.midFrameMicrotasks) {
      SchedulerBinding.instance.addPostFrameCallback((_) => action());
    } else {
      action();
    }
  }

  static void _dismissNow() {
    if (!_isShowing) return;
    final navigator = _navigator;
    _isShowing = false;
    _navigator = null;
    _token = null;
    if (navigator != null && navigator.mounted) {
      navigator.pop();
    }
  }
}
