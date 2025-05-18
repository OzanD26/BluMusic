import 'package:flutter/material.dart';
import '../models/music_model.dart';

class MusicCard extends StatelessWidget {
  final Music music;
  final VoidCallback onTap;

  const MusicCard({required this.music, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                music.imageUrl,
                height: 160,
                width: 160,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              music.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(music.artist, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
