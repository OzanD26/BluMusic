import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'data/favorites.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/library_screen.dart';
import 'screens/profile_screen.dart';
import 'models/music_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Sistem çubuğu renklerini koyulaştır
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xFF181828),
    systemNavigationBarColor: Color(0xFF181828),
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  // Favori URL'leri önceden yükle
  final favoriteService = FavoriteService();
  await favoriteService.preloadSavedUrls();

  runApp(
    ChangeNotifierProvider.value(
      value: favoriteService,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF181828),
        primarySwatch: Colors.deepPurple,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF181828),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final ValueNotifier<List<Music>> _allMusic = ValueNotifier<List<Music>>([]);

  void _updateMusicList(List<Music> newMusic) {
    _allMusic.value = newMusic;

    final favoriteService = Provider.of<FavoriteService>(context, listen: false);
    favoriteService.loadFavorites(newMusic);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      HomeScreen(onMusicLoaded: _updateMusicList),
      ValueListenableBuilder<List<Music>>(
        valueListenable: _allMusic,
        builder: (context, musicList, _) {
          return LibraryScreen(allMusic: musicList);
        },
      ),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF181828),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1C1C2E),
        currentIndex: _currentIndex,
        selectedItemColor: Colors.purpleAccent,
        unselectedItemColor: Colors.white54,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Anasayfa"),
          BottomNavigationBarItem(icon: Icon(Icons.library_music), label: "Kütüphane"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}
