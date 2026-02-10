part of 'theme_bloc.dart';

@immutable
abstract class ThemeState extends Equatable {
  final Color seedColor;
  final String colorName;

  const ThemeState({
    required this.seedColor,
    required this.colorName,
  });

  @override
  List<Object> get props => [seedColor, colorName];
}

class ThemeInitial extends ThemeState {
  ThemeInitial()
      : super(
    seedColor: ColorManager.primary,
    colorName: "0xFF3A5A75",
  );
}

class ThemeChangedState extends ThemeState {
  const ThemeChangedState({
    required Color seedColor,
    required String colorName,
  }) : super(
    seedColor: seedColor,
    colorName: colorName,
  );
}
