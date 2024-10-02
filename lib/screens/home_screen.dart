import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pokemon_app/blocs/pokemon_bloc/pokemon_bloc_bloc.dart';
import 'package:flutter_pokemon_app/blocs/theme_bloc/theme_bloc.dart';
import 'package:flutter_pokemon_app/models/models.dart';
import 'package:flutter_pokemon_app/services/pokemon_service.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PokemonBlocBloc(PokemonService())..add(PokemonBlocGetList()),
      lazy: false,
      child: Scaffold(
        appBar: AppBar(
          title: LayoutBuilder(
            builder: (context, constraints) => Row(
              children: [
                if (constraints.maxWidth > 400) ...[
                  Image.network(
                    'https://res.cloudinary.com/dowuc5zob/image/upload/v1727881049/Pok%C3%A9dex_logo_nrtwbu.png',
                    height: 55,
                  ),
                  const SizedBox(width: 10),
                ],
                const Expanded(flex: 2, child: SearchTextField()),
                // Spacer()
              ],
            ),
          ),
          actions: const [
            ThemeButtons(),
            SizedBox(width: 10),
          ],
        ),
        body: BlocBuilder<PokemonBlocBloc, PokemonBlocState>(
          buildWhen: (previous, current) =>
              current != PokemonBlocPokemonDetails ||
              current != PokemonBlocDetailsLoading,
          builder: (context, state) {
            if (state is PokemonBlocLoading) {
              return const LoadingPokemonGrid();
            }

            if (state is PokemonBlocData) {
              return PokemonGrid(pokemons: state.pokemons);
            }

            return const Text('Error al recuperar pokemones :(');
          },
        ),
      ),
    );
  }
}

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var bloc = context.read<PokemonBlocBloc>();

    return TypeAheadField<PokemonSearchResult>(
      emptyBuilder: (_) => const SizedBox(),
      errorBuilder: (_, __) => const SizedBox(),
      itemBuilder: (_, __) => const SizedBox(),
      onSelected: (_) {},
      suggestionsCallback: (search) {
        bloc.add(PokemonBlocSearchPokemon(q: search));
        return [];
      },
      builder: (context, controller, focusNode) => TextFormField(
        controller: controller,
        focusNode: focusNode,
        style: const TextStyle(fontSize: 14),
        cursorColor: setColor(context),
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              onPressed: () => controller.text = '',
              icon: const Icon(Icons.close),
            ),
            constraints: const BoxConstraints(maxWidth: 1000),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            isCollapsed: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: setBorder(context),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: setBorder(context),
            ),
            labelText: 'Buscar pokemones',
            labelStyle: TextStyle(fontSize: 14, color: setColor(context))),
      ),
    );
  }

  Color setColor(BuildContext context) {
    if (context.watch<ThemeBloc>().state.themeMode == ThemeMode.light) {
      return Colors.black87;
    } else {
      return Colors.white70;
    }
  }

  BorderSide setBorder(BuildContext context) {
    if (context.watch<ThemeBloc>().state.themeMode == ThemeMode.light) {
      return const BorderSide(color: Colors.black, width: .5);
    } else {
      return const BorderSide(color: Colors.white, width: .5);
    }
  }
}

class ThemeButtons extends StatefulWidget {
  const ThemeButtons({super.key});

  @override
  _ThemeButtonsState createState() => _ThemeButtonsState();
}

class _ThemeButtonsState extends State<ThemeButtons> {
  bool isLightMode = true;

  Border setBorder() {
    if (context.watch<ThemeBloc>().state.themeMode == ThemeMode.light) {
      return Border.all(color: Colors.black, width: .5);
    } else {
      return Border.all(color: Colors.white, width: .5);
    }
  }

  Color setColor() {
    if (context.watch<ThemeBloc>().state.themeMode == ThemeMode.light) {
      return Colors.yellow;
    } else {
      return Colors.indigo;
    }
  }

  @override
  Widget build(BuildContext context) {
    isLightMode = context.watch<ThemeBloc>().state.themeMode == ThemeMode.light;
    return Container(
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: setBorder(),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: isLightMode ? 0 : 50,
            top: 0,
            bottom: 0,
            child: Container(
              width: 50,
              decoration: BoxDecoration(
                  color: setColor(),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      isLightMode = true; // Cambiar el estado
                    });
                    context.read<ThemeBloc>().add(
                        ThemeEventLightMode()); // Enviar evento de light mode
                  },
                  icon: const Icon(Icons.light_mode),
                ),
              ),
              // Botón de modo oscuro
              Expanded(
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      isLightMode = false; // Cambiar el estado
                    });
                    context.read<ThemeBloc>().add(
                        ThemeEventDarkMode()); // Enviar evento de dark mode
                  },
                  icon: const Icon(Icons.dark_mode),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
