class HechoHistorico {
  final String id;
  final String descripcion;
  final String eventoId;

  bool colocadoCorrectamente;

  HechoHistorico({
    required this.id,
    required this.descripcion,
    required this.eventoId,
    this.colocadoCorrectamente = false,
  });
}