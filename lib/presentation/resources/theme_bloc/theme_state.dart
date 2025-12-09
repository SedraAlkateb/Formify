part of 'theme_bloc.dart';

@immutable
abstract class ThemeState extends Equatable{

  const ThemeState();
}

/// الحالة الافتراضية (لون أساسي أولّي)
class ThemeInitial extends ThemeState {
  ThemeInitial() : super();

  @override
  List<Object?> get props => [];
}

/// عند تغيير اللون
class ThemeChangedState extends ThemeState {
  final Color color;
  const ThemeChangedState(this.color) ;

  @override
  List<Object?> get props => [color];
}
