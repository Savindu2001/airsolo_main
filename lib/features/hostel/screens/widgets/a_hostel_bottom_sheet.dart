import 'package:airsolo/features/hostel/controllers/facilities_controller.dart';
import 'package:airsolo/features/hostel/controllers/house_rules_controllers.dart';
import 'package:airsolo/features/models/hostel/facilities.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';

Future<void> showCustomBottomSheet(BuildContext context, int initialIndex) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true, // Allows better content fitting
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    
    builder: (BuildContext context) {
      return DefaultTabController(
        length: 3,
        initialIndex: initialIndex, // Set the initial tab based on button click
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TabBar
              TabBar(
                tabs: [
                  Tab(text: "Description"),
                  Tab(text: "Facilities"),
                  Tab(text: 'House Rules',),
                  
                ],
              ),
              const SizedBox(height: 16),
              // TabBarView
              SizedBox(
                height: 500, // Set a fixed height
                child: TabBarView(
                  children: [
                    // Description Tab
                    SingleChildScrollView(
                      child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Property Overview
                                      const Text(
                                        "Welcome to Your Perfect Stay",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Experience comfort and luxury in a beautifully designed space, "
                                        "perfectly suited for relaxation and adventure. Whether you're here "
                                        "for business, leisure, or a romantic getaway, we ensure an unforgettable stay.",
                                        style: TextStyle(fontSize: 14, color: Colors.grey[700],),textAlign: TextAlign.justify,
                                      ),
                                      const SizedBox(height: 16),
                      
                                      // Accommodation Details
                                      const Text(
                                        "Spacious & Elegant Rooms",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Our rooms are thoughtfully designed with modern décor, "
                                        "cozy furnishings, and top-notch amenities. Each room is air-conditioned, "
                                        "features plush bedding, and offers breathtaking views of the city or nature.",
                                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),textAlign: TextAlign.justify,
                                      ),
                                      const SizedBox(height: 16),
                      
                                      // Dining Experience
                                      const Text(
                                        "Delicious Dining Options",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Indulge in a variety of culinary delights at our on-site restaurant, "
                                        "serving both local and international cuisine. Enjoy a hearty breakfast, "
                                        "freshly brewed coffee, and a selection of gourmet dishes throughout the day.",
                                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),textAlign: TextAlign.justify,
                                      ),
                                      const SizedBox(height: 16),
                      
                                      // Activities & Experiences
                                      const Text(
                                        "Exciting Activities & Relaxation",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Unwind by the swimming pool, rejuvenate at our luxurious spa, or explore "
                                        "local attractions just minutes away. Adventure seekers can enjoy hiking, "
                                        "cycling, or guided tours arranged by our concierge.",
                                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),textAlign: TextAlign.justify,
                                      ),
                                      const SizedBox(height: 16),
                      
                                      // Guest Services
                                      const Text(
                                        "Exceptional Guest Services",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "We prioritize your comfort with 24/7 reception, daily housekeeping, "
                                        "complimentary high-speed Wi-Fi, and personalized services to make your stay seamless.",
                                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),textAlign: TextAlign.justify,
                                      ),
                                      const SizedBox(height: 16),
                      
                                      // Final Call to Action
                                      const Text(
                                        "Book Your Stay Today!",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "We look forward to welcoming you to an unforgettable experience. "
                                        "Book now to enjoy exclusive deals and special discounts!",
                                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),textAlign: TextAlign.justify,
                                      ),
                                    ],
                                  ),
                    ),

                    
                    // Facilities Tab
                    Obx(() {
                    final controller = FacilitiesController.instance;
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    if (controller.error.value.isNotEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(controller.error.value),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => controller.fetchAllFacilities(isRetry: true),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    if (controller.facilities.isEmpty) {
                      return const Center(child: Text('No Facilities available'));
                    }
                    
                    return ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: controller.facilities.length,
                      separatorBuilder: (_, __) => const Divider(height: 16),
                      itemBuilder: (_, index) {
                        final facility = controller.facilities[index];
                        return ListTile(
                          leading: Icon(facility.icon),
                          title: Text(facility.name),
                          
                        );
                      },
                    );
                  }),


                    // House Rules Tab
                   Obx(() {
                    final controller = HouseRulesController.instance;
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    if (controller.error.value.isNotEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(controller.error.value),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => controller.fetchRules(isRetry: true),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    if (controller.rules.isEmpty) {
                      return const Center(child: Text('No house rules available'));
                    }
                    
                    return ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: controller.rules.length,
                      separatorBuilder: (_, __) => const Divider(height: 16),
                      itemBuilder: (_, index) {
                        final rule = controller.rules[index];
                        return ListTile(
                          leading: Icon(
                            _getRuleIcon(index),
                            color: _getRuleIconColor(index),
                          ),
                          title: Text(rule.rule),
                          subtitle: rule.createdAt != rule.updatedAt
                              ? Text('Updated ${_formatDate(rule.updatedAt)}')
                              : Text('Created ${_formatDate(rule.createdAt)}'),
                        );
                      },
                    );
                  }),


                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Close Button
              SizedBox( width:double.infinity, child: ElevatedButton(onPressed: () => Get.back(), child: const Text(ATexts.close),)),
             
            ],
          ),
        ),
      );
    },
  );
}


IconData _getRuleIcon(int index) {
  final icons = [
    Icons.access_time,
    Icons.exit_to_app,
    Icons.smoke_free,
    Icons.pets,
    Icons.music_note,
    Icons.cleaning_services,
    Icons.key,
    Icons.group,
    Icons.kitchen,
    Icons.credit_card,
  ];
  return icons[index % icons.length];
}

Color _getRuleIconColor(int index) {
  final colors = [
    Colors.blue,
    Colors.red,
    Colors.orange,
    Colors.purple,
    Colors.green,
    Colors.brown,
    Colors.indigo,
    Colors.teal,
    Colors.black,
    Colors.pink,
  ];
  return colors[index % colors.length];
}

String _formatDate(DateTime date) {
  return DateFormat('MMM d, y').format(date);
}
