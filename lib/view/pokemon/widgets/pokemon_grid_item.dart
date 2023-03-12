import 'package:flutter/material.dart';
import 'package:pokedex/core/context.dart';
import 'package:pokedex/core/pokemon_type.dart';
import 'package:pokedex/core/string.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/view/pokemon_info/pokemon_info.dart';

class PokemonGridItem extends StatelessWidget {
  final Future<Pokemon> pokemonF;
  const PokemonGridItem(this.pokemonF, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Pokemon>(
        future: pokemonF,
        builder: (context, state) {
          final pokemon = state.data;
          Widget children;
          if (state.hasData && pokemon != null) {
            children = GestureDetector(
              onTap: () => context.push(PokemonInfoPage(pokemon)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: getTypeColor(pokemon.baseType).withOpacity(0.35),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: ValueKey(pokemon.id),
                      child: Image.network(
                        pokemon.spriteUrl,
                        height: 120,
                        fit: BoxFit.fill,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            pokemon.pokedexId,
                          ),
                          Text(
                            pokemon.name.capitalize(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            children = const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CircularProgressIndicator(),
                  )
                ]);
          }
          return children;
        });
  }
}
