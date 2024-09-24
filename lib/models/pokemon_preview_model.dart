class PokemonPreview {
  final String name;
  final String url;

  PokemonPreview({required this.name, required this.url});

  factory PokemonPreview.fromJson(Map<String, dynamic> map) {
    return PokemonPreview(name: map["name"], url: map["url"]);
  }
}
