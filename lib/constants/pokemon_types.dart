import 'package:flutter/material.dart';

const Map<String, Color> pokemonTypes = {
  "normal": Color(0xffA0A2A0),
  "fighting": Color(0xffFF8100),
  "flying": Color(0xff82BAF0),
  "poison": Color(0xff923FCC),
  "ground": Color(0xff92501B),
  "rock": Color(0xffB0AB82),
  "bug": Color(0xff92A212),
  "ghost": Color(0xff713F71),
  "steel": Color(0xff60A2B9),
  "fire": Color(0xffE72324),
  "water": Color(0xff2481F0),
  "grass": Color(0xff3DA224),
  "electric": Color(0xffFAC100),
  "psychic": Color(0xffEF3F7A),
  "ice": Color(0xff3DD9FF),
  "dragon": Color(0xff4F60E2),
  "dark": Color(0xff4F3F3D),
  "fairy": Color(0xffEF71F0),
  "stellar": Colors.blueGrey,
  "unknown": Colors.black26,
  "shadow": Colors.black54,
};

int getCrossAxisCount(double width) {
  if (width > 1600) return 6;
  if (width > 1300) return 5;
  if (width > 1000) return 4;
  if (width > 600) return 3;
  return 2;
}
