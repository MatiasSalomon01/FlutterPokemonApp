import 'package:flutter_pokemon_app/extensions/response_extension.dart';
import 'package:flutter_pokemon_app/models/models.dart';
import 'package:http/http.dart' as client;

class PokemonService {
  final String baseUrl = "https://pokeapi.co/api/v2/pokemon";

  Future<(String?, List<PokemonPreview>)> getList(String? next) async {
    print('se peticiona listado');
    var uri = next ?? '$baseUrl?limit=1302';
    var response = await client.get(Uri.parse(uri));
    var pokemonList = PokemonList.fromJson(response.toMap());

    return (pokemonList.next, pokemonList.results);
  }

  Future<Pokemon> getDetails(String name) async {
    print('se peticiona detalle');
    var response = await client.get(Uri.parse('$baseUrl/$name'));
    var pokemon = Pokemon.fromJson(response.toMap());

    var data = await getEvolution(pokemon.name, pokemon.speciesUrl);
    pokemon.evolution = data.$1;
    pokemon.description = data.$2;
    return pokemon;
  }

  Future<(Evolution, String)> getEvolution(
      String name, String speciesUrl) async {
    print('se peticiona evoluciones');

    List<String> evolutions = [];
    String description = '';

    var response = await client.get(Uri.parse(speciesUrl));

    var evolutionUrl = response.toMap()['evolution_chain']['url'] as String;
    var response2 = await client.get(Uri.parse(evolutionUrl));

    var map = response.toMap();
    var map2 = response2.toMap();

    description = (map['flavor_text_entries'] as List)
        .map((e) {
          if (e['language']['name'] != 'en') {
            return '';
          }
          return (e['flavor_text'] as String).replaceAll('\n', ' ');
        })
        .toSet()
        .join(" ");

    var chain = map2['chain'];
    evolutions.add(chain['species']['name']);

    for (var element1 in chain['evolves_to'] as List) {
      evolutions.add(element1['species']['name']);
      for (var element2 in element1['evolves_to'] as List) {
        evolutions.add(element2['species']['name']);
        for (var element3 in element2['evolves_to'] as List) {
          evolutions.add(element3['species']['name']);
          for (var element4 in element3['evolves_to'] as List) {
            evolutions.add(element4['species']['name']);
          }
        }
      }
    }

    var currentIndex = evolutions.indexOf(name);

    bool hasPrevious = currentIndex > 0;
    bool hasNext = currentIndex < evolutions.length - 1;

    String previousUrl = hasPrevious ? evolutions[currentIndex - 1] : '';

    String nextUrl = hasNext ? evolutions[currentIndex + 1] : '';

    return (
      Evolution(
        hasPrevious: hasPrevious,
        previousUrl: previousUrl,
        hasNext: hasNext,
        nextUrl: nextUrl,
      ),
      description
    );
  }
}

class Evolution {
  final bool hasPrevious;
  final String previousUrl;
  final bool hasNext;
  final String nextUrl;

  Evolution({
    this.hasPrevious = false,
    this.previousUrl = '',
    this.hasNext = false,
    this.nextUrl = '',
  });

  @override
  String toString() {
    return '$hasPrevious - $previousUrl - $hasNext - $nextUrl';
  }
}
