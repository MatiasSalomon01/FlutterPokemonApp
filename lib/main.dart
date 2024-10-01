import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pokemon_app/blocs/theme_bloc/theme_bloc.dart';
import 'package:flutter_pokemon_app/screens/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeStateMode>(
        builder: (context, state) => MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: state.themeMode,
          theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
            iconButtonTheme: const IconButtonThemeData(
              style: ButtonStyle(
                iconColor: WidgetStatePropertyAll(Colors.black87),
                overlayColor: WidgetStatePropertyAll(Colors.transparent),
                splashFactory: NoSplash.splashFactory,
              ),
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
            iconButtonTheme: const IconButtonThemeData(
              style: ButtonStyle(
                iconColor: WidgetStatePropertyAll(Colors.white70),
                overlayColor: WidgetStatePropertyAll(Colors.transparent),
                splashFactory: NoSplash.splashFactory,
              ),
            ),
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
