part of 'pokemon_bloc_bloc.dart';

@immutable
sealed class PokemonBlocState {}

final class PokemonBlocLoading extends PokemonBlocState {}

final class PokemonBlocDetailsLoading extends PokemonBlocState {}

final class PokemonBlocData extends PokemonBlocState {
  final List<PokemonPreview> pokemons;

  PokemonBlocData({required this.pokemons});
}

final class PokemonBlocSearchResult extends PokemonBlocState {
  final List<PokemonSearchResult> results;

  PokemonBlocSearchResult({required this.results});
}

final class PokemonBlocPokemonDetails extends PokemonBlocState {
  final Pokemon pokemon;

  PokemonBlocPokemonDetails({required this.pokemon});
}
