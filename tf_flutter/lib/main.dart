import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'service.dart';
import 'package:logger/logger.dart';
import 'package:flutter/services.dart' show rootBundle;

List<CameraDescription> cameras = [];

void main() async {
  //inicializar el servicio TF y la camara
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Obtener las camaras del dispositivo
    cameras = await availableCameras();
  } catch (e) {
    print("Error al obtener camaras: $e");
  }

  final tfService = TFService();
  await tfService.loadModel();

  runApp(MyApp(tfService: tfService));
}

class MyApp extends StatelessWidget {
  final TFService tfService;
  const MyApp({super.key, required this.tfService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TF Lite Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ModelScreen(tfService: tfService),
    );
  }
}

class ModelScreen extends StatefulWidget {
  final TFService tfService;
  const ModelScreen({super.key, required this.tfService});

  @override
  ModelScreenState createState() => ModelScreenState();
}

class ModelScreenState extends State<ModelScreen> {
  List<String> _labels = [];
  String _output = 'Presionar el botón para ejecutar el modelo';
  File? _image;

  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _loadLabels();
    _setupCamera(); // inicializar camara al iniciar
  }

  // configurar la camara trasera
  void _setupCamera() {
    if (cameras.isEmpty) return;
    
    _controller = CameraController(
      cameras[0], // camara trasera
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller!.initialize();
  }

  @override
  void dispose() {
    _controller?.dispose(); // liberar recurso de camara
    super.dispose();
  }

  var customLogger = Logger(
    printer: PrettyPrinter(
      methodCount: 2, 
      errorMethodCount: 8, 
      lineLength: 120, 
      colors: true, 
      printEmojis: true, 
    ),
  );

  int _argMax(List<double> values) {
    int maxIndex = 0;
    double maxValue = values[0];
    for (int i = 1; i < values.length; i++) {
      if (values[i] > maxValue) {
        maxValue = values[i];
        maxIndex = i;
      }
    }
    return maxIndex;
  }

  Future<void> _loadLabels() async {
    final rawLabels = await rootBundle.loadString('assets/models/labels.txt');
    setState(() {
      _labels = rawLabels.split('\n');
    });
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller!.takePicture();
      
      setState(() {
        _image = File(image.path);
        _output = "Foto capturada. List para clasificar.";
      });
      
      _runModel(); // Ejecutar el modelo automaticamente al tomar la foto
    } catch (e) {
      customLogger.e("Error al tomar foto: $e");
    }
  }

  void _runModel() async {
    if (_image == null) {
      setState(() {
        _output = 'Por favor, selecciona una imagen primero.';
      });
      return;
    }

    try {
      // Usar el modelo de ML para clasificar la foto tomada
      List<double> result = await widget.tfService.runModel(_image!);

      final int predictedIndex = _argMax(result);
      final String predictedLabel = _labels[predictedIndex];
      final double confidence = result[predictedIndex];

      customLogger.i('Result : $result');
      setState(() {
        _output =
            'Predicción: $predictedLabel\nConfianza: ${(confidence * 100).toStringAsFixed(2)}%';
      });
    } catch (e) {
      setState(() {
        _output = 'Error al ejecutar el modelo: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TF Lite Model Inference')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Vista previa de la camara o imagen capturada
              SizedBox(
                height: 300,
                child: _image == null 
                  ? FutureBuilder<void>(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return CameraPreview(_controller!);
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      },
                    )
                  : Image.file(_image!),
              ),

              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _takePicture,
                icon: const Icon(Icons.camera),
                label: const Text("Tomar Foto y Clasificar"),
              ),

              if (_image != null) 
                TextButton(
                  onPressed: () => setState(() => _image = null),
                  child: const Text("Resetear Camara"),
                ),

              const SizedBox(height: 20),
              Text(_output, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}