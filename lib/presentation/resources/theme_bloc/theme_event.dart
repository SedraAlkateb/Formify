part of 'theme_bloc.dart';

@immutable
abstract class ThemeEvent  extends Equatable{}

/// تغيير اللون الأساسي للتطبيق
class ChangeThemeColorEvent extends ThemeEvent {
  final Color newColor;
  final String colorName;
  ChangeThemeColorEvent(this.newColor,this.colorName);

  @override
  List<Object?> get props => [];
}
