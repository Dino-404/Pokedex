import 'package:dio/dio.dart';
import 'package:pokedex/core/http_manager.dart';

import 'package:pokedex/core/remote_api.dart';
import 'package:pokedex/models/pokemon.dart';

class PokemonList {
  int _offset = 0;
  late List<Pokemon> pokemonList = [];
  late RemoteApi pokemonRepository;

  PokemonList() {
    final dio = Dio();
    final http = HttpManager(dio: dio);
    pokemonRepository = RemoteApi(http);
    getPokemons();
  }

  get pokedexRepository => pokemonRepository;
  Future<List<Pokemon>> getListPokemon() {
    if (_offset != 0) {
      return Future(() => pokemonList);
    }
    return pokemonRepository.getAllPokemon(_offset);
  }

  Future<void> getPokemons() async {
    await pokemonRepository
        .getAllPokemon(_offset)
        .then((value) => pokemonList.addAll(value));
  }

  Future<void> morePokemons() async {
    _offset += 24;
    await pokemonRepository
        .getAllPokemon(_offset)
        .then((value) => pokemonList.addAll(value));
  }

  Future<Pokemon> getPokemon(int id) async {
    return await pokemonRepository.getPokemon(id);
  }
}
