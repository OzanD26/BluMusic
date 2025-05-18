import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import '../data/favorites.dart';
import '../models/music_model.dart';

class PlayerScreen extends StatefulWidget {
  final List<Music> playlist;
  final int initialIndex;

  const PlayerScreen({super.key, required this.playlist, required this.initialIndex});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late AudioPlayer _player;
  late int _currentIndex;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  Music get currentMusic => widget.playlist[_currentIndex];

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _currentIndex = widget.initialIndex;
    _initPlayer();

    _player.playerStateStream.listen((state) {
      setState(() => _isPlaying = state.playing);
    });
  }

  Future<void> _initPlayer() async {
    try {
      await _player.setUrl(currentMusic.audioUrl);
      _player.durationStream.listen((d) {
        if (d != null) setState(() => _duration = d);
      });
      _player.positionStream.listen((p) => setState(() => _position = p));
      await _player.play();
    } catch (e) {
      print("Audio error: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _togglePlayPause() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  void _next() {
    if (_currentIndex < widget.playlist.length - 1) {
      _currentIndex++;
      _changeSong();
    }
  }

  void _previous() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _changeSong();
    }
  }

  Future<void> _changeSong() async {
    setState(() {
      _position = Duration.zero;
      _duration = Duration.zero;
    });
    await _player.setUrl(currentMusic.audioUrl);
    await _player.play();
  }

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    final favoriteService = Provider.of<FavoriteService>(context);
    final isFav = favoriteService.isFavorite(currentMusic);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF181828), Color(0xFF23242F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Spacer(),
                    const Text("Şuan Çalıyor.",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.pinkAccent : Colors.white54,
                      ),
                      onPressed: () {
                        final wasFav = isFav;
                        favoriteService.toggleFavorite(currentMusic);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              wasFav ? "Favoriden kaldırıldı" : "Favorilere eklendi",
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    currentMusic.imageUrl,
                    height: screenHeight * 0.35,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  currentMusic.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  currentMusic.artist,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 24),
                Slider(
                  activeColor: Colors.purpleAccent,
                  inactiveColor: Colors.purple.shade100,
                  min: 0,
                  max: _duration.inSeconds.toDouble(),
                  value: _position.inSeconds.clamp(0, _duration.inSeconds).toDouble(),
                  onChanged: (value) {
                    final newPosition = Duration(seconds: value.toInt());
                    _player.seek(newPosition);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_format(_position), style: const TextStyle(color: Colors.white54)),
                    Text(_format(_duration), style: const TextStyle(color: Colors.white54)),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _previous,
                      icon: const Icon(Icons.skip_previous_rounded,
                          color: Colors.white, size: 36),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _togglePlayPause,
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(24),
                        backgroundColor: Colors.deepPurple,
                      ),
                      child: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 36,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: _next,
                      icon: const Icon(Icons.skip_next_rounded,
                          color: Colors.white, size: 36),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
