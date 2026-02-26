import 'package:flutter/material.dart';
import '../models/video.dart';
import '../services/data_service.dart';

// VideoProvider es una clase que extiende ChangeNotifier, lo que permite que
// los widgets que la consumen se actualicen automáticamente cuando el estado cambia.
class VideoProvider with ChangeNotifier {
  // _videos es una lista privada que almacena los videos cargados desde el servicio de datos.
  // _selectedVideo es una variable que almacena el video actualmente seleccionado por el usuario.
  // _isLoading es una variable booleana que indica si los videos están siendo cargados,
  // lo que se utiliza para mostrar un indicador de carga en la interfaz de usuario.
  List<Video> _videos = [];
  Video? _selectedVideo;
  bool _isLoading = true;

  // Getters públicos para acceder a las variables privadas desde otros widgets.
  // Estas variables pueden ser accedidas por los widgets que consumen este provider
  // para mostrar la lista de videos,
  List<Video> get videos => _videos;
  Video? get selectedVideo => _selectedVideo;
  bool get isLoading => _isLoading;

  VideoProvider() {
    _init();
  }

  Future<void> _init() async {
    // _init es un método privado que se llama en el constructor de la clase para
    // cargar los videos desde el servicio de datos.
    // DataService.loadVideos() es un método que simula la carga de videos desde una fuente de datos,
    // y devuelve una lista de objetos Video.
    _videos = await DataService.loadVideos();
    if (_videos.isNotEmpty) {
      _selectedVideo = _videos.first;
    }
    _isLoading = false;
    notifyListeners();
  }

  void selectVideo(Video video) {
    _selectedVideo = video;
    notifyListeners();
  }
}
