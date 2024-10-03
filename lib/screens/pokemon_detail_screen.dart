import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pokemon_app/blocs/pokemon_bloc/pokemon_bloc_bloc.dart';
import 'package:flutter_pokemon_app/constants/constant.dart';
import 'package:flutter_pokemon_app/models/models.dart';
import 'package:flutter_pokemon_app/services/pokemon_service.dart';

class PokemonDetailsScreen extends StatelessWidget {
  final String id;
  const PokemonDetailsScreen({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PokemonBlocBloc(PokemonService())
        ..add(
          PokemonBlocFetchDetails(id: id),
        ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: BlocBuilder<PokemonBlocBloc, PokemonBlocState>(
          builder: (context, state) {
            if (state is PokemonBlocLoading) {
              return const CircularProgressIndicator();
            }
            if (state is PokemonBlocPokemonDetails) {
              return _Header(pokemon: state.pokemon);
            }

            return const Text('Error de detalle :(');
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      // color: Colors.amber,
      height: size.height,
      width: size.width,
      child: Column(
        children: [
          Container(
            // color: Colors.red,
            height: size.height * .4,
            width: size.width,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                SizedBox(
                  height: size.height * .3,
                  width: size.width,
                  child: CustomPaint(
                    painter: Background(color: pokemon.primaryColor),
                  ),
                ),
                Container(
                  // color: Colors.red,
                  margin: EdgeInsets.only(top: size.height * .1),
                  constraints: const BoxConstraints(maxWidth: 350),
                  child: ImageCarousel(
                    id: pokemon.id.toString(),
                    images: pokemon.images,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ImageCarousel extends StatefulWidget {
  const ImageCarousel({
    super.key,
    required this.id,
    required this.images,
  });

  final String id;
  final List<String> images;
  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late final PageController scrollController;
  @override
  void initState() {
    super.initState();
    scrollController = PageController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              scrollController.previousPage(
                  duration: const Duration(milliseconds: 1),
                  curve: Curves.linear);
            },
            style: const ButtonStyle(
              shape: WidgetStatePropertyAll(CircleBorder()),
              padding: WidgetStatePropertyAll(EdgeInsets.zero),
            ),
            child: const FittedBox(child: Icon(Icons.arrow_back_ios_rounded)),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          flex: 5,
          child: PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return SizedBox(
                child: pokemonPicture(
                  widget.id.toString(),
                  widget.images[index],
                  boxFit: BoxFit.contain,
                  placeholder: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
              onPressed: () {
                scrollController.nextPage(
                    duration: const Duration(milliseconds: 1),
                    curve: Curves.linear);
              },
              style: const ButtonStyle(
                shape: WidgetStatePropertyAll(CircleBorder()),
                padding: WidgetStatePropertyAll(EdgeInsets.zero),
              ),
              child: const FittedBox(
                  child: Icon(Icons.arrow_forward_ios_rounded))),
        ),
      ],
    );
  }
}

class Background extends CustomPainter {
  final Color color;

  Background({super.repaint, required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    double heightControl =
        size.width < 500 ? size.height * .8 : size.height * .6;

    var path = Path()
      ..lineTo(0, heightControl)
      ..quadraticBezierTo(
          size.width * .2, size.height, size.width * .5, size.height)
      ..quadraticBezierTo(
          size.width * .8, size.height, size.width, heightControl)
      ..lineTo(size.width, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
