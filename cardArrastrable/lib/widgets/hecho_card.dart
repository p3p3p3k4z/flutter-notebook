import 'package:flutter/material.dart';
import "../models/hecho_historico.dart";

class HechoCard extends StatelessWidget {
  final HechoHistorico hecho;

  const HechoCard({super.key, required this.hecho});

  @override
  Widget build(BuildContext context) {
    return Draggable<HechoHistorico>(
      data: hecho,
      // sigue al dedo durante el arrastre.
      // eleva visualmente (mayor elevation) para dar sensación de flotación.
      feedback: _buildCard(isDragging: true),
      // Widget que se muestra cuando el widget se está arrastrando.
      // opacidad reducida indica que el elemento está “en movimiento”.
      childWhenDragging: _buildCard(isDragging: false, opacity: 0.3),
      child: _buildCard(isDragging: false),
    );
  }

  Widget _buildCard({required bool isDragging, double opacity = 1.0}) {
    // Centraliza la construcción visual de la tarjeta.
    //  Evita duplicación de código entre child, feedback y childWhenDragging.
    // Facilita cambios de estilo sin modificar la lógica del Draggable.
    return Opacity(
      opacity: opacity,

      child: Card(
        elevation: isDragging ? 8 : 3,
        color: Colors.blue.shade100,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            hecho.descripcion,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
