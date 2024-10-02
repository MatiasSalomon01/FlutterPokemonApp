part of 'pokemon_bloc_bloc.dart';

@immutable
sealed class PokemonBlocEvent {}

final class PokemonBlocGetList extends PokemonBlocEvent {}

final class PokemonBlocFetchMore extends PokemonBlocEvent {}

final class PokemonBlocFetchDetails extends PokemonBlocEvent {
  final String id;

  PokemonBlocFetchDetails({required this.id});
}

final class PokemonBlocSearchPokemon extends PokemonBlocEvent {
  final String q;

  PokemonBlocSearchPokemon({required this.q});
}
