import 'package:airsolo/data/repositories/authentication/authentication_repository.dart';
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
  final CityController cityController = Get.put(CityController());

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
        onRefresh: cityController.fetchCities,
        child: Padding(
          padding: const EdgeInsets.all(ASizes.defaultSpace),
          child: Obx(() {
            if (cityController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
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
              itemBuilder: (context, index) => CityCard(
                city: cityController.cities[index],
                onTap: () => Get.to(
                  () => CityDetailScreen(city: cityController.cities[index]),
                  transition: Transition.cupertino,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}


// City Card
class CityCard extends StatelessWidget {
  final City city;
  final VoidCallback onTap;
  final double? width;
  final double? height;

  const CityCard({
    super.key,
    required this.city,
    required this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final dark = AHelperFunctions.isDarkMode(context);
    final imageUrl = city.imageUrl ?? city.images?.firstOrNull;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ASizes.cardRadiusLg),
          boxShadow: [
            BoxShadow(
              color: dark ? Colors.black54 : Colors.grey.withOpacity(0.5),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ASizes.cardRadiusLg),
          child: Stack(
            children: [
              // City Image with improved loading and error handling
              _buildCityImage(imageUrl, context),
              
              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              
              // City Name
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
                      Shadow(
                        color: Colors.black.withOpacity(0.8),
                        blurRadius: 6,
                        offset: const Offset(0, 1),
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

  Widget _buildCityImage(String? imageUrl, BuildContext context) {
    if (imageUrl == null) {
      return Image.asset(
        AImages.defaultCityImage,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    }

    if (imageUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey[200],
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => _buildDefaultImage(),
      );
    } else {
      return Image.asset(
        imageUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildDefaultImage(),
      );
    }
  }

  Widget _buildDefaultImage() {
    return Image.asset(
      AImages.defaultCityImage,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    );
  }
}




// Error Widget
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
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
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