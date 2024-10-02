import 'package:flutter/material.dart';
import 'package:flutter_pokemon_app/constants/constant.dart';

class Pokemon {
  final int id;
  final String name;
  final List<String> images;
  final Color primaryColor;

  Pokemon(
      {required this.id,
      required this.name,
      required this.images,
      required this.primaryColor});

  factory Pokemon.fromJson(Map<String, dynamic> map) {
    var images = map["sprites"]["other"];

    var urls = [
      images["dream_world"]["front_default"] as String?,
      images["home"]['front_default'] as String?,
      images["official-artwork"]['front_default'] as String?,
      images['showdown']['front_default'] as String?
    ].where((element) => element != null).map((e) => e!).toList();

    if (urls.isEmpty) urls.add(defaultImage);

    return Pokemon(
        id: map["id"],
        name: map["name"],
        images: urls,
        primaryColor: pokemonTypes[map["types"][0]["type"]["name"]]!);
  }
}
