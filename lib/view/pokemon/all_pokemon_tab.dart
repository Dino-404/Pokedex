import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/view/pokemon/pokemon_list.dart';
import 'package:pokedex/view/pokemon/widgets/pokemon_grid_item.dart';

class AllPokemonTab extends StatefulWidget {
  const AllPokemonTab({Key? key}) : super(key: key);
  @override
  State<AllPokemonTab> createState() => _AllPokemonTabState();
}

class _AllPokemonTabState extends State<AllPokemonTab> {
  final scrollController = ScrollController();
  PokemonList pokemonList = PokemonList();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() => paginate());
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void paginate() {
    if ((scrollController.position.pixels ==
        scrollController.position.maxScrollExtent)) {
      pokemonList.morePokemons().whenComplete(() {
        setState(() {
          context;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pokemon>>(
        future: pokemonList.getListPokemon(),
        builder: (context, state) {
          final pokemons = state.data;
          Widget children;
          if (state.hasData && pokemons != null && pokemons.isNotEmpty) {
            children = Expanded(
              child: GridView.builder(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisExtent: 200,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: pokemons.length,
                itemBuilder: (context, index) => PokemonGridItem(
                  pokemonList.getPokemon(pokemons[index].id),
                ),
              ),
            );
          } else {
            children = const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [children],
          );
        });
  }
}
