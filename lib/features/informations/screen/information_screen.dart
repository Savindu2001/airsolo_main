import 'package:airsolo/features/informations/controller/information_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:iconsax/iconsax.dart';

class InformationScreen extends StatelessWidget {
  final InformationController controller = Get.put(InformationController());
  final RxString tempCityId = ''.obs;
  final RxString tempInfoType = ''.obs;

  InformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = AHelperFunctions.isDarkMode(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('City Information'),
        actions: [
          // Filter badge showing active filters
          Obx(() => Badge(
            isLabelVisible: controller.selectedCityId.isNotEmpty || 
                          controller.selectedInfoType.isNotEmpty,
            child: IconButton(
              icon: const Icon(Icons.filter_alt),
              onPressed: _showFilterDialog,
            ),
          )),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshInformations,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshInformations,
        child: _buildBody(dark)),
    );
  }

 Widget _buildBody(bool dark) {
    return Obx(() {
      // Loading state when first loading and no data yet
      if (controller.isLoading.value && controller.informations.isEmpty) {
        return _buildLoadingIndicator();
      }

      // Error state
      if (controller.error.value.isNotEmpty) {
        return _buildErrorWidget(controller);
      }

      // Empty state (no filters applied)
      if (controller.informations.isEmpty && 
          controller.selectedCityId.value.isEmpty &&
          controller.selectedInfoType.value.isEmpty) {
        return _buildEmptyState(controller);
      }

      // Empty filtered state
      if (controller.informations.isEmpty) {
        return _buildEmptyFilteredState(controller);
      }

      // Normal state with data
      return _buildInformationList(dark);
    });
  }


  Widget _buildInformationList(bool dark) {
    return RefreshIndicator(
      onRefresh: () => controller.refreshInformations(),
      child: ListView.builder(
        padding: const EdgeInsets.all(ASizes.defaultSpace),
        itemCount: controller.informations.length,
        itemBuilder: (context, index) {
          final info = controller.informations[index];
          final city = controller.cities.firstWhereOrNull(
            (city) => city.id == info.cityId);
          
          return Card(
            margin: const EdgeInsets.only(bottom: ASizes.spaceBtwItems),
            color: AColors.homePrimary,
            child: Padding(
              padding: const EdgeInsets.all(ASizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          info.name,
                          
                          style: Get.textTheme.headlineSmall?.copyWith(color: Colors.white),
                          
                        ),
                      ),
                      _buildInfoTypeChip(info.infoType, dark),
                    ],
                  ),
                  if (city != null) 
                    Padding(
                      padding: const EdgeInsets.only(top: ASizes.xs),
                      child: Text(
                        city.name,
                        style: Get.textTheme.bodySmall?.copyWith(
                          color: dark ? AColors.lightGrey : AColors.white,
                        ),
                      ),
                    ),
                  const SizedBox(height: ASizes.sm),
                  if (info.description != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: ASizes.sm),
                      child: Text(info.description!, style: Get.textTheme.bodyMedium?.copyWith(color: AColors.white),),
                    ),
                  _buildInfoRow(Icons.phone, info.contact1, dark),
                  if (info.contact2 != null) 
                    _buildInfoRow(Icons.phone, info.contact2!, dark),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoTypeChip(String infoType, bool dark) {
    return Chip(
      label: Text(infoType),
      backgroundColor: _getColorForInfoType(infoType, dark),
      labelStyle: Get.textTheme.labelSmall?.copyWith(
        color: dark ? Colors.white : Colors.white,
      ),
      side: BorderSide.none,
    );
  }

  Color _getColorForInfoType(String infoType, bool dark) {
 
   final colors = {
  'Police': Colors.blue,
  'Hospital': Colors.red,
  'Ambulance': Colors.redAccent,
  'Bus Station': Colors.green,
  'Train Station': Colors.deepPurple,
  'Visa Information': Colors.amber,
  'Tourist Board': Colors.lightBlue,
  'Travel Agency': Colors.teal,
  'Emergency Services': Colors.orange,
  'Currency Exchange': Colors.purple,
  'Local Attractions': Colors.pink,
  'Restaurants': Colors.deepOrange,
  'Hotels': Colors.indigo,
  'Public Restrooms': Colors.brown,
  'Parking Facilities': Colors.grey,
  'Tour Guides': Colors.lightGreen,
  'Shopping Areas': Colors.cyan,
  'Cultural Sites': Colors.lime,
  'Adventure Activities': Colors.yellow,
  'Transportation Services': Colors.blueGrey,
};


    return colors[infoType]?? 
           (dark ? Colors.transparent : Colors.transparent);
  }

  void _showFilterDialog() {
    // Initialize temp values
    tempCityId.value = controller.selectedCityId.value;
    tempInfoType.value = controller.selectedInfoType.value;

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
        child: Obx(() => Column(
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
              'Filter Information',
              style: Get.textTheme.titleLarge,
            ),
            const SizedBox(height: ASizes.spaceBtwSections),
            
            // City Dropdown
            DropdownButtonFormField<String>(
              value: tempCityId.value.isEmpty ? null : tempCityId.value,
              decoration: InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ASizes.cardRadiusMd),
                ),
              ),
              items: [
                const DropdownMenuItem(
                  value: '',
                  child: Text('All Cities'),
                ),
                ...controller.cities.map((city) => DropdownMenuItem(
                  value: city.id,
                  child: Text(city.name),
                )).toList(),
              ],
              onChanged: (value) => tempCityId.value = value ?? '',
            ),
            const SizedBox(height: ASizes.spaceBtwItems),
            
            // Info Type Dropdown
            DropdownButtonFormField<String>(
              value: tempInfoType.value.isEmpty ? null : tempInfoType.value,
              decoration: InputDecoration(
                labelText: 'Information Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ASizes.cardRadiusMd),
                ),
              ),
              items: [
                const DropdownMenuItem(
                  value: '',
                  child: Text('All Types'),
                ),
                ...controller.infoTypes.map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                )).toList(),
              ],
              onChanged: (value) => tempInfoType.value = value ?? '',
            ),
            const SizedBox(height: ASizes.spaceBtwSections),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      controller.resetFilters();
                      Get.back();
                    },
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: ASizes.spaceBtwItems),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.applyFilters(
                        tempCityId.value,
                        tempInfoType.value,
                      );
                      Get.back();
                    },
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }

}

Widget _buildLoadingIndicator() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: ASizes.spaceBtwItems),
        Text(
          'Loading city information...',
          style: Get.textTheme.bodyMedium,
        ),
      ],
    ),
  );
}

Widget _buildErrorWidget(dynamic controller) {
  return Padding(
    padding: const EdgeInsets.all(ASizes.defaultSpace),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Get.theme.colorScheme.error,
          ),
          const SizedBox(height: ASizes.spaceBtwSections),
          Text(
            'Failed to load information',
            style: Get.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: ASizes.spaceBtwItems),
          Text(
            controller.error.value,
            style: Get.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: ASizes.spaceBtwSections),
          ElevatedButton(
            onPressed: controller.refreshInformations,
            child: const Text('Try Again'),
          ),
        ],
      ),
    ),
  );
}

Widget _buildEmptyState(dynamic controller) {
  return Padding(
    padding: const EdgeInsets.all(ASizes.defaultSpace),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 48,
            color: Get.theme.colorScheme.primary,
          ),
          const SizedBox(height: ASizes.spaceBtwSections),
          Text(
            'No information available',
            style: Get.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: ASizes.spaceBtwItems),
          if (controller.selectedCityId.isNotEmpty || 
              controller.selectedInfoType.isNotEmpty)
            Text(
              'Try changing your filters',
              style: Get.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: ASizes.spaceBtwSections),
          ElevatedButton(
            onPressed: controller.resetFilters,
            child: const Text('Reset Filters'),
          ),
        ],
      ),
    ),
  );
}


Widget _buildEmptyFilteredState(dynamic controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Iconsax.search_zoom_out_15, size: 48),
          const SizedBox(height: ASizes.spaceBtwSections),
          Text(
            'No Informations found',
            style: Get.textTheme.titleMedium,
          ),
          const SizedBox(height: ASizes.spaceBtwItems),
          Text(
            'Try adjusting your filters',
            style: Get.textTheme.bodyMedium,
          ),
          const SizedBox(height: ASizes.spaceBtwSections),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.resetFilters,
                child: const Text('Reset Filters'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, bool dark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: ASizes.xs),
      child: Row(
        children: [
          Icon(icon, size: 16, color: dark ? AColors.light : AColors.white),
          const SizedBox(width: ASizes.sm),
          Expanded(
            child: Text(
              text,
              style: Get.textTheme.bodyMedium?.copyWith(color: AColors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
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
              'Filter Information',
              style: Get.textTheme.titleLarge,
            ),
            const SizedBox(height: ASizes.spaceBtwSections),
            // TODO: Add filter dropdowns here
            // DropdownButtonFormField(...) for city filter
            // DropdownButtonFormField(...) for info type filter
            const SizedBox(height: ASizes.spaceBtwSections),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      
                      Get.back();
                    },
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: ASizes.spaceBtwItems),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Apply filters
                      Get.back();
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

