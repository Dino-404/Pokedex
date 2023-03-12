import 'package:pokedex/models/pokemon.dart';
import 'http_manager.dart';

abstract class IremoteApi {
  Future<List<Pokemon>> getAllPokemon(int offset);
  Future<Pokemon> getPokemon(int id);
}

const String baseUrl = 'https://pokeapi.co/api/v2/pokemon';
const int pageLimit = 24;

class RemoteApi implements IremoteApi {
  final HttpManager http;
  RemoteApi(this.http);

  @override
  Future<List<Pokemon>> getAllPokemon(int offset) async {
    final endpoint = '$baseUrl?offset=$offset&limit=$pageLimit';
    final data = await http.get(endpoint);
    final pokemonList = (data['results'] as List).map(
      (pokemon) {
        // El id del pokemon no viene en los datos asi que lo obtengo de la url
        List<String> urlPaths = (pokemon['url'] as String).split("/");
        final pokemonId = urlPaths[urlPaths.length - 2];
        return Pokemon.fromMap(pokemon).copyWith(
          id: int.parse(pokemonId),
        );
      },
    ).toList();
    return pokemonList;
  }

  @override
  Future<Pokemon> getPokemon(int id) async {
    final data = await http.get('$baseUrl/$id');
    return Pokemon.fromMap(data);
  }
}
