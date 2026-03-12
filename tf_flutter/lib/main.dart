import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'service.dart';
import 'package:logger/logger.dart';
import 'package:flutter/services.dart' show rootBundle;



void main() async {
  //inicializar el servicio TF
  WidgetsFlutterBinding.ensureInitialized();
  final tfService = TFService();
  await tfService.loadModel();

  runApp(MyApp(tfService: tfService));
}

class MyApp extends StatelessWidget {
  final TFService tfService;
  const MyApp({super.key, required this.tfService});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TF Lite Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ModelScreen(tfService: tfService), // 👈 PANTALLA PRINCIPAL
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

  @override
  void initState() {
    super.initState();
    _loadLabels();
  }


  var customLogger = Logger(
    printer: PrettyPrinter(
      methodCount: 2, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 120, // width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
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
      // var input = List.generate(
      //   1, (i) =>  List.generate(
      //     224, (y) => List.generate(
      //       224, (x) => List.generate(3, (c) => 0.50)
      //     )
      //   )
      // );

      List<double> result = await widget.tfService.runModel(_image!);


      final int predictedIndex = _argMax(result);
      final String predictedLabel = _labels[predictedIndex];
      final double confidence = result[predictedIndex];

      customLogger.i('Result : $result');
      setState(() {
        //_output = result.toString();
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
              _image == null
                  ? Text('No image selected.')
                  : Image.file(_image!, height: 200),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text("Seleccionar Imagen"),
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _runModel,
                child: Text("Ejecutar Modelo"),
              ),
              SizedBox(height: 20),
              Text(_output, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
