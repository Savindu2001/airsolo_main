import 'package:airsolo/features/city/controller/city_controller.dart';
import 'package:airsolo/features/city/model/city_model.dart';
import 'package:airsolo/features/city/screen/city_screen.dart';
import 'package:airsolo/features/informations/screen/information_screen.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:airsolo/utils/popups/loaders.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class CityDetailScreen extends StatefulWidget {
  final City city;

  const CityDetailScreen({super.key, required this.city});

  @override
  State<CityDetailScreen> createState() => _CityDetailScreenState();
}

class _CityDetailScreenState extends State<CityDetailScreen> {
  final PageController _pageController = PageController();
  final RxInt _currentPage = 0.obs;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      _currentPage.value = _pageController.page?.round() ?? 0;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = AHelperFunctions.isDarkMode(context);
    final hasMultipleImages = widget.city.images.length > 1;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildImageGallery(hasMultipleImages),
              title: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  widget.city.name,
                  style: const TextStyle(
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Iconsax.heart,
                  color: Colors.white,
                ),
                onPressed: _toggleFavorite,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(ASizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasMultipleImages) _buildPhotoGalleryIndicator(),
                  const SizedBox(height: ASizes.spaceBtwSections),
                  _buildAboutSection(),
                  const SizedBox(height: ASizes.spaceBtwSections),
                  _buildHighlightsSection(),
                  const SizedBox(height: ASizes.spaceBtwSections),
                  _thingToDo(),
                  const SizedBox(height: ASizes.spaceBtwSections),
                  _buildPopularPlacesSection(),


                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _thingToDo() {
    return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Things to Do',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.city.thingsToDo
                            .map((thing) => _buildHighlightChip(thing, Iconsax.star, AColors.buttonPrimary))
                            .toList(),
                      ),
                    ],
                  );
  }

  Widget _buildImageGallery(bool hasMultipleImages) {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: widget.city.images.isEmpty ? 1 : widget.city.images.length,
          itemBuilder: (context, index) {
            final imageUrl = widget.city.images.isEmpty
                ? null
                : widget.city.images[index];
            return Hero(
              tag: widget.city.images.isEmpty
                  ? 'city-default-${widget.city.id}'
                  : 'city-image-${widget.city.id}-$index',
              child: _buildCityImage(imageUrl),
            );
          },
        ),
        if (hasMultipleImages)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.city.images.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage.value == index
                          ? AColors.primary
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCityImage(String? imageUrl) {
    if (imageUrl == null || !_isValidImageUrl(imageUrl)) {
      return Image.asset(
        AImages.defaultCityImage,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: Colors.grey[200],
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AColors.primary),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Image.asset(
        AImages.defaultCityImage,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About  ${widget.city.name}',
          style: Get.textTheme.headlineSmall,
        ),
        const SizedBox(height: ASizes.spaceBtwItems),
        Text(
          widget.city.description ?? 'No description available',
          style: Get.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildPhotoGalleryIndicator() {
    return Row(
      children: [
        const Icon(Iconsax.gallery, size: 20),
        const SizedBox(width: ASizes.sm),
        Text(
          '${widget.city.images.length} photos avilable',
          style: Get.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildHighlightsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('City Highlights'),
        const SizedBox(height: ASizes.spaceBtwItems),
        Wrap(
          spacing: ASizes.sm,
          runSpacing: ASizes.sm,
          children: [
            _buildHighlightChip('Safe', Iconsax.security_safe, AColors.homePrimary),
            _buildHighlightChip('Affordable', Iconsax.wallet, AColors.primary),
            _buildHighlightChip('Food', Iconsax.coffee, AColors.warning),
            _buildHighlightChip('Transport', Iconsax.bus, Colors.green),
            _buildHighlightChip('Tourist Friendly', Iconsax.map, Colors.purple),
          ],
        ),
      ],
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
            ? AColors.dark
            : Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _exploreCity,
              child: const Text('Explore City Informations'),
            ),
          ),
          const SizedBox(width: ASizes.sm),
          IconButton(
            icon: const Icon(Iconsax.map_1),
            onPressed: _showMapChooser,
          ),
        ],
      ),
    );
  }

  bool _isValidImageUrl(String? url) {
    if (url == null) return false;
    final uri = Uri.tryParse(url);
    return uri != null &&
        uri.hasAbsolutePath &&
        (uri.scheme == 'http' || uri.scheme == 'https');
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildHighlightChip(String text, IconData icon, Color color) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Colors.white,),
      label: Text(text ,style: const TextStyle(color: Colors.white),),
      backgroundColor: color,
    );
  }

  void _toggleFavorite() {
    ALoaders.successSnackBar(title: 'Favorite', message: '${widget.city.name} City added to favorites');
  }

  void _exploreCity() {
    Get.to( InformationScreen());
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
  
  // Fallback to browser if apps aren't installed
  ALoaders.warningSnackBar(
    title: 'Maps App Not Found', 
    message: 'Opening in browser instead'
    );
  return await launchUrl(
    Uri.parse('https://maps.google.com?q=$lat,$lng'),
    mode: LaunchMode.externalApplication,
  );
}






void _showMapChooser() {
  final lat = widget.city.latitude;
  final lng = widget.city.longitude;
  
  if (lat == null || lng == null) {
    Get.snackbar(
      'Error', 
      'Location data not available',
      snackPosition: SnackPosition.BOTTOM,
    );
    return;
  }

  final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

  Get.bottomSheet(
    Container(
      decoration: BoxDecoration(
        color: Get.isDarkMode ? AColors.dark : Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Title
          Text(
            'Open in Maps',
            style: Get.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Map options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Always show Google Maps
              _buildMapOption(
                icon: Iconsax.map,
                color: Colors.red,
                label: 'Google Map',
                onTap: () => _openGoogleMaps(lat, lng),
              ),
              
              // Only show Apple Maps on iOS
              if (isIOS)
                _buildMapOption(
                  icon: Iconsax.map,
                  color: Colors.blue,
                  label: 'Apple Map',
                  onTap: () => _openAppleMaps(lat, lng),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}

Widget _buildMapOption({
  required IconData icon,
  required Color color,
  required String label,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: () {
      Get.back();
      onTap();
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Get.textTheme.labelLarge,
        ),
      ],
    ),
  );
}

}

extension on BaseDeviceInfo {
   get isIOS => null;
}



// City Section
Widget  _buildPopularPlacesSection() {
  final cityController = Get.find<CityController>();
  
  return Obx(() {
    
    final displayedCities = cityController.cities.take(4).toList();
    
    if (displayedCities.isEmpty) {
      return const SizedBox(height: 0); 
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Another Popular Places', style: Get.textTheme.headlineSmall),
            const Spacer(),
            TextButton(
              onPressed: () => Get.toNamed('/cities'),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: ASizes.spaceBtwItems),
        SizedBox(
          height: 200, // Fixed height for the horizontal list
          child: ListView.separated( // Using separated for better control
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: displayedCities.length,
            itemBuilder: (_, index) {
              final city = displayedCities[index];
              return SizedBox( // Constrained width
                width: 180,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque, // Better touch handling
                  onTap: () => Get.to(
                    () => CityDetailScreen(city: city),
                    transition: Transition.cupertino,
                  ),
                  child: CityCard(
                    city: city,
                    key: ValueKey(city.id), 
                    onTap: () => Get.to(
                  () => CityDetailScreen(city: cityController.cities[index]),
                  transition: Transition.cupertino,
                ), 
                ),)
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: ASizes.spaceBtwItems),
          ),
        ),
      ],
    );
  });
}


