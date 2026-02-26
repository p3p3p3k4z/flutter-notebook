// lib/models/video.dart
class Video {
  final String title;
  final List<String> gallery;
  final String videopath;
  final String description;

  Video({
    required this.title,
    required this.gallery,
    required this.videopath,
    required this.description,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      title: json['title'] as String,
      gallery: List<String>.from(json['gallery'] as List),
      videopath: json['videopath'] as String,
      description: json['description'] as String,
    );
  }
}
