import 'evento_historico.dart';
import 'hecho_historico.dart';

class JuegoEstado {
  final List<HechoHistorico> hechosDisponibles;
  final List<EventoHistorico> eventos;

  JuegoEstado({
    required this.hechosDisponibles,
    required this.eventos,
  });

  bool get juegoCompletado =>
      hechosDisponibles.every((h) => h.colocadoCorrectamente);
}