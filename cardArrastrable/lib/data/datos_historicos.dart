import '../models/evento_historico.dart';
import '../models/hecho_historico.dart';

/// Identificadores constantes para los eventos
const String eventoIndependencia = 'independencia_mexico';
const String eventoRevolucion = 'revolucion_mexicana';

/// Lista de eventos históricos target
final List<EventoHistorico> eventosHistoricos = [
  EventoHistorico(id: eventoIndependencia, titulo: 'Independencia de México'),
  EventoHistorico(id: eventoRevolucion, titulo: 'Revolución Mexicana'),
];

/// Lista de hechos históricos (tarjetas arrastrables)
final List<HechoHistorico> hechosHistoricos = [
  // Hechos de la Independencia de México
  HechoHistorico(
    id: 'h1',
    descripcion: 'Grito de Dolores',
    eventoId: eventoIndependencia,
  ),
  HechoHistorico(
    id: 'h2',
    descripcion: 'Miguel Hidalgo inicia el movimiento',
    eventoId: eventoIndependencia,
  ),
  HechoHistorico(
    id: 'h3',
    descripcion: 'Consumación de la Independencia en 1821',
    eventoId: eventoIndependencia,
  ),

  // Hechos de la Revolución Mexicana
  HechoHistorico(
    id: 'h4',
    descripcion: 'Inicio del movimiento en 1910',
    eventoId: eventoRevolucion,
  ),
  HechoHistorico(
    id: 'h5',
    descripcion: 'Francisco I. Madero lidera el levantamiento',
    eventoId: eventoRevolucion,
  ),
  HechoHistorico(
    id: 'h6',
    descripcion: 'Promulgación de la Constitución de 1917',
    eventoId: eventoRevolucion,
  ),
];
