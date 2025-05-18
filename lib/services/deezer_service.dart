import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/music_model.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/music_model.dart';

class DeezerService {
  static Future<List<Music>> searchSongs(String query) async {
    final url = Uri.parse('https://api.deezer.com/search?q=$query');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['data'];

      return results.map((item) {
        return Music(
          title: item['title'],
          artist: item['artist']['name'],
          imageUrl: item['album']['cover_medium'],
          audioUrl: item['preview'], // sadece 30 saniyelik örnek mp3
        );
      }).toList();
    } else {
      throw Exception('Failed to load songs from Deezer');
    }
  }
}
