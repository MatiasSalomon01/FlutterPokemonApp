import 'models.dart';

class PokemonList {
  final int count;
  final String? next;
  final List<PokemonPreview> results;

  PokemonList({required this.count, required this.next, required this.results});

  factory PokemonList.fromJson(Map<String, dynamic> map) {
    return PokemonList(
        count: map["count"],
        next: map["next"],
        results: (map["results"] as List)
            .map((e) => PokemonPreview.fromJson(e))
            .toList());
  }
}
