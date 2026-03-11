import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sensor de luz")),
      body: const Center(
        child: Text(
          "El tema cambia automáticamente según la luz del entorno",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
