part of 'theme_bloc.dart';

@immutable
sealed class ThemeState {}

final class ThemeStateMode extends ThemeState {
  final ThemeMode themeMode;

  ThemeStateMode({required this.themeMode});
}
