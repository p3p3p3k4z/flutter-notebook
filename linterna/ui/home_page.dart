import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final int lux; 
  const HomePage({super.key, required this.lux});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sensor de luz")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Luz actual: $lux lx",
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Text("El tema cambia automáticamente"),
          ],
        ),
      ),
    );
  }
}