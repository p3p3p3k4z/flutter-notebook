import 'package:flutter/material.dart';
import '../data/datos_historicos.dart';
import '../models/hecho_historico.dart';
import '../models/evento_historico.dart';
import '../widgets/hecho_card.dart';
import '../widgets/evento_target.dart';

class JuegoScreen extends StatefulWidget {
  const JuegoScreen({super.key});

  @override
  State<JuegoScreen> createState() => _JuegoScreenState();
}

class _JuegoScreenState extends State<JuegoScreen> {
  late List<HechoHistorico> _hechosDisponibles;
  late List<EventoHistorico> _eventos;

  @override
  void initState() {
    super.initState();
    _inicializarJuego();
  }

  void _inicializarJuego() {
    _hechosDisponibles = List.from(hechosHistoricos)..shuffle();
    _eventos = eventosHistoricos
        .map((e) => EventoHistorico(id: e.id, titulo: e.titulo))
        .toList();
  }

  void _onHechoAceptado(HechoHistorico hecho, bool correcto) {
    if (!correcto) return;

    setState(() {
      hecho.colocadoCorrectamente = true;
      _hechosDisponibles.remove(hecho);

      final evento = _eventos.firstWhere((e) => e.id == hecho.eventoId);
      evento.hechosAsignados.add(hecho);
    });

    if (_hechosDisponibles.isEmpty) {
      _mostrarDialogoFinal();
    }
  }

  void _mostrarDialogoFinal() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Actividad completada'),
        content: const Text(
          'Has clasificado correctamente todos los hechos históricos.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(_inicializarJuego);
            },
            child: const Text('Reiniciar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clasificación de hechos históricos'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildHechosDisponibles(),
            const SizedBox(height: 16),
            _buildEventosTargets(),
          ],
        ),
      ),
    );
  }

  Widget _buildHechosDisponibles() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _hechosDisponibles
          .map((hecho) => HechoCard(hecho: hecho))
          .toList(),
    );
  }

  Widget _buildEventosTargets() {
    return Expanded(
      child: Row(
        children: _eventos
            .map(
              (evento) => Expanded(
                child: EventoTarget(
                  evento: evento,
                  onHechoAceptado: _onHechoAceptado,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
