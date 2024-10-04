import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pokemon_app/models/pokemon_model.dart';
import 'package:flutter_pokemon_app/services/pokemon_service.dart';

part 'pokemon_detail_event.dart';
part 'pokemon_detail_state.dart';

class PokemonDetailBloc extends Bloc<PokemonDetailEvent, PokemonDetailState> {
  final PokemonService service;
  PokemonDetailBloc(this.service) : super(PokemonDetailLoading()) {
    on<PokemonDetailFetch>((event, emit) async {
      final pokemon = await service.getDetails(event.name);
      emit(PokemonDetailSuccess(pokemon: pokemon));
    });
  }
}
