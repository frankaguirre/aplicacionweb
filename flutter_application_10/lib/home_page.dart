import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'modelos/pokemon.dart';
import 'carga_page.dart';
import 'datos_page.dart';
import 'error_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<PokemonElement>> _pokemonListFuture;

  @override
  void initState() {
    super.initState();
    _pokemonListFuture = fetchPokemons();
  }

  

  Future<List<PokemonElement>> fetchPokemons() async {
    final url = Uri.parse('http://localhost:3000/pokemons');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> parsedJson = jsonDecode(response.body);
      List<PokemonElement> pokemonList =
          parsedJson.map((json) => PokemonElement.fromJson(json)).toList();
      return pokemonList;
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Pokémon'),
      ),
      body: FutureBuilder<List<PokemonElement>>(
        future: _pokemonListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return DatosPage(pokemons: snapshot.data!);
          } else {
            return Center(child: Text('No hay datos disponibles'));
          }
        },
      ),
    );
  }
}

