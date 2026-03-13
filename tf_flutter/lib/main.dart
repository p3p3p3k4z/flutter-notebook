import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'service.dart';
import 'screens/selection_screen.dart';

List<CameraDescription> cameras = [];

void main() async {
  // inicializar componentes de flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // detectar camaras disponibles
    cameras = await availableCameras();
  } catch (e) {
    print("error al buscar camaras");
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // enviamos a la pantalla de seleccion
      home: SelectionScreen(tfService: tfService),
    );
  }
}