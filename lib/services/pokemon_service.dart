import 'package:flutter_pokemon_app/extensions/response_extension.dart';
import 'package:flutter_pokemon_app/models/models.dart';
import 'package:http/http.dart' as client;

class PokemonService {
  final String baseUrl = "https://pokeapi.co/api/v2/pokemon?limit=18";

  Future<(String?, List<PokemonPreview>)> getList(String? next) async {
    var uri = next ?? baseUrl;
    var response = await client.get(Uri.parse(uri));
    var pokemonList = PokemonList.fromJson(response.toMap());

    return (pokemonList.next, pokemonList.results);
  }
}
