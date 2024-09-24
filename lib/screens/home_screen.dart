import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pokemon_app/blocs/pokemon_bloc/pokemon_bloc_bloc.dart';
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
