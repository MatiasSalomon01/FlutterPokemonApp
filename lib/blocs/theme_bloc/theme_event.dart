part of 'theme_bloc.dart';

@immutable
sealed class ThemeEvent {}

final class ThemeEventLightMode extends ThemeEvent {}

final class ThemeEventDarkMode extends ThemeEvent {}
