import 'package:airsolo/common/widgets/map_widgets/embed_map.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:airsolo/utils/popups/loaders.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/hostel_controller.dart';
import '../models/hostel_model.dart';
import '../models/room_model.dart';
import 'room_detail_screen.dart';



class HostelDetailScreen extends StatefulWidget {
  final String hostelId;

  const HostelDetailScreen({super.key, required this.hostelId});

  @override
  State<HostelDetailScreen> createState() => _HostelDetailScreenState();
}

class _HostelDetailScreenState extends State<HostelDetailScreen> {
  final controller = Get.find<HostelController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadHostelDetails(widget.hostelId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Hostel'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.refresh),
            onPressed: () => controller.loadHostelDetails(widget.hostelId),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isDetailLoading.value) {
          return _buildLoadingShimmer();
        }

        final hostel = controller.selectedHostel.value;
        if (hostel == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 50, color: Colors.red),
                const SizedBox(height: ASizes.md),
                Text(
                  controller.error.value.isNotEmpty 
                      ? controller.error.value 
                      : 'Hostel not found',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: ASizes.md),
                ElevatedButton(
                  onPressed: () => controller.loadHostelDetails(widget.hostelId),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadHostelDetails(widget.hostelId),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Gallery
                _buildImageGallery(hostel, context),
                
                // Basic Info
                Padding(
                  padding: const EdgeInsets.all(ASizes.defaultSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hostel.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: ASizes.sm),
                      Row(
                        children: [
                          const Icon(Iconsax.location, size: 16),
                          const SizedBox(width: ASizes.xs),
                          Expanded(
                            child: Text(
                              hostel.address ?? 'No address provided',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: ASizes.sm),
                      Row(
                        children: [
                          const Icon(Iconsax.like_tag, color: Colors.amber, size: 16),
                          const SizedBox(width: ASizes.xs),
                          Text(
                            hostel.rating?.toStringAsFixed(1) ?? 'N/A',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          if (hostel.contactNumber != null)
                            IconButton(
                              icon: const Icon(Iconsax.call),
                              onPressed: () => _launchUrl('tel:${hostel.contactNumber}'),
                            ),
                          if (hostel.website != null)
                            IconButton(
                              icon: const Icon(Iconsax.global),
                              onPressed: () => _launchUrl(hostel.website!),
                            ),
                        ],
                      ),
                      const SizedBox(height: ASizes.md),
                      
                      // Description
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: ASizes.sm),
                      Text(
                        hostel.description ?? 'No description provided',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: ASizes.md),
                      
                     // Location Map
                      if (hostel.latitude != null && hostel.longitude != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Location',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                IconButton(
                                  icon: const Icon(Iconsax.location),
                                  onPressed: () => _showMapChooser(
                                    context,
                                    hostel.latitude!,
                                    hostel.longitude!,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: ASizes.sm),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(ASizes.cardRadiusMd),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(ASizes.cardRadiusMd),
                                child: MapBox(
                                  latitude: hostel.latitude!,
                                  longitude: hostel.longitude!,
                                ),
                              ),
                            ),
                          ],
                        ),

                                        
                     
                      const SizedBox(height: ASizes.md),
                      
                      // Facilities
                      Obx(() {
                        if (controller.isLoadingFacilities.value) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        return controller.facilities.isEmpty
                            ? const SizedBox()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Facilities',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: ASizes.sm),
                                  Wrap(
                                    spacing: ASizes.sm,
                                    runSpacing: ASizes.sm,
                                    children: controller.facilities
                                        .map((facility) => Chip(
                                              label: Text(facility.name),
                                              avatar: Icon(
                                                _getFacilityIcon(facility.icon.toString()),
                                                size: 20,
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ],
                              );
                      }),
                      const SizedBox(height: ASizes.md),
                      
                      // House Rules
                      Obx(() {
                        if (controller.isLoadingHouseRules.value) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'House Rules',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: ASizes.sm),
                            if (controller.houseRules.isEmpty)
                              Text(
                                'No house rules specified and Standard hostel rules apply',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              
                            ...controller.houseRules.map((rule) => Padding(
                              padding: const EdgeInsets.only(bottom: ASizes.sm),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.circle, size: 8, color: Theme.of(context).primaryColor),
                                  const SizedBox(width: ASizes.sm),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          rule.rule,
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                        if (rule.description != null)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4),
                                            child: Text(
                                              rule.description!,
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ],
                        );
                      }),
                      const SizedBox(height: ASizes.md),
                      
                      // Rooms Section
                      Obx(() {
                        if (controller.isLoadingRooms.value) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Available Rooms',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: ASizes.sm),
                            if (controller.rooms.isEmpty)
                              const Text('No rooms available'),
                            ...controller.rooms.map((room) => _RoomCard(room: room)),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  IconData _getFacilityIcon(String? iconName) {
   
    switch (iconName) {
      case 'wifi':
        return Icons.wifi;
      case 'pool':
        return Icons.pool;
      
      default:
        return Icons.check;
    }
  }

  Widget _buildImageGallery(Hostel hostel, BuildContext context) {
    if (hostel.gallery.isEmpty) {
      return _buildDefaultImage();
    }

    return SizedBox(
      height: 250,
      child: PageView.builder(
        itemCount: hostel.gallery.length,
        itemBuilder: (context, index) {
          return CachedNetworkImage(
            imageUrl: hostel.gallery[index],
            fit: BoxFit.cover,
            width: double.infinity,
            placeholder: (context, url) => Container(
              color: Colors.grey[200],
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            errorWidget: (context, url, error) => _buildDefaultImage(),
          );
        },
      ),
    );
  }



  Widget _buildDefaultImage() {
    return Image.asset(
      AImages.defaultCityImage,
      fit: BoxFit.cover,
      width: double.infinity,
      height: 250,
    );
  }

  Widget _buildLoadingShimmer() {
    final dark = AHelperFunctions.isDarkMode(Get.context!);
    
    return SingleChildScrollView(
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: dark ? Colors.grey[700]! : Colors.grey[300]!,
            highlightColor: dark ? Colors.grey[600]! : Colors.grey[100]!,
            child: Container(
              height: 250,
              width: double.infinity,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(ASizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 24,
                  color: Colors.white,
                ),
                const SizedBox(height: ASizes.sm),
                Container(
                  width: 200,
                  height: 16,
                  color: Colors.white,
                ),
                const SizedBox(height: ASizes.md),
                Container(
                  width: double.infinity,
                  height: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: ASizes.md),
                Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.white,
                ),
                const SizedBox(height: ASizes.md),
                Container(
                  width: 100,
                  height: 20,
                  color: Colors.white,
                ),
                const SizedBox(height: ASizes.sm),
                Wrap(
                  spacing: ASizes.sm,
                  runSpacing: ASizes.sm,
                  children: List.generate(6, (index) => Container(
                    width: 80,
                    height: 30,
                    color: Colors.white,
                  )),
                ),
                const SizedBox(height: ASizes.md),
                Container(
                  width: 100,
                  height: 20,
                  color: Colors.white,
                ),
                const SizedBox(height: ASizes.sm),
                ...List.generate(3, (index) => Padding(
                  padding: const EdgeInsets.only(bottom: ASizes.sm),
                  child: Container(
                    width: double.infinity,
                    height: 16,
                    color: Colors.white,
                  ),
                )),
                const SizedBox(height: ASizes.md),
                Container(
                  width: 120,
                  height: 20,
                  color: Colors.white,
                ),
                const SizedBox(height: ASizes.sm),
                ...List.generate(3, (index) => Padding(
                  padding: const EdgeInsets.only(bottom: ASizes.md),
                  child: Container(
                    width: double.infinity,
                    height: 120,
                    color: Colors.white,
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      Get.snackbar('Error', 'Could not launch $url');
    }
  }

  Future<bool> _openAppleMaps(double lat, double lng) async {
    final url = Uri.parse('https://maps.apple.com/?q=$lat,$lng');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
        return true;
      }
    } catch (e) {
      debugPrint('Error opening Apple Maps: $e');
    }
    return false;
  }

  Future<bool> _openGoogleMaps(double lat, double lng) async {
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
        return true;
      }
    } catch (e) {
      debugPrint('Error opening Google Maps: $e');
    }
    
    ALoaders.warningSnackBar(
      title: 'Maps App Not Found', 
      message: 'Opening in browser instead'
    );
    return await launchUrl(
      Uri.parse('https://maps.google.com?q=$lat,$lng'),
      mode: LaunchMode.externalApplication,
    );
  }

  void _showMapChooser(BuildContext context, double lat, double lng) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            
            Text(
              'Open in Maps',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMapOption(
                  context,
                  icon: Icons.map,
                  color: Colors.red,
                  label: 'Google Maps',
                  onTap: () {
                    Navigator.pop(context);
                    _openGoogleMaps(lat, lng);
                  },
                ),
                if (isIOS)
                  _buildMapOption(
                    context,
                    icon: Icons.directions,
                    color: Colors.blue,
                    label: 'Apple Maps',
                    onTap: () {
                      Navigator.pop(context);
                      _openAppleMaps(lat, lng);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildMapOption(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  final Room room;

  const _RoomCard({required this.room});

  @override
  Widget build(BuildContext context) {
    final dark = AHelperFunctions.isDarkMode(context);
    final hasImages = room.images.isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: ASizes.defaultSpace),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ASizes.cardRadiusLg),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(ASizes.cardRadiusLg),
        onTap: () => Get.to(() => RoomDetailScreen(room: room)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(ASizes.cardRadiusLg),
                topRight: Radius.circular(ASizes.cardRadiusLg),
              ),
              child: SizedBox(
                height: 180,
                width: double.infinity,
                child: hasImages
                    ? CachedNetworkImage(
                        imageUrl: room.images.first,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => _buildImagePlaceholder(),
                        errorWidget: (context, url, error) => _buildImagePlaceholder(),
                      )
                    : _buildImagePlaceholder(),
              ),
            ),
            // Details
            Padding(
              padding: const EdgeInsets.all(ASizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(room.name, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: ASizes.sm),
                  Row(
                    children: [
                      Icon(Icons.hotel, size: 16, color: dark ? AColors.light : AColors.dark),
                      const SizedBox(width: ASizes.xs),
                      Text(
                        room.type.toString().split('.').last.replaceAll('_', ' '),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: ASizes.sm),
                  Row(
                    children: [
                      Icon(Icons.bed, size: 16, color: dark ? AColors.light : AColors.dark),
                      const SizedBox(width: ASizes.xs),
                      Text(
                        '${room.bedQty} ${room.bedType.toString().split('.').last.replaceAll('_', ' ')}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const Spacer(),
                      Text(
                        room.formattedPrice,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Image.asset(
      AImages.defaultCityImage,
      fit: BoxFit.cover,
    );
  }
}
extension RoomTypeExtension on RoomType {
  String get displayName {
    return toString().split('.').last.replaceAll('_', ' ').toUpperCase();
  }

 
}