part of 'pokemon_bloc_bloc.dart';

@immutable
sealed class PokemonBlocEvent {}

final class PokemonBlocGetList extends PokemonBlocEvent {}

final class PokemonBlocFetchMore extends PokemonBlocEvent {}
