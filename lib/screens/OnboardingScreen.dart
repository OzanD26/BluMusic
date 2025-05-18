import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';import '../main.dart';

import 'main_navigation.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> pages = [
    {
      "title": "Müzikler",
      "desc": "Dinlemek için en iyi parçaları keşfet. Beğen, çal ve keyfini çıkar.",
      "image": "https://cdn.pixabay.com/photo/2015/07/17/22/43/student-849825_1280.jpg"
    },
    {
      "title": "Favoriler",
      "desc": "Beğendiğin müzikleri favorilerine ekleyerek hızlıca eriş.",
      "image": "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4"
    },
    {
      "title": "Başlayalım!",
      "desc": "Müziğin ritmine kapılmaya hazır mısın?",
      "image": "https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f"
    }
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainNavigation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageSize = screenHeight * 0.28;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C2E),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return Column(
                    children: [
                      SizedBox(height: screenHeight * 0.05),
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(screenWidth * 0.3),
                          topRight: Radius.circular(screenWidth * 0.3),
                        ),
                        child: Image.network(
                          page['image']!,
                          width: imageSize,
                          height: imageSize,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Text(
                        page['title']!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.07,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.1,
                          vertical: screenHeight * 0.015,
                        ),
                        child: Text(
                          page['desc']!,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: screenWidth * 0.035,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          pages.length,
                              (i) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentIndex == i ? 10 : 8,
                            height: _currentIndex == i ? 10 : 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == i
                                  ? Colors.white
                                  : Colors.white24,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      GestureDetector(
                        onTap: _completeOnboarding,
                        child: Container(
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          margin: EdgeInsets.only(bottom: screenHeight * 0.03),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.deepPurple,
                            size: screenWidth * 0.07,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
