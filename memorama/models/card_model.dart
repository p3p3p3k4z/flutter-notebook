class Card {
  final int id;
  final String imagePath;

  bool isUp; //carta hacia arriba
  bool isMatched; //carta coincide

  Card({
    required this.id,
    required this.imagePath,
    this.isUp = false,
    this.isMatched = false,
  });
}
