import 'package:airsolo/features/hostel/models/room_model.dart';
import 'package:airsolo/features/hostel/screens/booking_screen.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:airsolo/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RoomDetailScreen extends StatelessWidget {
  final Room room;

  RoomDetailScreen({Key? key, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = AHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(room.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareRoomDetails(room),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Room Images Carousel
            _buildImageCarousel(room, context),
            
            // Room Details
            Padding(
              padding: const EdgeInsets.all(ASizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price and Type
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            room.formattedPrice,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AColors.primary,
                            ),
                          ),
                          Text(
                            'per person per night',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      Chip(
                        label: Text(
                          room.typeDisplayName,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: ASizes.spaceBtwItems),
                  
                  // Room Features
                  _buildRoomFeatures(room, dark),
                  const SizedBox(height: ASizes.spaceBtwSections),
                  
                  // Description
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: ASizes.sm),
                  Text(
                    room.description ?? 'The ${room.name} is designed with traveler convenience in mind, featuring comfortable bedding, ample storage, and easy access to all hostel facilities.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: ASizes.spaceBtwSections),
                  
                  // Bed Details
                  _buildBedDetails(room, dark),
                  const SizedBox(height: ASizes.spaceBtwSections),
                  
                  // General Facilities
                    _buildFacilitiesSection(context, 'Facilities', _generalFacilities),
                  
                  const SizedBox(height: ASizes.spaceBtwSections),
                  
                  // Bathroom Facilities
                  _buildFacilitiesSection(context, 'Bathroom Facilities', _bathroomFacilities),
                  
                  // Booking Button
                  const SizedBox(height: ASizes.spaceBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _bookRoom(room),
                      child: const Text('Book Now'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Sample general facilities data
  final List<Facility> _generalFacilities = [
    Facility(id: '1', name: 'Free WiFi', icon: Icons.wifi),
    Facility(id: '2', name: 'Air Conditioning', icon: Icons.ac_unit),
    Facility(id: '3', name: 'Locker', icon: Icons.lock),
    Facility(id: '4', name: 'Laundry', icon: Icons.local_laundry_service),
    Facility(id: '5', name: 'Kitchen', icon: Icons.kitchen),
    Facility(id: '6', name: 'TV Lounge', icon: Icons.tv),
    Facility(id: '7', name: '24/7 Reception', icon: Icons.desk),
    Facility(id: '8', name: 'Security', icon: Icons.security),
    Facility(id: '9', name: 'Breakfast', icon: Icons.breakfast_dining),
    Facility(id: '10', name: 'Common Area', icon: Icons.chair),
  ];

  // Sample bathroom facilities data
  final List<Facility> _bathroomFacilities = [
    Facility(id: '11', name: 'Shower', icon: Icons.shower),
    Facility(id: '12', name: 'Hair Dryer', icon: Icons.dry_cleaning),
    Facility(id: '13', name: 'Towels', icon: Icons.clean_hands),
    Facility(id: '14', name: 'Toiletries', icon: Icons.soap),
    Facility(id: '15', name: 'Hot Water', icon: Icons.water_damage),
    Facility(id: '16', name: 'Mirror', icon: Icons.troubleshoot),
    Facility(id: '17', name: 'Sink', icon: Icons.wash),
    Facility(id: '18', name: 'Shared Bathroom', icon: Icons.bathtub),
    Facility(id: '19', name: 'Private Bathroom', icon: Icons.bathroom),
    Facility(id: '20', name: 'Vanity Area', icon: Icons.face_retouching_natural),
  ];

  Widget _buildImageCarousel(Room room, BuildContext context) {
    final images = room.images;
    return SizedBox(
      height: 300,
      child: images.isEmpty
          ? Image.asset(
              AImages.defaultRoomImage,
              fit: BoxFit.cover,
              width: double.infinity,
            )
          : PageView.builder(
              itemCount: images.length,
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: images[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    AImages.defaultRoomImage,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
    );
  }

  Widget _buildRoomFeatures(Room room, bool dark) {
    return Wrap(
      spacing: ASizes.spaceBtwItems,
      runSpacing: ASizes.spaceBtwItems,
      children: [
        _buildFeatureItem(
          icon: Icons.people,
          label: 'Max ${room.maxOccupancy} guests',
          dark: dark,
        ),
        _buildFeatureItem(
          icon: Icons.bed,
          label: room.bedQuantityDescription,
          dark: dark,
        ),
        //if (room.size != null)
          _buildFeatureItem(
            icon: Icons.aspect_ratio,
            label: room.sizeDescription!,
            dark: dark,
          ),
        //if (room.hasPrivateBathroom)
          _buildFeatureItem(
            icon: Icons.bathtub,
            label: 'Private bathroom',
            dark: dark,
          ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String label,
    required bool dark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: dark ? AColors.darkGrey : AColors.grey,
        borderRadius: BorderRadius.circular(ASizes.cardRadiusMd),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: dark ? AColors.light : AColors.dark),
          const SizedBox(width: ASizes.xs),
          Text(label, style: Theme.of(Get.context!).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildBedDetails(Room room, bool dark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bed Configuration',
          style: Theme.of(Get.context!).textTheme.titleLarge,
        ),
        const SizedBox(height: ASizes.sm),
        Container(
          padding: const EdgeInsets.all(ASizes.md),
          decoration: BoxDecoration(
            color: dark ? AColors.darkerGrey : AColors.light,
            borderRadius: BorderRadius.circular(ASizes.cardRadiusLg),
          ),
          child: Row(
            children: [
              Icon(Icons.bed, size: 24, color: AColors.primary),
              const SizedBox(width: ASizes.spaceBtwItems),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.bedQuantityDescription,
                      style: Theme.of(Get.context!).textTheme.bodyLarge,
                    ),
                    if (room.bedDescription != null)
                      Padding(
                        padding: const EdgeInsets.only(top: ASizes.xs),
                        child: Text(
                          room.bedDescription!,
                          style: Theme.of(Get.context!).textTheme.bodySmall,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFacilitiesSection(BuildContext context, String title, List<Facility> facilities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: ASizes.sm),
        Wrap(
          spacing: ASizes.sm,
          runSpacing: ASizes.sm,
          children: facilities.map((facility) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getRandomColor(context),
                borderRadius: BorderRadius.circular(ASizes.cardRadiusLg),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(facility.icon, size: 16),
                  const SizedBox(width: ASizes.xs),
                  Text(facility.name, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white)),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getRandomColor(BuildContext context) {
    final colors = [
      AColors.primary,
      AColors.success,
      AColors.warning,
      AColors.info,
    ];
    return colors[DateTime.now().millisecondsSinceEpoch % colors.length];
  }

  void _shareRoomDetails(Room room) {
    final text = 'Check out this ${room.name} for ${room.formattedPrice} per person';
    ALoaders.successSnackBar(title: 'Share', message: 'Room details copied to clipboard');
  }

  void _bookRoom(Room room) {
    Get.to(() => BookingScreen(room: room));
  }
}

class Facility {
  final String id;
  final String name;
  final IconData icon;

  Facility({required this.id, required this.name, required this.icon});
}