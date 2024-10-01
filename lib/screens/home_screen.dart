import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pokemon_app/blocs/pokemon_bloc/pokemon_bloc_bloc.dart';
import 'package:flutter_pokemon_app/blocs/theme_bloc/theme_bloc.dart';
import 'package:flutter_pokemon_app/services/pokemon_service.dart';

import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PokemonBlocBloc(PokemonService())..add(PokemonBlocGetList()),
      lazy: false,
      child: Scaffold(
        appBar: AppBar(
          actions: const [
            ThemeButtons(),
            SizedBox(width: 10),
          ],
        ),
        body: BlocBuilder<PokemonBlocBloc, PokemonBlocState>(
          builder: (context, state) {
            if (state is PokemonBlocLoading) {
              return const LoadingPokemonGrid();
            }

            if (state is PokemonBlocData) {
              return PokemonGrid(pokemons: state.pokemons);
            }

            return const Text('Error al recuperar pokemones :(');
          },
        ),
      ),
    );
  }
}

class ThemeButtons extends StatefulWidget {
  const ThemeButtons({super.key});

  @override
  _ThemeButtonsState createState() => _ThemeButtonsState();
}

class _ThemeButtonsState extends State<ThemeButtons> {
  bool isLightMode = true;

  Border setBorder() {
    if (context.watch<ThemeBloc>().state.themeMode == ThemeMode.light) {
      return Border.all(color: Colors.black, width: .5);
    } else {
      return Border.all(color: Colors.white, width: .5);
    }
  }

  Color setColor() {
    if (context.watch<ThemeBloc>().state.themeMode == ThemeMode.light) {
      return Colors.yellow;
    } else {
      return Colors.indigo;
    }
  }

  @override
  Widget build(BuildContext context) {
    isLightMode = context.watch<ThemeBloc>().state.themeMode == ThemeMode.light;
    return Container(
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: setBorder(),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: isLightMode ? 0 : 50,
            top: 0,
            bottom: 0,
            child: Container(
              width: 50,
              decoration: BoxDecoration(
                  color: setColor(),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      isLightMode = true; // Cambiar el estado
                    });
                    context.read<ThemeBloc>().add(
                        ThemeEventLightMode()); // Enviar evento de light mode
                  },
                  icon: const Icon(Icons.light_mode),
                ),
              ),
              // Botón de modo oscuro
              Expanded(
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      isLightMode = false; // Cambiar el estado
                    });
                    context.read<ThemeBloc>().add(
                        ThemeEventDarkMode()); // Enviar evento de dark mode
                  },
                  icon: const Icon(Icons.dark_mode),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
