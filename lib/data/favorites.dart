import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/music_model.dart';

class FavoriteService extends ChangeNotifier {
  static const _key = "FAVORITE_MUSIC";

  List<String> _savedUrls = []; // Query'siz favori URL'ler
  List<Music> _favoriteMusicList = [];

  List<Music> get favoriteMusicList => _favoriteMusicList;

  /// ✅ 1. Uygulama ilk açıldığında sadece URL’leri yükle
  Future<void> preloadSavedUrls() async {
    final prefs = await SharedPreferences.getInstance();
    _savedUrls = prefs.getStringList(_key) ?? [];
  }

  /// ✅ 2. allMusic geldikten sonra eşleşme yapılır
  void loadFavorites(List<Music> allMusic) {
    _favoriteMusicList = allMusic
        .where((m) => _savedUrls.contains(_stripUrl(m.audioUrl)))
        .toList();
    notifyListeners();

    print('🟢 [Loaded saved URLs]: $_savedUrls');
    print('✅ [Matched favorites]: ${_favoriteMusicList.map((m) => m.audioUrl)}');
  }

  /// ✅ 3. Favori ekle/çıkar ve kaydet
  Future<void> toggleFavorite(Music music) async {
    final prefs = await SharedPreferences.getInstance();
    final baseUrl = _stripUrl(music.audioUrl);

    if (_savedUrls.contains(baseUrl)) {
      _savedUrls.remove(baseUrl);
      _favoriteMusicList.removeWhere((m) => _stripUrl(m.audioUrl) == baseUrl);
    } else {
      _savedUrls.add(baseUrl);
      _favoriteMusicList.add(music);
    }

    await prefs.setStringList(_key, _savedUrls);
    notifyListeners();

    print('🔴 [Saved URLs after toggle]: $_savedUrls');
  }

  /// ✅ 4. Favori kontrolü
  bool isFavorite(Music music) {
    return _savedUrls.contains(_stripUrl(music.audioUrl));
  }

  /// ✅ 5. Yardımcı: query'yi sil
  String _stripUrl(String url) {
    final uri = Uri.parse(url);
    return uri.replace(query: '').toString();
  }

  /// Debug için getter
  List<String> get savedUrlsDebug => _savedUrls;
}
