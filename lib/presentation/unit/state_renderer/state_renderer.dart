import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:formify/presentation/resources/assets_manager.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/font_manager.dart';
import 'package:formify/presentation/resources/style_manage.dart';
import 'package:formify/presentation/resources/values_manager.dart';

enum StateRendererType {
  /// popup states (dialog)
  popupLoadingState,
  popupErrorState,
  popupSuccess,

  /// full screen states
  fullScreenLoadingState,
  fullScreenErrorState,
  fullScreenEmptyState,

  /// general
  contentState,
}

/// النصوص الافتراضية الموحدة لكل الحالات.
class StateTexts {
  static const String loading = 'جاري التحميل...';
  static const String errorTitle = 'حدث خطأ';
  static const String errorFallback =
      'تعذر إكمال العملية، يرجى المحاولة مرة أخرى';
  static const String empty = 'لا توجد بيانات';
  static const String retry = 'إعادة المحاولة';
  static const String ok = 'موافق';
  static const String success = 'تمت العملية بنجاح';
}

/// يرسم كل حالات (loading / error / empty / success) بشكل موحد في كل التطبيق.
class StateRenderer extends StatelessWidget {
  final StateRendererType stateRendererType;
  final String message;
  final String title;
  final VoidCallback? retryActionFunction;

  const StateRenderer({
    super.key,
    required this.stateRendererType,
    this.message = '',
    this.title = '',
    this.retryActionFunction,
  });

  @override
  Widget build(BuildContext context) {
    switch (stateRendererType) {
      case StateRendererType.popupLoadingState:
        return _PopupCard(
          children: [
            _StateAnimation(JsonAssets.loading1, size: AppSize.s100),
            _StateMessage(message.isEmpty ? StateTexts.loading : message),
          ],
        );
      case StateRendererType.popupSuccess:
        return _PopupCard(
          children: [
            _StateAnimation(JsonAssets.suc),
            _StateMessage(message.isEmpty ? StateTexts.success : message),
            _StateButton(
              label: StateTexts.ok,
              onPressed: () =>
                  Navigator.of(context, rootNavigator: true).pop(),
            ),
          ],
        );
      case StateRendererType.popupErrorState:
        return _PopupCard(
          children: [
            _StateAnimation(JsonAssets.error),
            _StateTitle(title.isEmpty ? StateTexts.errorTitle : title),
            _StateMessage(message.isEmpty ? StateTexts.errorFallback : message),
            _StateButton(
              label: StateTexts.ok,
              onPressed: () =>
                  Navigator.of(context, rootNavigator: true).pop(),
            ),
          ],
        );
      case StateRendererType.fullScreenLoadingState:
        return const _ShimmerList();
      case StateRendererType.fullScreenErrorState:
        return _FullScreenBody(
          children: [
            _StateAnimation(JsonAssets.error),
            _StateTitle(title.isEmpty ? StateTexts.errorTitle : title),
            _StateMessage(message.isEmpty ? StateTexts.errorFallback : message),
            if (retryActionFunction != null)
              _StateButton(
                label: StateTexts.retry,
                icon: Icons.refresh_rounded,
                onPressed: retryActionFunction!,
              ),
          ],
        );
      case StateRendererType.fullScreenEmptyState:
        return _FullScreenBody(
          children: [
            _StateAnimation(JsonAssets.empty1),
            _StateMessage(message.isEmpty ? StateTexts.empty : message),
            if (retryActionFunction != null)
              _StateButton(
                label: StateTexts.retry,
                icon: Icons.refresh_rounded,
                onPressed: retryActionFunction!,
              ),
          ],
        );
      case StateRendererType.contentState:
        return const SizedBox.shrink();
    }
  }
}

/// جسم الحالة بملء الشاشة: يتوسط عند وجود ارتفاع محدد ويتصرف بأمان
/// عند وضعه داخل Column أو SliverToBoxAdapter (ارتفاع غير محدد).
class _FullScreenBody extends StatelessWidget {
  final List<Widget> children;
  const _FullScreenBody({required this.children});

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: EdgeInsets.all(AppPadding.p16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.hasBoundedHeight) {
          return Center(child: SingleChildScrollView(child: content));
        }
        return Center(child: content);
      },
    );
  }
}

class _PopupCard extends StatelessWidget {
  final List<Widget> children;
  const _PopupCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s14),
        ),
        elevation: AppSize.s1_5,
        backgroundColor: ColorManager.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppPadding.p8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}

class _StateAnimation extends StatelessWidget {
  final String asset;
  final double? size;
  const _StateAnimation(this.asset, {this.size});

  @override
  Widget build(BuildContext context) {
    final s = size ?? AppSize.s200;
    return SizedBox(
      height: s,
      width: s,
      child: Lottie.asset(
        asset,
        // لا نترك الشاشة فارغة إذا فشل تحميل ملف الأنيميشن
        errorBuilder: (_, __, ___) => Icon(
          Icons.info_outline_rounded,
          size: s / 2,
          color: ColorManager.darkTextSecondary,
        ),
      ),
    );
  }
}

class _StateTitle extends StatelessWidget {
  final String text;
  const _StateTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.p8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: getBoldStyle(color: ColorManager.black, fontSize: FontSize.s18),
      ),
    );
  }
}

class _StateMessage extends StatelessWidget {
  final String text;
  const _StateMessage(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppPadding.p8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: getRegularStyle(color: Colors.black87, fontSize: FontSize.s16),
      ),
    );
  }
}

class _StateButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  const _StateButton({required this.label, required this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(
      backgroundColor: ColorManager.primary,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
    );
    return Padding(
      padding: EdgeInsets.all(AppPadding.p12),
      child: icon == null
          ? ElevatedButton(
              style: style,
              onPressed: onPressed,
              child: Text(label),
            )
          : ElevatedButton.icon(
              style: style,
              onPressed: onPressed,
              icon: Icon(icon, size: 20),
              label: Text(label),
            ),
    );
  }
}

/// هيكل تحميل (Skeleton) موحد للقوائم.
class _ShimmerList extends StatelessWidget {
  const _ShimmerList();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            6,
            (_) => Container(
              width: double.infinity,
              height: 80,
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
