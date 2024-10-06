import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pokemon_app/blocs/bloc/pokemon_detail_bloc.dart';
import 'package:flutter_pokemon_app/constants/constant.dart';
import 'package:flutter_pokemon_app/models/models.dart';
import 'package:flutter_pokemon_app/services/pokemon_service.dart';
import 'package:flutter_svg/svg.dart';
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
          surfaceTintColor: Colors.transparent,
          // elevation: 0,
        ),
        body: BlocBuilder<PokemonDetailBloc, PokemonDetailState>(
          builder: (context, state) {
            if (state is PokemonDetailLoading) {
              return const Center(child: CircularProgressIndicator());
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
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: size.height * .4,
            child: Stack(
              children: [
                SizedBox(
                  height: size.height * .35,
                  child: CustomPaint(
                    painter: Background(color: pokemon.types[0].color),
                    child: Container(),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset(
                    'assets/pokeball.svg',
                    colorFilter: ColorFilter.mode(
                        Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(.3),
                        BlendMode.srcIn),
                  ),
                ),
                ImageCarousel(
                  id: pokemon.id.toString(),
                  images: pokemon.images,
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    pokemon.name.toUpperCase(),
                    style: GoogleFonts.bebasNeue(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            constraints: BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: pokemon.types
                      .map(
                        (type) => Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: Theme(
                            data: ThemeData(
                              highlightColor: Colors.transparent,
                              splashFactory: NoSplash.splashFactory,
                            ),
                            child: FilterChip(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 8,
                              ),
                              avatar: Image.asset('assets/types/${type.badge}'),
                              avatarBoxConstraints:
                                  const BoxConstraints(maxWidth: 20),
                              shape: const StadiumBorder(side: BorderSide.none),
                              // onSelected: null,
                              onSelected: (value) {},
                              labelPadding: const EdgeInsets.only(left: 5),
                              label: Text(type.name),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                TextAndLanguageSelector(texts: pokemon.descriptions),
                const SizedBox(height: 10),
                const Divider(
                  indent: 20,
                  endIndent: 20,
                ),
                const SizedBox(height: 10),
                MiddleInfo(pokemon: pokemon),
                const SizedBox(height: 10),
                const Divider(
                  indent: 20,
                  endIndent: 20,
                ),
                const SizedBox(height: 10),
                StatsSection(stats: pokemon.stats),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icons.next
                if (pokemon.evolution!.hasPrevious)
                  ElevatedButton(
                      onPressed: () {
                        context.read<PokemonDetailBloc>().add(
                              PokemonDetailFetch(
                                  name: pokemon.evolution!.previousUrl),
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
          const SizedBox(height: 20)
        ],
      ),
    );
  }
}

class StatsSection extends StatelessWidget {
  const StatsSection({super.key, required this.stats});

  final Stats stats;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Estadisticas',
          style: GoogleFonts.bebasNeue(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 10),
        Stat(
          name: 'HP',
          value: stats.hpValue,
          color: Colors.green,
        ),
        Stat(
          name: 'ATK',
          value: stats.attackValue,
          color: Colors.red,
        ),
        Stat(
          name: 'DEF',
          value: stats.defenseValue,
          color: Colors.blue,
        ),
        Stat(
          name: 'SATK',
          value: stats.specialAttackValue,
          color: Colors.red.shade900,
        ),
        Stat(
          name: 'SDEF',
          value: stats.specialDefenseValue,
          color: Colors.blue.shade900,
        ),
        Stat(
          name: 'VEL',
          value: stats.speedValue,
          color: Colors.amber,
        ),
      ],
    );
  }
}

class Stat extends StatelessWidget {
  const Stat({
    super.key,
    required this.name,
    required this.value,
    required this.color,
  });

  final String name;
  final int value;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            // color: Colors.amber,
            width: 35, // Ajusta este valor según el ancho máximo del nombre
            child: Text(
              name,
              textAlign: TextAlign.end,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            '  |  ',
            style: GoogleFonts.montserrat(
              fontSize: 15,
              // fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$value',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 15),
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 2,
                  activeTrackColor: color,
                  inactiveTrackColor: color.withOpacity(.3),
                  thumbShape: SliderComponentShape.noThumb,
                  overlayShape: SliderComponentShape.noOverlay,
                ),
                child: Slider(
                  max: 255,
                  value: value.toDouble(),
                  onChanged: (value) {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MiddleInfo extends StatelessWidget {
  const MiddleInfo({
    super.key,
    required this.pokemon,
  });

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(
                'Peso',
                style: GoogleFonts.bebasNeue(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              Text(
                '${pokemon.weight} kg',
                style: GoogleFonts.montserrat(fontSize: 15),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                'Altura',
                style: GoogleFonts.bebasNeue(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              Text(
                '${pokemon.height} m',
                style: GoogleFonts.montserrat(fontSize: 15),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                'Habilidad',
                style: GoogleFonts.bebasNeue(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              Text(
                pokemon.ability,
                style: GoogleFonts.montserrat(fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TextAndLanguageSelector extends StatefulWidget {
  const TextAndLanguageSelector({super.key, required this.texts});

  final List<String> texts;

  @override
  State<TextAndLanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<TextAndLanguageSelector> {
  int currentValue = 0;
  @override
  Widget build(BuildContext context) {
    var dropdown = DropdownButton(
      padding: const EdgeInsets.only(left: 10, top: 0, bottom: 0),
      menuWidth: 90,
      borderRadius: BorderRadius.circular(8),
      underline: Container(),
      value: currentValue,
      onChanged: (value) => setState(() => currentValue = value!),
      // style: TextStyle(
      //   fontSize: 15,
      // ),
      items: const [
        DropdownMenuItem(
          value: 0,
          child: Text('Español'),
        ),
        DropdownMenuItem(
          value: 1,
          child: Text('Ingles'),
        ),
        DropdownMenuItem(
          value: 2,
          child: Text('Frances'),
        ),
      ],
    );

    var text = Text(
      widget.texts[currentValue],
      maxLines: 7,
      style: GoogleFonts.montserrat(fontSize: 15),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 400) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [dropdown, text],
          );
        } else {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text,
              const SizedBox(width: 10),
              dropdown,
            ],
          );
        }
      },
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
          child: Container(
            alignment: Alignment.centerRight,
            child: MaterialButton(
              onPressed: () => scrollController.previousPage(
                  duration: const Duration(milliseconds: 1),
                  curve: Curves.linear),
              padding: EdgeInsets.zero,
              minWidth: 30,
              shape: const CircleBorder(),
              highlightElevation: 0,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: const Icon(Icons.arrow_back_ios_rounded, size: 16),
            ),
          ),
        ),
        // SizedBox(width: 5),
        Expanded(
          flex: 2,
          child: Container(
            // color: Colors.amber,
            constraints: const BoxConstraints(maxHeight: 220),
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
            child: MaterialButton(
              onPressed: () => scrollController.nextPage(
                  duration: const Duration(milliseconds: 1),
                  curve: Curves.linear),
              padding: EdgeInsets.zero,
              minWidth: 30,
              shape: const CircleBorder(),
              highlightElevation: 0,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            ),
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
        size.width < 1000 ? size.height * .6 : size.height * .65;
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
