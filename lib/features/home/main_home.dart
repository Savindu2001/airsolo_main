import 'package:airsolo/common/widgets/custome_shapes/containers/primary_hader_container.dart';
import 'package:airsolo/common/widgets/layout/grid_layout.dart';
import 'package:airsolo/common/widgets/search_bar/default_searchbar.dart';
import 'package:airsolo/common/widgets/texts/section_heading.dart';
import 'package:airsolo/features/city/controller/city_controller.dart';
import 'package:airsolo/features/city/screen/city_detail_screen.dart';
import 'package:airsolo/features/city/screen/city_screen.dart';
import 'package:airsolo/features/home/widgets/banner_slider.dart';
import 'package:airsolo/features/home/widgets/home_app_bar.dart';
import 'package:airsolo/features/home/widgets/home_category.dart';
import 'package:airsolo/features/hostel/controllers/hostel_controller.dart';
import 'package:airsolo/features/hostel/models/room_model.dart';
import 'package:airsolo/features/hostel/screens/hostel_detail_screen.dart';
import 'package:airsolo/features/hostel/screens/hostel_list_screen.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return   Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            // Custom Circle Design
            APrimaryHeaderContainer(
                  child:   Container(
                      child:  Column(

                        children: [
                          //App Bar
                           const AHomeAppBar(),
                           const SizedBox(height: ASizes.spaceBtwSections,),
                          //SearchBar
                          const ASearchBarContainer( text: 'Where you go next?', showBackground: true, showBorder: true, icon: Iconsax.search_normal,),
                          const SizedBox(height: ASizes.spaceBtwItems+ 5,),

                          // Category Title & Icons

                          ASectionHeading(showActionButton: false, title: 'Find What You Need',  onPressed: (){}, textColor: AColors.white,),
                          const SizedBox(height: ASizes.spaceBtwItems,),


                          // Category Icons

                          const AHomeCategories(),
                          const SizedBox(height: ASizes.spaceBtwSections,),
                          

                        ]
                    ),
                  )
                  ),

                  

                  ///Body Part
                  const Padding(
                    padding: EdgeInsets.only(left: ASizes.defaultSpace),
                    child: ASectionHeading(title: 'Explore Sri Lanka', showActionButton: false),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(ASizes.defaultSpace),
                    child: APromoSlider(autoPlay: true ,banners:  [ AImages.banner1, AImages.banner2, AImages.banner5 ]),
                  ),



                  //Popular City Card
                  _buildPopularCities(),
                  const SizedBox(height: ASizes.spaceBtwSections,),

                  //Popular Hostels Card
                  _buildHostelCard(),
                  const SizedBox(height: ASizes.spaceBtwItems/2,),

                  

                   

            
          ],
        ),
      ),
    );
  }
}



// City Section
Widget _buildPopularCities() {
  final cityController = Get.find<CityController>();
  
  return Obx(() {
    
    final displayedCities = cityController.cities.take(7).toList();
    
    if (displayedCities.isEmpty) {
      return const SizedBox(height: 0); 
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: ASizes.defaultSpace),
          child: Row(
            children: [
              Text('Popular Places', style: Get.textTheme.headlineSmall),
              const Spacer(),
              TextButton(
                onPressed: () => Get.toNamed('/cities'),
                child: const Text('View All'),
              ),
            ],
          ),
        ),
        const SizedBox(height: ASizes.spaceBtwItems),
        SizedBox(
          height: 220, // Fixed height for the horizontal list
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
                ), // Unique key for each card
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

// Hostel Section
Widget _buildHostelCard() {
  final hostelController = Get.find<HostelController>();

  return Obx(() {
    if (hostelController.isLoading.value && hostelController.hostels.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: ASizes.defaultSpace),
        child: AGridLayout(
          itemCount: 4,
          itemBuilder: (_, index) => const _HostelCardSkeleton(),
        ),
      );
    }

    if (hostelController.error.value.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 50, color: Colors.red),
            const SizedBox(height: ASizes.md),
            Text(
              hostelController.error.value,
              style: Get.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: ASizes.md),
            ElevatedButton(
              onPressed: () => hostelController.fetchHostels(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final displayedHostels = hostelController.hostels.take(12).toList();

    if (displayedHostels.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 50, color: Colors.grey),
            const SizedBox(height: ASizes.md),
            Text(
              'No hostels found',
              style: Get.textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Heading
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: ASizes.defaultSpace),
          child: Row(
            children: [
              Text('Best Hostels', style: Get.textTheme.headlineSmall),
              const Spacer(),
              TextButton(
                onPressed: () => Get.to(() => HostelListScreen()),
                child: const Text('View All'),
              ),
            ],
          ),
        ),
        const SizedBox(height: ASizes.spaceBtwItems),

        // Hostel Grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: ASizes.defaultSpace),
          child: AGridLayout(
            itemCount: displayedHostels.length,
            itemBuilder: (_, index) {
              final hostel = displayedHostels[index];
              final rooms = hostelController.getRoomsForHostel(hostel.id);
              final hasRooms = rooms.isNotEmpty;
              
              return Card(
                margin: const EdgeInsets.only(bottom: ASizes.defaultSpace),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ASizes.cardRadiusLg),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(ASizes.cardRadiusLg),
                  onTap: () {
                    hostelController.selectedHostel.value = null;
                    hostelController.isDetailLoading.value = true;
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
                          child: hostel.gallery.isNotEmpty 
                              ? CachedNetworkImage(
                                  imageUrl: hostel.gallery.first,
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
                                    AImages.hostelImage1,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Image.asset(
                                  AImages.hostelImage1,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      // Details Section
                      Padding(
                        padding: const EdgeInsets.all(ASizes.defaultSpace),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hostel.name,
                              style: Get.textTheme.titleLarge,
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
                                    style: Get.textTheme.bodyMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: ASizes.sm),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 16),
                                  const SizedBox(width: ASizes.xs),
                                  Text(
                                    hostel.rating?.toStringAsFixed(1) ?? 'N/A',
                                    style: Get.textTheme.bodyMedium,
                                  ),
                                  const Spacer(),
                                  Text(
                                    hasRooms 
                                        ? _getPriceRange(rooms)
                                        : 'View hostel',
                                    style: Get.textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  });
}

String _getPriceRange(List<Room> rooms) {
  if (rooms.isEmpty) return 'Loading prices...';
  
  final validPrices = rooms
      .where((room) => room.pricePerPerson > 0)
      .map((room) => room.pricePerPerson)
      .toList();

  if (validPrices.isEmpty) return 'View hostel';
  
  validPrices.sort();
  final min = validPrices.first;
  final max = validPrices.last;

  return min == max 
      ? '\$${min.toStringAsFixed(2)}' 
      : '\$${min.toStringAsFixed(2)} - \$${max.toStringAsFixed(2)}';
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
        baseColor: dark ? AColors.primary : AColors.homePrimary,
        highlightColor: dark ? AColors.primary : AColors.homePrimary,
        child: SingleChildScrollView(
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
                      width: double.infinity,
                      height: 16,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}