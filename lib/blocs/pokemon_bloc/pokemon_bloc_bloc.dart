import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pokemon_app/models/models.dart';
import 'package:flutter_pokemon_app/services/pokemon_service.dart';

part 'pokemon_bloc_event.dart';
part 'pokemon_bloc_state.dart';

class PokemonBlocBloc extends Bloc<PokemonBlocEvent, PokemonBlocState> {
  final PokemonService service;
  List<Pokemon> pokemons = [];

  String? next;
  PokemonBlocBloc(this.service) : super(PokemonBlocLoading()) {
    on<PokemonBlocGetList>((event, emit) async {
      var data = await service.getList(next);
      next = data.$1;
      pokemons.addAll(data.$2);
      emit(PokemonBlocData(pokemons: pokemons));
    });
  }
}
