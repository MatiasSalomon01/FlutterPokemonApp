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
  final Stats stats;
  Pokemon({
    required this.id,
    required this.name,
    required this.images,
    required this.types,
    required this.speciesUrl,
    this.evolution,
    required this.weight,
    required this.height,
    required this.stats,
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
      height: (map['height'] as int) / 10,
      stats: Stats(
        hp: map['stats'][0]['stat']['name'],
        hpValue: map['stats'][0]['base_stat'],
        attack: map['stats'][1]['stat']['name'],
        attackValue: map['stats'][1]['base_stat'],
        defense: map['stats'][2]['stat']['name'],
        defenseValue: map['stats'][2]['base_stat'],
        specialAttack: map['stats'][3]['stat']['name'],
        specialAttackValue: map['stats'][3]['base_stat'],
        specialDefense: map['stats'][4]['stat']['name'],
        specialDefenseValue: map['stats'][4]['base_stat'],
        speed: map['stats'][5]['stat']['name'],
        speedValue: map['stats'][5]['base_stat'],
      ),
    );
  }
}

class Stats {
  final String hp;
  final int hpValue;
  final String attack;
  final int attackValue;
  final String defense;
  final int defenseValue;
  final String specialAttack;
  final int specialAttackValue;
  final String specialDefense;
  final int specialDefenseValue;
  final String speed;
  final int speedValue;

  Stats({
    required this.hp,
    required this.hpValue,
    required this.attack,
    required this.attackValue,
    required this.defense,
    required this.defenseValue,
    required this.specialAttack,
    required this.specialAttackValue,
    required this.specialDefense,
    required this.specialDefenseValue,
    required this.speed,
    required this.speedValue,
  });
}
