// lib/screens/newflix_player.dart
import 'package:flutter/material.dart';
import '../models/video.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class NewFlixPlayer extends StatefulWidget {
  final Video video;
  const NewFlixPlayer({super.key, required this.video});

  @override
  State<NewFlixPlayer> createState() => _NewFlixPlayerState();
}

class _NewFlixPlayerState extends State<NewFlixPlayer> {
  // _videoPlayerController es el controlador del video que se utiliza para controlar la reproducción del video,
  // y ChewieController es un controlador adicional que se utiliza para proporcionar una interfaz de usuario
  // personalizada para el reproductor de video, como botones de reproducción, barra de progreso, etc.
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  // didUpdateWidget se llama cuando el widget se actualiza, lo que puede ocurrir cuando el usuario selecciona un video diferente.
  // Si el video seleccionado cambia, se llama a _disposePlayer para liberar los recursos del reproductor actual, y luego se
  // llama a _initializePlayer para inicializar el nuevo reproductor con
  @override
  void didUpdateWidget(NewFlixPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.video.videopath != widget.video.videopath) {
      _disposePlayer();
      _initializePlayer();
    }
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.asset(
      widget.video.videopath,
    );
    await _videoPlayerController!.initialize();

    // ChewieController se inicializa con el VideoPlayerController, y se configuran varias opciones
    // como autoPlay, looping, aspectRatio, etc.
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: true,
      looping: false,
      aspectRatio: _videoPlayerController!.value.aspectRatio,
      allowFullScreen: true,
      allowPlaybackSpeedChanging: true,
    );
    setState(() {});
  }

  void _disposePlayer() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
  }

  @override
  void dispose() {
    _disposePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Se verifica si el ChewieController está inicializado y si el VideoPlayerController tiene un video cargado antes de mostrar el reproductor.
    if (_chewieController != null &&
        _chewieController!.videoPlayerController.value.isInitialized) {
      return Column(
        children: [
          AspectRatio(
            // AspectRatio se utiliza para mantener la proporción del video, y se obtiene del valor del VideoPlayerController.
            // _videoPlayerController!.value.aspectRatio se utiliza para obtener la proporción del video, lo que garantiza que
            // el video se muestre correctamente sin distorsión, independientemente de su tamaño original.
            aspectRatio: _videoPlayerController!.value.aspectRatio,
            child: Chewie(controller: _chewieController!),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.video.title,
                  // Theme.of(context).textTheme.headlineSmall se utiliza para aplicar el estilo de texto definido en el tema de
                  // la aplicación, lo que garantiza una apariencia consistente en toda la aplicación.
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(widget.video.description),
              ],
            ),
          ),
        ],
      );
    } else {
      // Si el reproductor no está listo, se muestra un indicador de carga.
      return const Center(child: CircularProgressIndicator());
    }
  }
}
