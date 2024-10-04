part of 'pokemon_detail_bloc.dart';

@immutable
sealed class PokemonDetailEvent {}

final class PokemonDetailFetch extends PokemonDetailEvent {
  final String name;

  PokemonDetailFetch({required this.name});
}
