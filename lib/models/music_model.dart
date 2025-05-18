class Music {
  final String title;
  final String artist;
  final String imageUrl;
  final String audioUrl;

  Music({
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.audioUrl,
  });

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      title: json['title'] ?? 'Unknown',
      artist: json['artist']['name'] ?? 'Unknown',
      imageUrl: json['album']['cover_big'] ?? '',
      audioUrl: json['preview'] ?? '', // 30 saniyelik örnek çalma linki
    );
  }
}
