import 'package:airsolo/features/city/controller/city_controller.dart';
import 'package:airsolo/features/city/model/city_model.dart';
import 'package:airsolo/features/city/screen/city_detail_screen.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CityScreen extends StatelessWidget {
  final CityController cityController = Get.find<CityController>();

  CityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = AHelperFunctions.isDarkMode(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Cities'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => cityController.fetchCities(),
            tooltip: 'Refresh cities',
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AColors.primary,
        backgroundColor: dark ? AColors.dark : AColors.light,
        onRefresh: cityController.fetchCities,
        child: Padding(
          padding: const EdgeInsets.all(ASizes.defaultSpace),
          child: Obx(() {
            if (cityController.isLoading.value && cityController.cities.isEmpty) {
              return _buildLoadingGrid();
            }

            if (cityController.error.isNotEmpty) {
              return ErrorWidget(
                error: cityController.error.value,
                onRetry: () => cityController.fetchCities(),
              );
            }

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: ASizes.gridViewSpacing,
                mainAxisSpacing: ASizes.gridViewSpacing,
                childAspectRatio: 0.8,
              ),
              itemCount: cityController.cities.length,
              itemBuilder: (context, index) {
                final city = cityController.cities[index];
                return Hero(
                  tag: 'city-${city.id}',
                  child: CityCard(
                    city: city,
                    onTap: () => Get.to(
                      () => CityDetailScreen(city: city),
                      transition: Transition.cupertino,
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: ASizes.gridViewSpacing,
        mainAxisSpacing: ASizes.gridViewSpacing,
        childAspectRatio: 0.8,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => const CityCardSkeleton(),
    );
  }
}

class CityCard extends StatelessWidget {
  final City city;
  final VoidCallback onTap;

  const CityCard({
    super.key,
    required this.city,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = AHelperFunctions.isDarkMode(context);
    final imageUrl = city.images.isNotEmpty ? city.images.first : null;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ASizes.cardRadiusLg),
          boxShadow: [
            BoxShadow(
              color: dark ? Colors.black54 : Colors.grey,
              blurRadius: 8,
              offset:  const Offset(0, 4),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ASizes.cardRadiusLg),
          child: Stack(
            children: [
              // Image with proper handling
              AspectRatio(
                aspectRatio: 1/1,
                child: _buildImageContent(imageUrl, context),
              ),
              
              // Gradient overlay
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black,
                    ],
                  ),
                ),
              ),
              
              // City name
              Positioned(
                bottom: ASizes.defaultSpace,
                left: ASizes.defaultSpace,
                right: ASizes.defaultSpace,
                child: Text(
                  city.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      const Shadow(
                        color: Colors.black,
                        blurRadius: 6,
                        offset:  Offset(0, 1),
                  )],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageContent(String? imageUrl, BuildContext context) {
    if (!_isValidImageUrl(imageUrl)) {
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
           !url.contains('airsolo-assets.s3.ap-southeast-1.amazonaws.com/city/') &&
           ['jpg', 'jpeg', 'png', 'webp'].contains(url.split('.').last.toLowerCase());
  }

  Widget _buildDefaultImage() {
    return Image.asset(
      AImages.defaultCityImage,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}

class CityCardSkeleton extends StatelessWidget {
  const CityCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ASizes.cardRadiusLg),
        color: Colors.grey[200],
      ),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const ErrorWidget({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AImages.disconnect,
            width: AHelperFunctions.screenWidth() * 0.6,
          ),
          const SizedBox(height: ASizes.spaceBtwSections),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: ASizes.spaceBtwItems),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ),
        ],
      ),
    );
  }
}