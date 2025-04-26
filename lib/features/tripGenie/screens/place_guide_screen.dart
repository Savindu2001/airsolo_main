import 'package:airsolo/features/tripGenie/controllers/ai_controller.dart';
import 'package:airsolo/features/tripGenie/screens/results_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:airsolo/utils/constants/colors.dart';

class PlaceGuideScreen extends StatelessWidget {
  const PlaceGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AIController());
    final locationController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Guide'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Get information about any location',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                prefixIcon: const Icon(Iconsax.location),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Enter city or current location',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Iconsax.gps, size: 20),
                    label: const Text('Use Current Location'),
                    onPressed: () {
                      // Implement GPS location fetching
                      locationController.text = 'Current Location';
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                        await controller.getPlaceGuide(locationController.text);
                        if (controller.placeGuide.value != null) {
                          Get.to(() => ResultsScreen(
                            title: 'Place Guide for ${locationController.text}',
                            content: controller.placeGuide.value!.guideDetails,
                          ));
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                        'Get Guide',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}