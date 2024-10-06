import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pokemon_app/blocs/pokemon_bloc/pokemon_bloc_bloc.dart';
import 'package:flutter_pokemon_app/blocs/theme_bloc/theme_bloc.dart';
import 'package:flutter_pokemon_app/constants/constant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../models/models.dart';
import '../screens/pokemon_detail_screen.dart';

class PokemonGrid extends StatefulWidget {
  const PokemonGrid({super.key, required this.pokemons});
  final List<PokemonPreview> pokemons;

  @override
  State<PokemonGrid> createState() => _PokemonGridState();
}

class _PokemonGridState extends State<PokemonGrid> {
  late final ScrollController scrollController;
  late final FocusNode node;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()
      ..addListener(
        () {
          if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100) {
            context.read<PokemonBlocBloc>().add(PokemonBlocGetList());
          }
        },
      );
    node = FocusNode()..requestFocus();
  }

  @override
  void dispose() {
    node.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => KeyboardListener(
        focusNode: node,
        autofocus: true,
        onKeyEvent: (value) {
          if (value is KeyDownEvent) {
            if (value.logicalKey.keyLabel == 'Home') {
              scrollController.jumpTo(0);
            }

            if (value.logicalKey.keyLabel == 'End') {
              scrollController
                  .jumpTo(scrollController.position.maxScrollExtent);
            }

            if (value.logicalKey.keyLabel == 'Page Up') {
              double newScrollPosition =
                  (scrollController.position.pixels - 840)
                      .clamp(0.0, scrollController.position.maxScrollExtent);
              scrollController.animateTo(
                newScrollPosition,
                duration: const Duration(milliseconds: 100),
                curve: Curves.linear,
              );
            }

            if (value.logicalKey.keyLabel == 'Page Down') {
              double newScrollPosition =
                  (scrollController.position.pixels + 840)
                      .clamp(0.0, scrollController.position.maxScrollExtent);
              scrollController.animateTo(
                newScrollPosition,
                duration: const Duration(milliseconds: 100),
                curve: Curves.linear,
              );
            }
          }
        },
        child: GridView.builder(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: getCrossAxisCount(constraints.maxWidth),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: widget.pokemons.length,
          itemBuilder: (context, index) {
            return _PokemonCard(pokemon: widget.pokemons[index]);
          },
        ),
      ),
    );
  }

  List<Shimmer> getMore() {
    return List.generate(
      10,
      (index) => Shimmer.fromColors(
        baseColor: Colors.black12,
        highlightColor: Colors.white,
        child: Column(
          children: [
            Expanded(child: Container(color: Colors.black12)),
          ],
        ),
      ),
    );
  }
}

class _PokemonCard extends StatelessWidget {
  const _PokemonCard({super.key, required this.pokemon});

  final PokemonPreview pokemon;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PokemonDetailsScreen(name: pokemon.name),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: setBorder(context),
            gradient: LinearGradient(
              colors: setLinearGradient(context),
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            // color: Colors.grey.shade300
          ),
          padding: const EdgeInsets.all(8),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    // shape: BoxShape.circle,
                    borderRadius: BorderRadius.circular(10),
                    color: setColor(context),
                  ),
                  child: Text(
                    pokemon.id,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        fontFamily: 'PokemonSolid',
                        letterSpacing: 5),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AspectRatio(
                    aspectRatio: 1.4,
                    child: pokemonPicture(
                      pokemon.id,
                      pokemon.photo,
                      placeholder: lodingText,
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      pokemon.name.toUpperCase(),
                      style: GoogleFonts.bebasNeue(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Color> setLinearGradient(BuildContext context) {
    if (context.watch<ThemeBloc>().state.themeMode == ThemeMode.light) {
      return [Colors.grey.shade300, Colors.grey.shade100];
    } else {
      return [Colors.black, Colors.grey.shade900];
    }
  }

  Color setColor(BuildContext context) {
    if (context.watch<ThemeBloc>().state.themeMode == ThemeMode.light) {
      return Colors.grey.shade100;
    } else {
      return Colors.grey.shade900;
    }
  }

  Border setBorder(BuildContext context) {
    if (context.watch<ThemeBloc>().state.themeMode == ThemeMode.light) {
      return Border.all(color: Colors.black, width: .5);
    } else {
      return Border.all(color: Colors.grey, width: .5);
    }
  }
}
