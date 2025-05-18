class PixabayMusic {
  final String title;
  final String artist;
  final String imageUrl;
  final String audioUrl;

  PixabayMusic({
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.audioUrl,
  });

  factory PixabayMusic.fromJson(Map<String, dynamic> json) {
    return PixabayMusic(
      title: json['tags'] ?? 'Unknown',
      artist: json['user'] ?? 'Pixabay',
      imageUrl: json['image'] ?? '',
      audioUrl: json['audio'] ?? '',
    );
  }
}
