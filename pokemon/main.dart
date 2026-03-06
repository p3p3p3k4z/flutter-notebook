import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:galeria/services/service_pokemon.dart';

import 'models/pokemon.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const PokemonScreen(),
    );
  }
}

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  final TextEditingController _controller = TextEditingController();
  final ServicePokemon _servicePokemon = ServicePokemon();

  Future<Pokemon>? _futurePokemom;

  void _buscarPokemon() {
    setState(() {
      _futurePokemom = _servicePokemon.fetchPokemon(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Galeria de Pokemones")),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Nombre del pokemon",
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _buscarPokemon,
              child: Text("Buscar el pokemon"),
            ),
            Text("Datos de pokemon", style: TextStyle(fontSize: 25)),
            _futurePokemom == null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Inserta un nombre"),
                  )
                : Column(
                    children: [
                      FutureBuilder(
                        future: _futurePokemom,
                        builder: (context, datos) {
                          if (datos.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (datos.hasError) {
                            return Center(
                              child: Text("Pokemon no existe en la api"),
                            );
                          }
                          final pokemon =
                              datos.data!; // datos para desplegar lo faltante

                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(pokemon.name.toLowerCase()),
                                SizedBox(height: 20),
                                //Image.network(pokemon.imageURL),
                                SvgPicture.network(pokemon.imageURL),
                              ],
                            ),
                          );
                          return CircularProgressIndicator();
                        },
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
