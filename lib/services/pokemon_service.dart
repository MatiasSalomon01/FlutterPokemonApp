import 'package:flutter_pokemon_app/extensions/response_extension.dart';
import 'package:flutter_pokemon_app/models/models.dart';
import 'package:http/http.dart' as client;

class PokemonService {
  final String baseUrl = "https://pokeapi.co/api/v2/pokemon?limit=18";

  Future<(String, List<PokemonPreview>)> getList(String? next) async {
    var uri = next ?? baseUrl;
    var response = await client.get(Uri.parse(uri));
    var pokemonList = PokemonList.fromJson(response.toMap());

    // List<Pokemon> pokemons = [];
    // for (var result in pokemonList.results) {
    //   var response = await client.get(Uri.parse(result.url));
    //   pokemons.add(Pokemon.fromJson(response.toMap()));
    // }

    return (pokemonList.next, pokemonList.results);
  }

  Future<bool> checkIfSvgExists(String url) async {
    try {
      final response = await client.get(Uri.parse(url));
      print(response.statusCode);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
