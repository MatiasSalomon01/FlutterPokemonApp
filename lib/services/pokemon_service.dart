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

  Future<Pokemon> getDetails(String id) async {
    print('se peticiona detalle');
    var response = await client.get(Uri.parse('$baseUrl/$id'));
    var pokemon = Pokemon.fromJson(response.toMap());

    return pokemon;
  }
}
