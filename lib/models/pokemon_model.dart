import 'package:flutter/material.dart';
import 'package:flutter_pokemon_app/constants/constant.dart';

class Pokemon {
  final int id;
  final String name;
  final String photo;
  final Color primaryColor;

  Pokemon(
      {required this.id,
      required this.name,
      required this.photo,
      required this.primaryColor});

  factory Pokemon.fromJson(Map<String, dynamic> map) {
    return Pokemon(
        id: map["id"],
        name: map["name"],
        photo: map["sprites"]["other"]["dream_world"]["front_default"],
        primaryColor: pokemonTypes[map["types"][0]["type"]["name"]]!);
  }
}
