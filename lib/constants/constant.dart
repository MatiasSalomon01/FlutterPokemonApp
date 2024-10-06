import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

class Types {
  final String name;
  final Color color;
  final String badge;

  Types({required this.name, required this.color, required this.badge});
}

Map<String, Types> pokemonTypes = {
  'normal': Types(
    name: 'Normal',
    color: const Color(0xffA8A77A),
    badge: 'normal.png',
  ),
  'fire': Types(
    name: 'Fuego',
    color: const Color(0xffEE8130),
    badge: 'fire.png',
  ),
  'water': Types(
    name: 'Agua',
    color: const Color(0xff6390F0),
    badge: 'water.png',
  ),
  'electric': Types(
    name: 'Electrico',
    color: const Color(0xffF7D02C),
    badge: 'electric.png',
  ),
  'grass': Types(
    name: 'Planta',
    color: const Color(0xff7AC74C),
    badge: 'grass.png',
  ),
  'ice': Types(
    name: 'Hielo',
    color: const Color(0xff96D9D6),
    badge: 'ice.png',
  ),
  'fighting': Types(
    name: 'Lucha',
    color: const Color(0xffC22E28),
    badge: 'fighting.png',
  ),
  'poison': Types(
    name: 'Veneno',
    color: const Color(0xffA33EA1),
    badge: 'poison.png',
  ),
  'ground': Types(
    name: 'ground',
    color: const Color(0xffE2BF65),
    badge: 'ground.png',
  ),
  'flying': Types(
    name: 'Volador',
    color: const Color(0xffA98FF3),
    badge: 'flying.png',
  ),
  'psychic': Types(
    name: 'Psiquico',
    color: const Color(0xffF95587),
    badge: 'psychic.png',
  ),
  'bug': Types(
    name: 'Bicho',
    color: const Color(0xffA6B91A),
    badge: 'bug.png',
  ),
  'rock': Types(
    name: 'Roca',
    color: const Color(0xffB6A136),
    badge: 'rock.png',
  ),
  'ghost': Types(
    name: 'Fantasma',
    color: const Color(0xff735797),
    badge: 'ghost.png',
  ),
  'dragon': Types(
    name: 'Dragon',
    color: const Color(0xff6F35FC),
    badge: 'dragon.png',
  ),
  'dark': Types(
    name: 'Siniestro',
    color: const Color(0xff705746),
    badge: 'dark.png',
  ),
  'steel': Types(
    name: 'Acero',
    color: const Color(0xffB7B7CE),
    badge: 'steel.png',
  ),
  'fairy': Types(
    name: 'Hada',
    color: const Color(0xffD685AD),
    badge: 'fairy.png',
  ),
  "stellar": Types(
    name: "Estelar",
    color: Colors.blueGrey,
    badge: 'normal.png',
  ),
  "unknown": Types(
    name: "Desconocido",
    color: Colors.black26,
    badge: 'normal.png',
  ),
  "shadow": Types(
    name: "Sombra",
    color: Colors.black54,
    badge: 'normal.png',
  ),
};

int getCrossAxisCount(double width) {
  if (width > 1600) return 6;
  if (width > 1300) return 5;
  if (width > 1000) return 4;
  if (width > 600) return 3;
  return 2;
}

const String defaultImage =
    'https://res.cloudinary.com/dowuc5zob/image/upload/v1727883759/pokebola_ziwqt6.png';

var pokemonWithoutPhoto = [
  10061,
  10080,
  10081,
  10082,
  10083,
  10084,
  10085,
  10144,
  10151,
  10158,
  10159,
  10182,
  10183,
  10187,
  10192,
  10264,
  10265,
  10266,
  10267,
  10268,
  10269,
  10270,
  10271
];

var lodingText = Shimmer.fromColors(
  baseColor: Colors.black,
  highlightColor: Colors.white,
  child: const Center(child: Text('Cargando imagen...')),
);

Widget pokemonPicture(String id, String photo,
    {BoxFit? boxFit, Widget placeholder = const SizedBox()}) {
  bool isSvg = photo.endsWith('.svg');
  return Hero(
    tag: id,
    child: isSvg
        ? SvgPicture.network(
            photo,
            placeholderBuilder: (context) => lodingText,
          )
        : CachedNetworkImage(
            imageUrl: photo,
            fit: boxFit,
            fadeInDuration: Duration.zero,
            fadeOutDuration: Duration.zero,
            placeholderFadeInDuration: Duration.zero,
            placeholder: (context, url) => placeholder,
          ),
  );
}
