import 'package:flutter_pokemon_app/constants/constant.dart';
import 'package:flutter_pokemon_app/services/pokemon_service.dart';

class Pokemon {
  final int id;
  final String name;
  final List<String> images;
  final List<Types> types;
  final String speciesUrl;
  Evolution? evolution;
  List<String> descriptions = [];
  final double weight;
  final double height;
  String ability = '';
  Pokemon({
    required this.id,
    required this.name,
    required this.images,
    required this.types,
    required this.speciesUrl,
    this.evolution,
    required this.weight,
    required this.height,
  });

  factory Pokemon.fromJson(Map<String, dynamic> map) {
    var images = map["sprites"]["other"];

    var urls = [
      images["dream_world"]["front_default"] as String?,
      images["home"]['front_default'] as String?,
      images["official-artwork"]['front_default'] as String?,
      images['showdown']['front_default'] as String?,
      images['showdown']['back_default'] as String?
    ].where((element) => element != null).map((e) => e!).toList();

    if (urls.isEmpty) urls.add(defaultImage);

    return Pokemon(
        id: map["id"],
        name: map["name"],
        images: urls,
        // pokemonTypes[map["types"][0]["type"]["name"]]!
        types: (map["types"] as List)
            .map((e) => pokemonTypes[e["type"]["name"]]!)
            .toList(),
        speciesUrl: map['species']['url'],
        evolution: Evolution(),
        weight: (map['weight'] as int) / 10,
        height: (map['height'] as int) / 10);
  }
}
