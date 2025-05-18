import 'package:flutter/material.dart';
import '../data/favorites.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181828),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181828),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Profil",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.deepPurple,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              "Ozan Doğan",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 32),
            _buildProfileOption(
              icon: Icons.dark_mode,
              title: "Karanlık Mod",
              trailing: Switch(
                value: true,
                onChanged: (val) {}, // Tema geçişini buraya bağlayabilirsin
                activeColor: Colors.deepPurpleAccent,
              ),
            ),
            _buildProfileOption(
              icon: Icons.info_outline,
              title: "Uygulama Sürümü",
              trailing: const Text("v1.0.0", style: TextStyle(color: Colors.white70)),
            ),
            _buildProfileOption(
              icon: Icons.privacy_tip_outlined,
              title: "Gizlilik Politikası",
            ),
            _buildProfileOption(
              icon: Icons.share,
              title: "Bu uygulamayı paylaş",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    Widget? trailing,
  }) {
    return Card(
      color: Colors.white10,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurpleAccent),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: trailing,
        onTap: () {},
      ),
    );
  }
}
