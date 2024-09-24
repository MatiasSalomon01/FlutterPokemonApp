import 'package:flutter/material.dart';
import 'package:flutter_pokemon_app/constants/pokemon_types.dart';
import 'package:shimmer/shimmer.dart';

class LoadingPokemonGrid extends StatelessWidget {
  const LoadingPokemonGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: getCrossAxisCount(constraints.maxWidth),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 12,
        itemBuilder: (_, index) => Shimmer.fromColors(
          baseColor: Colors.black12,
          highlightColor: Colors.white,
          child: Column(
            children: [
              Expanded(child: Container(color: Colors.black12)),
            ],
          ),
        ),
      ),
    );
  }
}
