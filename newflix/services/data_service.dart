import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/video.dart';

// DataService es una clase que se encarga de cargar los videos desde un archivo
// JSON ubicado en los assets de la aplicación.
class DataService {
  // loadVideos es un método estático que simula la carga de videos desde una fuente de datos,
  // y devuelve una lista de objetos Video.
  // El método utiliza rootBundle para cargar el archivo JSON como una cadena,
  // luego decodifica la cadena JSON en una lista de objetos dinámicos,
  // y finalmente mapea cada objeto dinámico a un objeto Video utilizando el método fromJson
  // definido en la clase Video.
  // El método se declara como static Future<List<Video>> para indicar que es un método
  // asíncrono que devuelve una lista de videos.
  static Future<List<Video>> loadVideos() async {
    final String response = await rootBundle.loadString('assets/videos.json');
    // await se ocupa como parte de la carga asíncrona del archivo JSON, lo que permite que la
    // aplicación continúe respondiendo mientras se carga el archivo.
    final data = await json.decode(response) as List<dynamic>;
    // Se usa Video.fromJson para convertir cada objeto dinámico en un objeto Video,
    // y se devuelve una lista de videos.
    return data.map((v) => Video.fromJson(v as Map<String, dynamic>)).toList();
  }
}
