import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/favorites.dart';
import '../models/music_model.dart';
import 'player_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  final List<Music> allMusic = [
    Music(
      title: "Acoustic Breeze",
      artist: "Benjamin Tissot",
      imageUrl: "https://www.bensound.com/bensound-img/acousticbreeze.jpg",
      audioUrl: "https://www.bensound.com/bensound-music/bensound-acousticbreeze.mp3",
    ),
    Music(
      title: "Creative Minds",
      artist: "Benjamin Tissot",
      imageUrl: "https://www.bensound.com/bensound-img/creativeminds.jpg",
      audioUrl: "https://www.bensound.com/bensound-music/bensound-creativeminds.mp3",
    ),
    Music(
      title: "Going Higher",
      artist: "Benjamin Tissot",
      imageUrl: "https://www.bensound.com/bensound-img/goinghigher.jpg",
      audioUrl: "https://www.bensound.com/bensound-music/bensound-goinghigher.mp3",
    ),
  ];

  List<Music> filteredMusic = [];

  @override
  void initState() {
    super.initState();
    filteredMusic = allMusic;
  }

  void _filterMusic(String query) {
    setState(() {
      filteredMusic = allMusic
          .where((music) =>
      music.title.toLowerCase().contains(query.toLowerCase()) ||
          music.artist.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteService = Provider.of<FavoriteService>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E1E2C), Color(0xFF23242F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Search Music 🔍",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _controller,
                  onChanged: _filterMusic,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Search by song or artist",
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white12,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: filteredMusic.isEmpty
                      ? const Center(
                    child: Text(
                      "No music found",
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                      : ListView.separated(
                    itemCount: filteredMusic.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final music = filteredMusic[index];
                      final isFav = favoriteService.isFavorite(music);

                      return GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PlayerScreen(
                                playlist: filteredMusic,
                                initialIndex: index,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  music.imageUrl,
                                  width: screenWidth < 400 ? 50 : 60,
                                  height: screenWidth < 400 ? 50 : 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      music.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      music.artist,
                                      style: const TextStyle(color: Colors.white70),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  isFav ? Icons.favorite : Icons.favorite_border,
                                  color: isFav ? Colors.pinkAccent : Colors.white54,
                                ),
                                onPressed: () {
                                  favoriteService.toggleFavorite(music);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        isFav
                                            ? "Removed from favorites"
                                            : "Added to favorites",
                                      ),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
