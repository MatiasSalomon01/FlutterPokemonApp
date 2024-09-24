part of 'pokemon_bloc_bloc.dart';

@immutable
sealed class PokemonBlocState {}

final class PokemonBlocLoading extends PokemonBlocState {}

final class PokemonBlocData extends PokemonBlocState {
  final List<Pokemon> pokemons;

  PokemonBlocData({required this.pokemons});
}
