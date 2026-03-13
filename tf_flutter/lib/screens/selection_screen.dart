import 'package:flutter/material.dart';
import '../service.dart';
import 'camera_screen.dart';
import 'gallery_screen.dart';

class SelectionScreen extends StatelessWidget {
  final TFService tfService;
  const SelectionScreen({super.key, required this.tfService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu Principal"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // boton grande para ir a la camara
            SizedBox(
              width: 280,
              height: 100,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CameraScreen(tfService: tfService))),
                icon: const Icon(Icons.camera_alt, size: 40),
                label: const Text("USAR CAMARA", style: TextStyle(fontSize: 20)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                ),
              ),
            ),
            const SizedBox(height: 40),
            // boton grande para ir a la galeria
            SizedBox(
              width: 280,
              height: 100,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GalleryScreen(tfService: tfService))),
                icon: const Icon(Icons.photo_library, size: 40),
                label: const Text("USAR GALERIA", style: TextStyle(fontSize: 20)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}