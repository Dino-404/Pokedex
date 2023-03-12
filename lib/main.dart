import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/view/pokemon/all_pokemon_tab.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PokemonAdapter());
  Hive.registerAdapter(PokemonNameAndUrlDatumAdapter());
  Hive.registerAdapter(PokemonStatAdapter());
  Hive.registerAdapter(PokemonTypeAdapter());
  runApp(const PokedexApp());
}

class PokedexApp extends StatelessWidget {
  const PokedexApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Pokedex",
        home: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Image.asset(
                "assets/pokemon_logo.png",
                height: 32,
              )),
          body: const AllPokemonTab(),
        ));
  }
}
