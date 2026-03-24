import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: GPSPage(title: 'GPS App'),
    );
  }
}

class GPSPage extends StatefulWidget {
  const GPSPage({super.key, required this.title});
  final String title;
  @override
  State<GPSPage> createState() => _GPSPageState();
}

class _GPSPageState extends State<GPSPage> {
  String longitude = "Sin datos";
  String latitude = "Sin datos";

  //future es una promesa
  Future<void> getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission;

    if (!serviceEnabled) {
      setState(() {
        latitude = "GPS no está habilitado";
        longitude = "";
        return;
      });
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      setState(() {
        latitude = "Permiso denegado";
        longitude = "";
        return;
      });
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        latitude = "Permiso denegado permanentemente";
        longitude = "";
        return;
      });
    }

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    setState(() {
      latitude = "Latitud: ${position.latitude.toString()}";
      longitude = "Longitud: ${position.longitude.toString()}";
    });
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
            Text("Ubicacion actual", style: TextStyle(fontSize: 20)),
            Text("Latitud: $latitude"),
            Text("Longitud: $longitude"),
            ElevatedButton(
              onPressed: getLocation,
              child: Text("Obtener ubicación"),
            ),
          ],
        ),
      ),
    );
  }
}
