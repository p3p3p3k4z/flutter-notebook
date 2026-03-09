import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokeapi/services/service_pokemon.dart';

import 'models/pokemon.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _changeTheme(ThemeMode thememode) {
    setState(() {
      _themeMode = thememode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 63, 181, 63),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: _themeMode,
      home: PokemonScreen(changeTheme: _changeTheme),
    );
  }
}

class PokemonScreen extends StatefulWidget {
  final void Function(ThemeMode) changeTheme;
  const PokemonScreen({super.key, required this.changeTheme});

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  final TextEditingController _controller = TextEditingController();
  final ServicePokemon _servicePokemon = ServicePokemon();

  Future<Pokemon>? _futurePokemom;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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

            Expanded(
              child: _futurePokemom == null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Inserta un nombre"),
                    )
                  : FutureBuilder<Pokemon>(
                      future: _futurePokemom,
                      builder: (context, datos) {
                        if (datos.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (datos.hasError) {
                          return Center(
                            child: Text("Pokemon no existe en la api"),
                          );
                        }
                        final pokemon =
                            datos.data!; // datos para desplegar lo faltante

                        // vista separada para no recargar toda la pantalla
                        return VistaPokemon(pokemon: pokemon);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btnClaro",
            onPressed: () => widget.changeTheme(ThemeMode.light),
            tooltip: 'Modo claro',
            child: Icon(Icons.light_mode),
          ),
          SizedBox(width: 15),
          FloatingActionButton(
            heroTag: "btnOscuro",
            onPressed: () => widget.changeTheme(ThemeMode.dark),
            tooltip: 'Modo oscuro',
            child: Icon(Icons.dark_mode),
          ),
        ],
      ),
    );
  }
}

// galeria interactiva
class VistaPokemon extends StatefulWidget {
  final Pokemon pokemon;

  const VistaPokemon({super.key, required this.pokemon});

  @override
  State<VistaPokemon> createState() => _VistaPokemonState();
}

class _VistaPokemonState extends State<VistaPokemon> {
  int indiceActual = 0; // imagen visible

  void _siguienteImagen() {
    setState(() {
      if (indiceActual < widget.pokemon.galleryImages.length - 1) {
        indiceActual++;
      } else {
        indiceActual = 0;
      }
    });
  }

  void _anteriorImagen() {
    setState(() {
      if (indiceActual > 0) {
        indiceActual--;
      } else {
        indiceActual = widget.pokemon.galleryImages.length - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(widget.pokemon.name.toLowerCase()),
          SizedBox(height: 20),
          //Image.network(pokemon.imageURL),
          SvgPicture.network(widget.pokemon.imageURL, height: 120),

          SizedBox(height: 20),

          Text("Habilidades:", style: TextStyle(fontWeight: FontWeight.bold)),
          ...widget.pokemon.abilities.map((habilidad) => Text(habilidad)),

          SizedBox(height: 20),

          // galeria PNG y botones
          if (widget.pokemon.galleryImages.isNotEmpty) ...[
            Image.network(
              widget.pokemon.galleryImages[indiceActual],
              height: 120,
              fit: BoxFit.contain,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _anteriorImagen,
                  child: const Text("<<"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _siguienteImagen,
                  child: const Text(">>"),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
