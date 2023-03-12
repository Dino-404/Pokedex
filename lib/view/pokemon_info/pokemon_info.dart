import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/core/context.dart';
import 'package:pokedex/core/pokemon_type.dart';
import 'package:pokedex/core/string.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/view/pokemon/pokemon_list.dart';
import 'package:pokedex/view/pokemon_info/widgets/pokemon_stats_item.dart';

class PokemonInfoPage extends StatefulWidget {
  final Pokemon pokemon;
  const PokemonInfoPage(this.pokemon, {Key? key}) : super(key: key);

  @override
  State<PokemonInfoPage> createState() => _PokemonInfoPageState();
}

class _PokemonInfoPageState extends State<PokemonInfoPage> {
  late ScrollController scrollController;
  PokemonList pokemonList = PokemonList();
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()
      ..addListener(() {
        setState(() {});
      });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });
  }

  bool get isAppBarExpanded {
    return scrollController.hasClients &&
        scrollController.offset > (200 - kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    Pokemon pokemon = widget.pokemon;
    return Scaffold(
      body: CustomScrollView(controller: scrollController, slivers: [
        SliverAppBar(
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              CupertinoIcons.chevron_back,
              color: Colors.black,
            ),
          ),
          pinned: true,
          elevation: 0,
          expandedHeight: 220,
          backgroundColor: isAppBarExpanded
              ? getTypeColor(pokemon.baseType)
              : getTypeColor(pokemon.baseType).withOpacity(0.6),
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: false,
            titlePadding: const EdgeInsets.only(
              left: 6,
              bottom: 6,
            ),
            title: AnimatedPadding(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding:
                  EdgeInsets.only(left: isAppBarExpanded ? 40 : 0, bottom: 6),
              child: Text(pokemon.name.capitalize(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 27,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ),
            background: FlexibleBackground(pokemon),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...pokemon.types.map(
                          (type) => Container(
                            margin: const EdgeInsets.all(5),
                            alignment: Alignment.center,
                            width: 100,
                            height: 30,
                            decoration: BoxDecoration(
                                color: getTypeColor(type.type.name)
                                    .withOpacity(0.7),
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              type.type.name.capitalize(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Altura",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF6B6B6B),
                                ),
                              ),
                              Text(
                                "${pokemon.height / 10} m",
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Peso",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF6B6B6B),
                                ),
                              ),
                              Text(
                                "${pokemon.weight / 10} kg",
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const ColoredBox(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Estadísticas base",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 0.5,
              ),
              ...pokemon.stats.map((stat) => PokemonStatItem(stat)),
            ],
          ),
        )
      ]),
    );
  }
}

class FlexibleBackground extends StatelessWidget {
  final Pokemon pokemon;
  const FlexibleBackground(this.pokemon, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Positioned(
          right: 24,
          child: Hero(
              tag: ValueKey(pokemon.id),
              child: Image.network(
                pokemon.imageUrl,
                height: 170,
              )),
        ),
        Positioned(
          left: 6,
          top: kToolbarHeight * 2,
          right: context.getWidth(0.5),
          bottom: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pokemon.pokedexId,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 27,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        )
      ],
    );
  }
}
