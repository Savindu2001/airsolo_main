import 'package:airsolo/features/hostel/models/hostel_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:airsolo/features/hostel/controllers/hostel_controller.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:shimmer/shimmer.dart';

class HostelListScreen extends StatelessWidget {
  final HostelController controller = HostelController.instance;

  @override
  Widget build(BuildContext context) {
    final dark = AHelperFunctions.isDarkMode(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hostels'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return _buildShimmerEffect();
                }
                if (controller.error.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(controller.error.value),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: controller.fetchHostels,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                if (controller.filteredHostels.isEmpty) {
                  return const Center(child: Text('No hostels found'));
                }
                return RefreshIndicator(
                  onRefresh: controller.refreshHostels,
                  child: _buildHostelList(),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search hostels...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onChanged: (value) => controller.searchQuery.value = value,
    );
  }

  Widget _buildHostelList() {
    return ListView.builder(
      itemCount: controller.filteredHostels.length,
      itemBuilder: (context, index) {
        final hostel = controller.filteredHostels[index];
        return Card(
          child: ListTile(
            leading: hostel.gallery?.isNotEmpty == true
                ? CachedNetworkImage(
                    imageUrl: hostel.gallery!.first,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.home),
            title: Text(hostel.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hostel.address ?? 'No address'),
                Text('${hostel.rating ?? 'N/A'} ⭐'),
                Text('From \$${_getMinPrice(hostel).toStringAsFixed(2)}'),
              ],
            ),
            onTap: () => Get.toNamed('/hostel-details', arguments: hostel.id),
          ),
        );
      },
    );
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 100,
            color: Colors.white,
          ),
        );
      },
    );
  }

  double _getMinPrice(Hostel hostel) {
    if (hostel.rooms.isEmpty) return 0;
    return hostel.rooms
        .map((room) => room.pricePerPerson)
        .reduce((a, b) => a < b ? a : b);
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Hostels'),
          content: const Text('Filter options will go here'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                controller.filterHostels();
                Navigator.pop(context);
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }
}