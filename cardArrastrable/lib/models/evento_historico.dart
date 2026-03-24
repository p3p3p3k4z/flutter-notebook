import 'hecho_historico.dart';

class EventoHistorico {
  final String id;
  final String titulo;
  final List<HechoHistorico> hechosAsignados;

  EventoHistorico({
    required this.id,
    required this.titulo,
    List<HechoHistorico>? hechosAsignados,
  }) : hechosAsignados = hechosAsignados ?? [];
}