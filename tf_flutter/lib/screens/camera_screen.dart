import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import '../service.dart';

class CameraScreen extends StatefulWidget {
  final TFService tfService;
  const CameraScreen({super.key, required this.tfService});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initFuture;
  List<String> _labels = [];
  String _labelRes = "Sin captura";
  String _probRes = "";

  @override
  void initState() {
    super.initState();
    _loadLabels();
    _initCamera();
  }

  void _initCamera() {
    // cargar camara trasera
    _controller = CameraController(
      const CameraDescription(name: "0", lensDirection: CameraLensDirection.back, sensorOrientation: 90),
      ResolutionPreset.medium
    );
    _initFuture = _controller!.initialize();
  }

  Future<void> _loadLabels() async {
    final data = await rootBundle.loadString('assets/models/labels.txt');
    _labels = data.split('\n');
  }

  // capturar foto y enviarla al servicio original
  void _runInference() async {
    try {
      final shot = await _controller!.takePicture();
      final res = await widget.tfService.runModel(File(shot.path));
      
      if (res.isNotEmpty) {
        int top = 0;
        double val = res[0];
        for (int i = 1; i < res.length; i++) {
          if (res[i] > val) { val = res[i]; top = i; }
        }
        setState(() {
          _labelRes = _labels[top];
          _probRes = "confianza " + (val * 100).toStringAsFixed(2) + " por ciento";
        });
      }
    } catch (e) {
      print("error en captura");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // vista de camara completa
          Positioned.fill(
            child: FutureBuilder(
              future: _initFuture,
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.done) return CameraPreview(_controller!);
                return const Center(child: CircularProgressIndicator());
              }
            )
          ),
          // recuadro verde de guia para capturar
          Center(
            child: Container(
              width: 250, height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 4),
                borderRadius: BorderRadius.circular(10)
              ),
            ),
          ),
          // panel de resultado morado y blanco
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30))
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_labelRes, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                  Text(_probRes, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _runInference, 
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
                      child: const Text("CAPTURAR AHORA", style: TextStyle(fontSize: 18)),
                    ),
                  )
                ],
              ),
            ),
          ),
          // boton para regresar
          Positioned(top: 45, left: 15, child: CircleAvatar(backgroundColor: Colors.deepPurple, child: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: Colors.white))))
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}