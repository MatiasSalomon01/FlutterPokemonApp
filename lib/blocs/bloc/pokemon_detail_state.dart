part of 'pokemon_detail_bloc.dart';

@immutable
sealed class PokemonDetailState {}

final class PokemonDetailLoading extends PokemonDetailState {}

final class PokemonDetailSuccess extends PokemonDetailState {
  final Pokemon pokemon;

  PokemonDetailSuccess({required this.pokemon});
}
