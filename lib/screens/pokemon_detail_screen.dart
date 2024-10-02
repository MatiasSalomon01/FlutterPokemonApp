import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    var size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => PokemonBlocBloc(PokemonService())
        ..add(
          PokemonBlocFetchDetails(id: id),
        ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: BlocBuilder<PokemonBlocBloc, PokemonBlocState>(
          builder: (context, state) {
            if (state is PokemonBlocLoading) {
              return const CircularProgressIndicator();
            }
            if (state is PokemonBlocPokemonDetails) {
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  SizedBox(
                    height: size.height * .3,
                    width: size.width,
                    child: CustomPaint(
                      painter: Background(color: state.pokemon.primaryColor),
                    ),
                  ),
                  ImageCarousel(pokemon: state.pokemon),
                ],
              );
            }

            return const Text('Error de detalle :(');
          },
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ImageCarousel extends StatefulWidget {
  const ImageCarousel({
    super.key,
    required this.pokemon,
  });

  final Pokemon pokemon;
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
    var size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            scrollController.previousPage(
                duration: const Duration(milliseconds: 200),
                curve: Curves.linear);
          },
          style: const ButtonStyle(
            shape: WidgetStatePropertyAll(CircleBorder()),
            padding: WidgetStatePropertyAll(EdgeInsets.zero),
          ),
          child: const Icon(Icons.arrow_back_ios_rounded),
        ),
        SizedBox(
          height: size.height * .45,
          width: size.width * .4,
          child: PageView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.pokemon.images.length,
              itemBuilder: (context, index) {
                bool isSvg = index == 0;
                var image = widget.pokemon.images[index];
                var isGif = image.endsWith('.gif');
                double multiply = isGif ? 1 : .25;
                return SizedBox(
                  height: size.height * multiply,
                  width: size.height * multiply,
                  child: pokemonPicture(
                    widget.pokemon.id.toString(),
                    isSvg,
                    image,
                    BoxFit.contain,
                  ),
                );
              }),
        ),
        ElevatedButton(
            onPressed: () {
              scrollController.nextPage(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.linear);
            },
            style: const ButtonStyle(
              shape: WidgetStatePropertyAll(CircleBorder()),
              padding: WidgetStatePropertyAll(EdgeInsets.zero),
            ),
            child: const Icon(Icons.arrow_forward_ios_rounded)),
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

    var path = Path()
      ..lineTo(0, size.height * .6)
      ..quadraticBezierTo(
          size.width * .2, size.height, size.width * .5, size.height)
      ..quadraticBezierTo(
          size.width * .8, size.height, size.width, size.height * .6)
      ..lineTo(size.width, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
