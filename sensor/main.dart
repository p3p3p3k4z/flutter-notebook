import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prueba con acelerómetro',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const AcelerometroPage(title: 'Datos del acelerómetro'),
    );
  }
}

class AcelerometroPage extends StatefulWidget {
  const AcelerometroPage({super.key, required this.title});

  final String title;

  @override
  State<AcelerometroPage> createState() => _AcelerometroPageState();
}

class _AcelerometroPageState extends State<AcelerometroPage> {
  double x = 0.0;
  double y = 0.0;
  double z = 0.0;

  String orientacion = "Sin movimiento";

  @override
  void initState() {
    super.initState();
    accelerometerEventStream().listen((AccelerometerEvent event) {
      x = event.x;
      y = event.y;
      z = event.z;
      orientacion = detectarOrientacion(x, y);
    });
  }

  String detectarOrientacion(double x, double y) {
    if (x > 4) {
      return "Inclinación a la izquierda";
    } else if (x < -4) {
      return "Inclinación a la derecha";
    } else if (y > 4) {
      return "Inclinación hacia arriba";
    } else if (y < -4) {
      return "Inclinación hacia abajo";
    }

    return "Dispositivo estable";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(" X: ${x.toStringAsFixed(2)}", style: TextStyle(fontSize: 20)),
            Text(" Y: ${y.toStringAsFixed(2)}", style: TextStyle(fontSize: 20)),
            Text(" Z: ${z.toStringAsFixed(2)}", style: TextStyle(fontSize: 20)),
            SizedBox(height: 30),
            Text("Orientacion", style: TextStyle(fontSize: 15)),
            Text(
              orientacion,
              style: TextStyle(
                fontSize: 25,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
