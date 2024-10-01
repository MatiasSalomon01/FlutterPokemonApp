import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeStateMode> {
  ThemeBloc() : super(ThemeStateMode(themeMode: ThemeMode.system)) {
    on<ThemeEventDarkMode>((event, emit) {
      emit(ThemeStateMode(themeMode: ThemeMode.dark));
    });
    on<ThemeEventLightMode>((event, emit) {
      emit(ThemeStateMode(themeMode: ThemeMode.light));
    });
  }
}
