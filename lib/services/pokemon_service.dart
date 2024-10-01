import 'package:flutter_pokemon_app/extensions/response_extension.dart';
import 'package:flutter_pokemon_app/models/models.dart';
import 'package:http/http.dart' as client;

class PokemonService {
  final String baseUrl = "https://pokeapi.co/api/v2/pokemon?limit=1302";

  Future<(String?, List<PokemonPreview>)> getList(String? next) async {
    print('se peticiona');
    var uri = next ?? baseUrl;
    var response = await client.get(Uri.parse(uri));
    var pokemonList = PokemonList.fromJson(response.toMap());

    return (pokemonList.next, pokemonList.results);
  }
}
