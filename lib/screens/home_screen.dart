import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/favorites.dart';
import '../models/music_model.dart';
import '../services/deezer_service.dart';
import 'player_screen.dart';

class HomeScreen extends StatefulWidget {
  final void Function(List<Music>) onMusicLoaded;

  const HomeScreen({super.key, required this.onMusicLoaded});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Music> songs = [];
  List<Music> filteredSongs = [];

  final List<String> categories = ['Tümü', 'Slow', 'Komedi', 'Öğretici'];
  String selectedCategory = 'Tümü';

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs([String query = "lofi"]) async {
    final results = await DeezerService.searchSongs(query);
    setState(() {
      songs = results;
      filteredSongs = results;
    });
    widget.onMusicLoaded(results);
    Provider.of<FavoriteService>(context, listen: false).loadFavorites(results);
  }

  @override
  Widget build(BuildContext context) {
    final favoriteService = Provider.of<FavoriteService>(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final spacing = screenWidth * 0.04;
    final imageHeight = screenHeight * 0.13;
    final borderRadius = screenWidth * 0.03;

    return Scaffold(
      backgroundColor: const Color(0xFF181828),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing),
          child: Column(
            children: [
              SizedBox(height: spacing),
              // ✅ AppBar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.menu, color: Colors.white),
                  Text(
                    "Music",
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Stack(
                    children: [
                      const Icon(Icons.notifications_none, color: Colors.white),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: spacing),
              // 🔍 Search Box
              Container(
                padding: EdgeInsets.symmetric(horizontal: spacing),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (query) => _loadSongs(query),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Şarkı,sanatçı...",
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.search, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: spacing),
              // 🏷️ Category Scroll
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final selected = selectedCategory == category;
                    return GestureDetector(
                      onTap: () => setState(() => selectedCategory = category),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenHeight * 0.008,
                        ),
                        decoration: BoxDecoration(
                          color: selected ? Colors.white : Colors.white10,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            category,
                            style: TextStyle(
                              color: selected ? Colors.black : Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: spacing),
              // 🎵 Songs Grid
              Expanded(
                child: filteredSongs.isEmpty
                    ? const Center(child: CircularProgressIndicator(color: Colors.white))
                    : GridView.builder(
                  itemCount: filteredSongs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: screenWidth > 500 ? 3 : 2,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final music = filteredSongs[index];
                    final isFav = favoriteService.isFavorite(music);
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlayerScreen(
                              playlist: filteredSongs,
                              initialIndex: index,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(screenWidth * 0.02),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(borderRadius),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(borderRadius),
                              child: Image.network(
                                music.imageUrl,
                                height: imageHeight,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              music.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.035,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              music.artist,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: screenWidth * 0.03,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: Icon(
                                  isFav ? Icons.favorite : Icons.favorite_border,
                                  color: isFav ? Colors.red : Colors.white54,
                                  size: screenWidth * 0.06,
                                ),
                                onPressed: () {
                                  favoriteService.toggleFavorite(music);
                                },
                              ),
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
    );
  }
}
