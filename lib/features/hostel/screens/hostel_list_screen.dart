import 'package:airsolo/features/hostel/models/room_model.dart';
import 'package:airsolo/features/hostel/screens/hostel_detail_screen.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/hostel_controller.dart';
import '../models/hostel_model.dart';

class HostelListScreen extends StatelessWidget {
  final HostelController _controller = Get.put(HostelController());

  HostelListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = AHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hostels'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(ASizes.defaultSpace),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search hostels...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ASizes.cardRadiusLg),
                ),
                filled: true,
                fillColor: dark ? AColors.darkGrey : Colors.grey[200],
              ),
              onChanged: (value) => _controller.searchQuery.value = value,
            ),
          ),

          // Hostel List
          Expanded(
            child: Obx(() {
              if (_controller.isLoading.value && _controller.hostels.isEmpty) {
                return _buildLoadingList();
              }

              if (_controller.error.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 50, color: Colors.red),
                      const SizedBox(height: ASizes.md),
                      Text(
                        _controller.error.value,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: ASizes.md),
                      ElevatedButton(
                        onPressed: () => _controller.fetchHostels(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (_controller.filteredHostels.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 50, color: Colors.grey),
                      const SizedBox(height: ASizes.md),
                      Text(
                        'No hostels found',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: ASizes.md),
                      if (_controller.searchQuery.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                _controller.searchQuery.value = '';
                                _controller.filterHostels();
                              },
                              child: const Text('Clear search'),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => _controller.fetchHostels(),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ASizes.defaultSpace,
                    vertical: ASizes.sm,
                  ),
                  itemCount: _controller.filteredHostels.length,
                  itemBuilder: (context, index) {
                    final hostel = _controller.filteredHostels[index];
                    return _HostelCard(hostel: hostel);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingList() {
    return ListView.builder(
      padding: const EdgeInsets.all(ASizes.defaultSpace),
      itemCount: 6,
      itemBuilder: (_, __) => const _HostelCardSkeleton(),
    );
  }

  void _showFilterBottomSheet() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: AHelperFunctions.isDarkMode(Get.context!)
              ? AColors.dark
              : Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(ASizes.cardRadiusLg),
          ),
        ),
        padding: const EdgeInsets.all(ASizes.defaultSpace),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: ASizes.md),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Filter Hostels',
              style: Theme.of(Get.context!).textTheme.titleLarge,
            ),
            const SizedBox(height: ASizes.spaceBtwSections),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      if (Get.isBottomSheetOpen ?? false) {
                        Get.back(); 
                      }
                    },
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: ASizes.spaceBtwItems),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _controller.filterHostels();
                      if (Get.isBottomSheetOpen ?? false) {
                        Get.back(); 
                      }
                    },
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HostelCard extends StatelessWidget {
  final Hostel hostel;

  const _HostelCard({required this.hostel});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HostelController>();
    
return Obx( (){

      final dark = AHelperFunctions.isDarkMode(context);
      final firstImage = hostel.gallery.isNotEmpty ? hostel.gallery.first : null;
      final hasImages = firstImage != null;
      final isLoading = controller.isDetailLoading.value && 
                       controller.selectedHostel.value?.id == hostel.id;
      final rooms = controller.getRoomsForHostel(hostel.id);
      final hasRooms = rooms.isNotEmpty;


      return Card(
        margin: const EdgeInsets.only(bottom: ASizes.defaultSpace),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ASizes.cardRadiusLg),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(ASizes.cardRadiusLg),
          onTap: () {
            final controller = Get.find<HostelController>();
            controller.selectedHostel.value = null;
            controller.isDetailLoading.value = true;
            Get.to(() => HostelDetailScreen(hostelId: hostel.id));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(ASizes.cardRadiusLg),
                  topRight: Radius.circular(ASizes.cardRadiusLg),
                ),
                child: AspectRatio(
                  aspectRatio: 16/9,
                  child: _buildImageContent(firstImage, context)),
              ),
              // Details Section
              Padding(
                padding: const EdgeInsets.all(ASizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hostel.name,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: ASizes.sm),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16),
                        const SizedBox(width: ASizes.xs),
                        Expanded(
                          child: Text(
                            hostel.address ?? 'No address provided',
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: ASizes.sm),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: ASizes.xs),
                        Text(
                          hostel.rating?.toStringAsFixed(1) ?? 'N/A',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const Spacer(),
                        Text(
                          hasRooms 
                          ? getPriceRange(rooms)
                          : 'Look hostel',
                          
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    );}
    );
  }

Widget _buildImageContent(String? imageUrl, BuildContext context) {
  if (_isValidImageUrl(imageUrl)) {
    
    return _buildDefaultImage();
  }

  return CachedNetworkImage(
    imageUrl: imageUrl!,
    fit: BoxFit.cover,
    width: double.infinity,
    height: double.infinity,
    placeholder: (context, url) => Container(
      color: Colors.grey[200],
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AColors.primary),
        ),
      ),
    ),
    errorWidget: (context, url, error) => _buildDefaultImage(),
  );
}

bool _isValidImageUrl(String? url) {
    if (url == null) return false;
    final uri = Uri.tryParse(url);
    return uri != null && 
           uri.hasAbsolutePath &&
           (uri.scheme == 'http' || uri.scheme == 'https') &&
           !url.contains('airsolo-assets.s3-ap-southeast-1.amazonaws.com/hostels/') &&
           ['jpg', 'jpeg', 'png', 'webp'].contains(url.split('.').last.toLowerCase());
  }

Widget _buildDefaultImage() {
  return Image.asset(
    AImages.hostelImage1,
    fit: BoxFit.cover,
    width: double.infinity,
    height: double.infinity,
  );
}


String getPriceRange(List<Room> rooms) {
  if (rooms.isEmpty) return 'Loading prices...';
  
  final validPrices = rooms
      .where((room) => room.pricePerPerson != null && room.pricePerPerson! > 0)
      .map((room) => room.pricePerPerson!)
      .toList();

  if (validPrices.isEmpty) return 'look';
  
  validPrices.sort();
  final min = validPrices.first;
  final max = validPrices.last;

  return min == max 
      ? '\$${min.toStringAsFixed(2)}' 
      : '\$${min.toStringAsFixed(2)} - \$${max.toStringAsFixed(2)}';
}

}

class _HostelCardSkeleton extends StatelessWidget {
  const _HostelCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final dark = AHelperFunctions.isDarkMode(context);

    return Card(
      margin: const EdgeInsets.only(bottom: ASizes.defaultSpace),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ASizes.cardRadiusLg),
      ),
      child: Shimmer.fromColors(
        baseColor: dark ? Colors.grey[700]! : Colors.grey[300]!,
        highlightColor: dark ? Colors.grey[600]! : Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              width: double.infinity,
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.all(ASizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(height: ASizes.sm),
                  Container(
                    width: 150,
                    height: 16,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
