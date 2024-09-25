import 'package:flutter_pokemon_app/constants/constant.dart';

class PokemonPreview {
  final String id;
  final String name;
  final String url;
  final bool isSvg;
  final String photo;

  PokemonPreview({
    required this.id,
    required this.name,
    required this.url,
    required this.isSvg,
    required this.photo,
  });

  factory PokemonPreview.fromJson(Map<String, dynamic> map) {
    var url = map["url"] as String;
    var id = int.parse(url.split('/')[6]);

    bool isEmptyPhoto = false;
    if (pokemonWithoutPhoto.contains(id)) isEmptyPhoto = true;

    bool isSvg = id < 650;

    return PokemonPreview(
      id: id.toString(),
      name: map["name"],
      url: url,
      isSvg: isSvg,
      photo: isEmptyPhoto
          ? defaultImage
          : isSvg
              ? buildSvgImageUrl(id)
              : buildPngImageUrl(id),
    );
  }

  static String buildSvgImageUrl(int id) =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/$id.svg';

  static String buildPngImageUrl(int id) =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/$id.png';
}
