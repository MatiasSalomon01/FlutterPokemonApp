import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pokemon_app/blocs/bloc/pokemon_detail_bloc.dart';
import 'package:flutter_pokemon_app/blocs/pokemon_bloc/pokemon_bloc_bloc.dart';
import 'package:flutter_pokemon_app/constants/constant.dart';
import 'package:flutter_pokemon_app/models/models.dart';
import 'package:flutter_pokemon_app/services/pokemon_service.dart';
import 'package:google_fonts/google_fonts.dart';

class PokemonDetailsScreen extends StatelessWidget {
  final String name;
  const PokemonDetailsScreen({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PokemonDetailBloc(PokemonService())
        ..add(PokemonDetailFetch(name: name)),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: BlocBuilder<PokemonDetailBloc, PokemonDetailState>(
          builder: (context, state) {
            if (state is PokemonBlocLoading) {
              return const CircularProgressIndicator();
            }
            if (state is PokemonDetailSuccess) {
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
    // print(pokemon.description);
    return Container(
      // color: Colors.amber,
      height: size.height,
      width: size.width,
      // margin: EdgeInsets.symmetric(horizontal: size.width * .1),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              // color: Colors.red,
              // height: size.height * .35,
              // width: size.width,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    height: size.height * .30,
                    // width: size.width,
                    // constraints: BoxConstraints(maxHeight: size.height * .35),
                    child: CustomPaint(
                      painter: Background(color: pokemon.types[0].color),
                      child: Container(
                        width: size.width,
                        // color: Colors.red,
                        // alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Icons.next
                            if (pokemon.evolution!.hasPrevious)
                              ElevatedButton(
                                  onPressed: () {
                                    context.read<PokemonDetailBloc>().add(
                                          PokemonDetailFetch(
                                              name: pokemon
                                                  .evolution!.previousUrl),
                                        );
                                  },
                                  child: const Text('Anterior')),
                            if (pokemon.evolution!.hasNext) ...[
                              const Spacer(),
                              ElevatedButton(
                                  onPressed: () {
                                    context.read<PokemonDetailBloc>().add(
                                          PokemonDetailFetch(
                                              name: pokemon.evolution!.nextUrl),
                                        );
                                  },
                                  child: const Text('Siguiente')),
                            ]
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    // color: Colors.red.withOpacity(.5),
                    // padding: const EdgeInsets.only(top: 70),
                    // constraints: BoxConstraints(maxHeight: size.height * .35),
                    height: size.height * .4,
                    alignment: Alignment.bottomCenter,
                    child: ImageCarousel(
                      id: pokemon.id.toString(),
                      images: pokemon.images,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: size.width * .8,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: ,
                children: [
                  FittedBox(
                    child: Text(
                      pokemon.name.toUpperCase(),
                      style: GoogleFonts.bebasNeue(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  Container(
                    // margin: EdgeInsets.only(top: size.height * .4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: pokemon.types
                          .map(
                            (type) => Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: FilterChip(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                    horizontal: 8,
                                  ),
                                  avatar: Image.asset(
                                    'assets/types/${type.badge}',
                                  ),
                                  avatarBoxConstraints:
                                      const BoxConstraints(maxWidth: 20),
                                  shape: const StadiumBorder(
                                      side: BorderSide.none),
                                  onSelected: (value) {},
                                  labelPadding: const EdgeInsets.only(left: 5),
                                  label: Text(type.name)),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Text(pokemon.description)
                ],
              ),
            ),
          ],
        ),
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
      // mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
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
        ),
        // SizedBox(width: 5),
        Expanded(
          child: Container(
            // color: Colors.amber,
            alignment: Alignment.bottomCenter,
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
        ),
        // SizedBox(width: 5),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
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
    var gradient = LinearGradient(
      transform: const GradientRotation(7),
      colors: [color, color.withOpacity(.05)],
      // begin: Alignment.topLeft,
      // end: Alignment.bottomRight,
    );

    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..shader =
          gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    double heightControl =
        size.width < 1000 ? size.height * .5 : size.height * .65;
    double height = size.width < 1000 ? size.height * .8 : size.height;

    //     double widthControl =
    // size.width < 600 ? size.height * .3 : size.height * .65;

    var path = Path()
      ..lineTo(0, heightControl)
      ..quadraticBezierTo(size.width * .2, height, size.width * .5, height)
      ..quadraticBezierTo(size.width * .8, height, size.width, heightControl)
      ..lineTo(size.width, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
