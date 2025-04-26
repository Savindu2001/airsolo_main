import 'package:airsolo/common/widgets/custome_shapes/containers/primary_hader_container.dart';
import 'package:airsolo/features/tripGenie/screens/place_guide_screen.dart';
import 'package:airsolo/features/tripGenie/screens/trip_maker_screen.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:airsolo/utils/constants/colors.dart';

class AIHomeScreen extends StatelessWidget {
  const AIHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: APrimaryHeaderContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            const SizedBox(height: ASizes.spaceBtwSections *3,),
            
            const SizedBox(height: 20),
            Text(
              'TripGenie',
              style: Get.textTheme.headlineMedium!.copyWith(color: AColors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
             Text(
              'AirSolo Ai for travelrs in srilanka',
              textAlign: TextAlign.center,
              style: Get.textTheme.titleMedium!.copyWith(color: AColors.white),
            ),
            const SizedBox(height: 40),
            _buildFeatureCard(
              icon: Iconsax.map,
              title: 'Place Guide',
              subtitle: 'Get detailed information about your current location',
              color: AColors.primary,
              onTap: () => Get.to(() => const PlaceGuideScreen()),
            ),
            const SizedBox(height: 20),
            _buildFeatureCard(
              icon: Iconsax.calendar,
              title: 'Trip Maker',
              subtitle: 'Plan your perfect trip with AI',
              color: AColors.primary,
              onTap: () => Get.to(() => const TripMakerScreen()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Iconsax.arrow_right_3, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}