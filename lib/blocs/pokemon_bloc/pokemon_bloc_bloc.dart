import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pokemon_app/models/models.dart';
import 'package:flutter_pokemon_app/services/pokemon_service.dart';

part 'pokemon_bloc_event.dart';
part 'pokemon_bloc_state.dart';

class PokemonBlocBloc extends Bloc<PokemonBlocEvent, PokemonBlocState> {
  final PokemonService service;
  List<PokemonPreview> pokemons = [];

  String? next;
  bool fetchMore = true;

  PokemonBlocBloc(this.service) : super(PokemonBlocLoading()) {
    on<PokemonBlocGetList>((event, emit) async {
      if (fetchMore) {
        var data = await service.getList(next);
        next = data.$1;
        pokemons.addAll(data.$2);
        emit(PokemonBlocData(pokemons: pokemons));
      }

      if (next == null) fetchMore = false;
    });

    on<PokemonBlocSearchPokemon>((event, emit) async {
      if (event.q.isNotEmpty) {
        var results = pokemons
            .where((element) =>
                element.name.toLowerCase().contains(event.q.toLowerCase()))
            .toList();
        emit(PokemonBlocData(pokemons: results));
      } else {
        emit(PokemonBlocData(pokemons: pokemons));
      }
    });
  }
}
