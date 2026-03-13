import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import '../service.dart';

class GalleryScreen extends StatefulWidget {
  final TFService tfService;
  const GalleryScreen({super.key, required this.tfService});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  File? _img;
  List<String> _tags = [];
  String _res = "Sin seleccion";
  String _info = "";

  @override
  void initState() {
    super.initState();
    _loadTags();
  }

  Future<void> _loadTags() async {
    final raw = await rootBundle.loadString('assets/models/labels.txt');
    _tags = raw.split('\n');
  }

  Future<void> _pick() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      final f = File(file.path);
      setState(() { _img = f; });
      final res = await widget.tfService.runModel(f);
      if (res.isNotEmpty) {
        int id = 0;
        double v = res[0];
        for (int i = 1; i < res.length; i++) {
          if (res[i] > v) { v = res[i]; id = i; }
        }
        setState(() {
          _res = _tags[id];
          _info = "confianza " + (v * 100).toStringAsFixed(2) + " por ciento";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Analisis Galeria"), backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
      body: Column(
        children: [
          Expanded(child: _img != null ? Image.file(_img!) : const Center(child: Text("seleccione una foto de su galeria"))),
          Container(
            padding: const EdgeInsets.all(30),
            color: Colors.white,
            child: Column(
              children: [
                Text(_res, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                Text(_info, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _pick, 
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
                    child: const Text("ABRIR GALERIA")
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}