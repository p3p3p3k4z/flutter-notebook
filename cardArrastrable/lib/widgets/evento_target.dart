import 'package:flutter/material.dart';

import '../models/evento_historico.dart';
import '../models/hecho_historico.dart';

class EventoTarget extends StatefulWidget {
  final EventoHistorico evento;
  final Function(HechoHistorico hecho, bool correcto) onHechoAceptado;

  const EventoTarget({
    super.key,
    required this.evento,
    required this.onHechoAceptado,
  });

  @override
  State<EventoTarget> createState() => _EventoTargetState();
}

class _EventoTargetState extends State<EventoTarget> {
  bool _isHovering = false;
  bool? _ultimoResultado;

  @override
  Widget build(BuildContext context) {
    return DragTarget<HechoHistorico>(
      onWillAccept: (hecho) {
        setState(() {
          _isHovering = true;
        });
        return true;
      },
      onLeave: (hecho) {
        setState(() {
          _isHovering = false;
          _ultimoResultado = null;
        });
      },
      onAccept: (hecho) {
        final bool correcto = hecho.eventoId == widget.evento.id;

        setState(() {
          _isHovering = false;
          _ultimoResultado = correcto;
        });

        widget.onHechoAceptado(hecho, correcto);
      },
      builder: (context, candidateData, rejectedData) {
        return _buildTarget();
      },
    );
  }

  Widget _buildTarget() {
    Color borderColor = Colors.grey;

    if (_isHovering) {
      borderColor = Colors.blue;
    } else if (_ultimoResultado == true) {
      borderColor = Colors.green;
    } else if (_ultimoResultado == false) {
      borderColor = Colors.red;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade100,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.evento.titulo,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...widget.evento.hechosAsignados.map(
            (hecho) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                '+ ${hecho.descripcion}',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
