import 'package:airsolo/features/city/model/city_model.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CityDetailScreen extends StatelessWidget {
  final City city;

  const CityDetailScreen({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    final dark = AHelperFunctions.isDarkMode(context);
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'city-image-${city.id}',
                child: CachedNetworkImage(
                  imageUrl: city.imageUrl ?? AImages.defaultCityImage,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (_, __, ___) => Image.asset(AImages.defaultCityImage),
                ),
              ),
              title: Text(
                city.name,
                style: TextStyle(
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.8),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Iconsax.heart),
                onPressed: () {}, // Add to favorites
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {}, // Share city
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(ASizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // About Section
                  Text(
                    'About ${city.name}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: ASizes.spaceBtwItems),
                  Text(
                    city.description ?? 'No description available',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: ASizes.spaceBtwSections),
                  
                  // Highlights Section
                  const Text(
                    'City Highlights',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: ASizes.spaceBtwItems),
                  _buildHighlights(),
                  const SizedBox(height: ASizes.spaceBtwSections),
                  
                  // Popular Places
                  const Text(
                    'Popular Places',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: ASizes.spaceBtwItems),
                  _buildPopularPlaces(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildHighlights() {
    return Wrap(
      spacing: ASizes.sm,
      runSpacing: ASizes.sm,
      children: [
        _buildHighlightChip('Safe', Iconsax.security_safe),
        _buildHighlightChip('Affordable', Iconsax.wallet),
        _buildHighlightChip('Public Transport', Iconsax.bus),
        _buildHighlightChip('Tourist Friendly', Iconsax.map),
      ],
    );
  }

  Widget _buildHighlightChip(String text, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(text),
      backgroundColor: Colors.blue,
    );
  }

  Widget _buildPopularPlaces() {
    // Replace with actual places data from your city model
    final places = [
      {'name': 'Central Park', 'image': AImages.defaultCityImage},
      {'name': 'Museum of Art', 'image': AImages.defaultCityImage},
      {'name': 'Downtown', 'image': AImages.defaultCityImage},
    ];
    
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: places.length,
        itemBuilder: (context, index) {
          final place = places[index];
          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: ASizes.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(ASizes.cardRadiusMd),
                  child: Image.asset(
                    place['image']!,
                    width: 160,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: ASizes.xs),
                Text(
                  place['name']!,
                  style: Theme.of(context).textTheme.labelLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ASizes.defaultSpace,
        vertical: ASizes.sm,
      ),
      decoration: BoxDecoration(
        color: AHelperFunctions.isDarkMode(context) 
            ? AColors.darkGrey 
            : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Handle explore action
                Get.snackbar('Explore', 'Exploring ${city.name}');
              },
              child: const Text('Explore City'),
            ),
          ),
          const SizedBox(width: ASizes.sm),
          IconButton(
            icon: const Icon(Iconsax.map_1),
            onPressed: () {
              // Open map
              Get.snackbar('Map - AirSolo', 'Opening map for ${city.name}');
            },
          ),
        ],
      ),
    );
  }
}