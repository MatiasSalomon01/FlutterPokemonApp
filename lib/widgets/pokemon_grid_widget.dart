import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pokemon_app/blocs/pokemon_bloc/pokemon_bloc_bloc.dart';
import 'package:flutter_pokemon_app/constants/pokemon_types.dart';
import 'package:flutter_svg/svg.dart';

import '../models/models.dart';

class PokemonGrid extends StatefulWidget {
  const PokemonGrid({super.key, required this.pokemons});
  final List<Pokemon> pokemons;

  @override
  State<PokemonGrid> createState() => _PokemonGridState();
}

class _PokemonGridState extends State<PokemonGrid> {
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()
      ..addListener(
        () {
          if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent) {
            context.read<PokemonBlocBloc>().add(PokemonBlocGetList());
          }
        },
      );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => GridView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: getCrossAxisCount(constraints.maxWidth),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          if (index < widget.pokemons.length) {
            return _PokemonCard(pokemon: widget.pokemons[index]);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
        itemCount: widget.pokemons.length,
      ),
    );
  }
}

class _PokemonCard extends StatelessWidget {
  const _PokemonCard({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: pokemon.primaryColor.withOpacity(.3),
      padding: const EdgeInsets.all(10),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '#${pokemon.id}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AspectRatio(
                aspectRatio: 1.3,
                child: SvgPicture.network(pokemon.photo),
              ),
              Text(
                pokemon.name.toUpperCase(),
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
    );
  }
}
