import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/video_provider.dart' show VideoProvider;
import 'newflix_player.dart'; // Importamos tu nuevo componente.

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // Controla las 3 secciones principales.
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VideoProvider>(context); // Escucha cambios globales en los videos.

    if (provider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('NewFlix'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.list), text: 'Videos'),
            Tab(icon: Icon(Icons.play_circle_fill), text: 'Reproductor'),
            Tab(icon: Icon(Icons.photo_library), text: 'Galería'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildVideoList(context, provider),   // Pestaña 1: Selección.
          _buildVideoPlayer(context, provider), // Pestaña 2: Tu nuevo componente NewFlixPlayer.
          _buildGallery(context, provider),     // Pestaña 3: Imágenes del video.
        ],
      ),
    );
  }

  // --- MÉTODOS DE INTERFAZ ---

  Widget _buildVideoList(BuildContext context, VideoProvider provider) {
    return ListView.builder(
      itemCount: provider.videos.length,
      itemBuilder: (context, index) {
        final video = provider.videos[index];
        return ListTile(
          leading: const Icon(Icons.movie_outlined),
          title: Text(video.title),
          onTap: () {
            provider.selectVideo(video); // Actualiza el video en toda la app.
            _tabController.animateTo(1); // Mueve al usuario automáticamente al reproductor.
          },
        );
      },
    );
  }

  Widget _buildVideoPlayer(BuildContext context, VideoProvider provider) {
    if (provider.selectedVideo == null) {
      return const Center(child: Text('Selecciona un video de la lista'));
    }
    // Usamos tu componente NewFlixPlayer pasando el objeto Video completo.
    return NewFlixPlayer(video: provider.selectedVideo!); 
  }

  Widget _buildGallery(BuildContext context, VideoProvider provider) {
    final video = provider.selectedVideo;
    if (video == null) return const Center(child: Text('No hay video seleccionado'));

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, 
        mainAxisSpacing: 8, 
        crossAxisSpacing: 8
      ),
      itemCount: video.gallery.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(video.gallery[index], fit: BoxFit.cover),
        );
      },
    );
  }
}