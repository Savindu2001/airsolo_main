import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';

class TripGenieHomeScreen extends StatelessWidget {
  const TripGenieHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TripGenie")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Hero Section
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage(AImages.banner1),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text("Your AI-Powered Travel Guide", 
                  style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              ),
            ),
            const SizedBox(height: 20),
            // Quick Actions
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.3,
              children: [
                _buildFeatureButton(Icons.map, "Generate Trip Plan", () {}),
                _buildFeatureButton(Icons.save, "My Saved Trips", () {}),
                _buildFeatureButton(Icons.mic, "Voice Guide", () {}),
                _buildFeatureButton(Icons.chat, "Chat with TripGenie", () {}),
                _buildFeatureButton(Icons.directions, "Live Navigation", () {}),
              ],
            ),
            const SizedBox(height: 20),
            // Dynamic Trip Recommendations
            const Text("Popular Destinations", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildRecommendationCard("Sigiriya", "assets/sigiriya.jpg"),
                  _buildRecommendationCard("Ella", "assets/ella.jpg"),
                  _buildRecommendationCard("Mirissa", "assets/mirissa.jpg"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureButton(IconData icon, String title, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40),
          const SizedBox(height: 10),
          Text(title, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(String name, String image) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
      ),
      child: Center(
        child: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
