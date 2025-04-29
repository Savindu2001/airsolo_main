import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:airsolo/features/activity/activity_controller.dart';
import 'package:airsolo/features/activity/activity_model.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ActivityEventController());
    final dark = AHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Activities', style: Theme.of(context).textTheme.headlineMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterBottomSheet(context, controller),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.error.value),
                const SizedBox(height: ASizes.defaultSpace),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.fetchActivities,
                      child: const Text('Retry'),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        final activities = controller.filteredActivities.isEmpty
            ? controller.activities
            : controller.filteredActivities;

        if (activities.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_available, size: 50, color: dark ? AColors.light : AColors.dark),
                const SizedBox(height: ASizes.spaceBtwItems),
                Text('No activities found', style: Theme.of(context).textTheme.titleMedium),
                if (controller.selectedCityId.value.isNotEmpty || controller.selectedActivityType.value.isNotEmpty)
                  TextButton(
                    onPressed: controller.resetFilters,
                    child: const Text('Reset filters'),
                  ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchActivities,
          child: ListView.builder(
            padding: const EdgeInsets.all(ASizes.defaultSpace),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return _ActivityCard(activity: activity,controller: controller,);
            },
          ),
        );
      }),
    );
  }

  void _showFilterBottomSheet(BuildContext context, ActivityEventController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(ASizes.defaultSpace),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Text('City', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: ASizes.spaceBtwItems),
            Obx(() => DropdownButtonFormField<String>(
              value: controller.selectedCityId.value.isEmpty ? null : controller.selectedCityId.value,
              decoration: const InputDecoration(
                hintText: 'Select City',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem(
                  value: '',
                  child: Text('All Cities'),
                ),
                ...controller.cities.map((city) {
                  return DropdownMenuItem(
                    value: city.id,
                    child: Text(city.name),
                  );
                }),
              ],
              onChanged: (value) {
                controller.applyFilters(cityId: value ?? '');
              },
            )),
            
            const SizedBox(height: ASizes.spaceBtwSections),
            
            Text('Activity Type', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: ASizes.spaceBtwItems),
            Obx(() => DropdownButtonFormField<String>(
              value: controller.selectedActivityType.value.isEmpty ? null : controller.selectedActivityType.value,
              decoration: const InputDecoration(
                hintText: 'Select Activity Type',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem(
                  value: '',
                  child: Text('All Types'),
                ),
                ...controller.activityTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }),
              ],
              onChanged: (value) {
                controller.applyFilters(type: value ?? '');
              },
            )),
            
            const SizedBox(height: ASizes.spaceBtwSections),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: controller.resetFilters,
                    child: const Text('Reset Filters'),
                  ),
                ),
                const SizedBox(width: ASizes.spaceBtwItems),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: ASizes.spaceBtwSections),
          ],
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final ActivityEvent activity;
  final ActivityEventController controller;

  const _ActivityCard({required this.activity, required this.controller});

  @override
  Widget build(BuildContext context) {
    final dark = AHelperFunctions.isDarkMode(context);
    // Find the city that matches this activity's cityId
    final city = controller.cities.firstWhereOrNull(
      (city) => city.id == activity.cityId,
    );
    final cityName = city?.name ?? 'Unknown City';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: ASizes.spaceBtwItems),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ASizes.cardRadiusLg),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(ASizes.cardRadiusLg),
        onTap: () {
          // Handle activity tap
        },
        child: Padding(
          padding: const EdgeInsets.all(ASizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      activity.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: ASizes.sm,
                      vertical: ASizes.xs,
                    ),
                    decoration: BoxDecoration(
                      color: dark ? AColors.dark.withOpacity(0.6) : AColors.light.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(ASizes.cardRadiusSm),
                    ),
                    child: Text(
                      activity.activityType,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: ASizes.spaceBtwItems / 2),
              
              // Add city name here
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: dark ? AColors.light : AColors.dark),
                  const SizedBox(width: ASizes.spaceBtwItems / 2),
                  Text(cityName, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              const SizedBox(height: ASizes.spaceBtwItems / 2),
              
              if (activity.description != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: ASizes.spaceBtwItems / 2),
                  child: Text(
                    activity.description!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              
              const Divider(height: ASizes.spaceBtwItems),
              
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: dark ? AColors.light : AColors.dark),
                  const SizedBox(width: ASizes.spaceBtwItems / 2),
                  Text(activity.formattedDate, style: Theme.of(context).textTheme.bodySmall),
                  
                  const Spacer(),
                  
                  if (activity.contact != null)
                    Row(
                      children: [
                        Icon(Icons.phone, size: 16, color: dark ? AColors.light : AColors.dark),
                        const SizedBox(width: ASizes.spaceBtwItems / 2),
                        Text(activity.contact!, style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}