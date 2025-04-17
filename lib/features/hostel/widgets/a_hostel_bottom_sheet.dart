import 'package:airsolo/features/models/hostel/facilities.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

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
              const TabBar(
                tabs: [
                  Tab(text: "Description"),
                  Tab(text: "Facilities"),
                  Tab(text: "House Rules"),
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
                    Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'All Facilities',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: GridView.builder(
                                    shrinkWrap: true, // Prevents unnecessary scrolling inside TabView
                                    // physics: const NeverScrollableScrollPhysics(), // Prevents inner scroll
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, // 2 columns
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 3, // Adjust ratio to make it look nice
                                    ),
                                    itemCount: facilities.length,
                                    itemBuilder: (context, index) {
                                      return Row(
                                        children: [
                                          Icon(
                                                facilities[index]['icon'],
                                                size: 24,
                                                color: AColors.black
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                facilities[index]['name'],
                                                style: const TextStyle(fontSize: 16),
                                              ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                    
                    // House Rules Tab
                   const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "House Rules",
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),

                                  // Rule 1
                                  Row(
                                    children: [
                                      Icon(Icons.access_time, color: Colors.blue),
                                      SizedBox(width: 10),
                                      Expanded(child: Text("Check-in time: 2:00 PM - 11:00 PM")),
                                    ],
                                  ),
                                  SizedBox(height: 8),

                                  // Rule 2
                                  Row(
                                    children: [
                                      Icon(Icons.exit_to_app, color: Colors.blue),
                                      SizedBox(width: 10),
                                      Expanded(child: Text("Check-out time: Before 12:00 AM")),
                                    ],
                                  ),
                                  SizedBox(height: 8),

                                  // Rule 3
                                  Row(
                                    children: [
                                      Icon(Icons.smoke_free, color: Colors.red),
                                      SizedBox(width: 10),
                                      Expanded(child: Text("No smoking inside the property")),
                                    ],
                                  ),
                                  SizedBox(height: 8),

                                  // Rule 4
                                  Row(
                                    children: [
                                      Icon(Icons.pets, color: Colors.orange),
                                      SizedBox(width: 10),
                                      Expanded(child: Text("Pets are not allowed")),
                                    ],
                                  ),
                                  SizedBox(height: 8),

                                  // Rule 5
                                  Row(
                                    children: [
                                      Icon(Icons.music_note, color: Colors.purple),
                                      SizedBox(width: 10),
                                      Expanded(child: Text("No loud music or parties after 10:00 PM")),
                                    ],
                                  ),
                                  SizedBox(height: 8),

                                  // Rule 6
                                  Row(
                                    children: [
                                      Icon(Icons.cleaning_services, color: Colors.green),
                                      SizedBox(width: 10),
                                      Expanded(child: Text("Keep the property clean and tidy")),
                                    ],
                                  ),
                                  SizedBox(height: 8),

                                  // Rule 7
                                  Row(
                                    children: [
                                      Icon(Icons.key, color: Colors.brown),
                                      SizedBox(width: 10),
                                      Expanded(child: Text("Lost keys will result in a replacement fee")),
                                    ],
                                  ),
                                  SizedBox(height: 8),

                                  // Rule 8
                                  Row(
                                    children: [
                                      Icon(Icons.group, color: Colors.indigo),
                                      SizedBox(width: 10),
                                      Expanded(child: Text("Only registered guests are allowed to stay overnight")),
                                    ],
                                  ),
                                  SizedBox(height: 8),

                                  // Rule 9
                                  Row(
                                    children: [
                                      Icon(Icons.kitchen, color: Colors.teal),
                                      SizedBox(width: 10),
                                      Expanded(child: Text("Use kitchen responsibly and clean up after use")),
                                    ],
                                  ),
                                  SizedBox(height: 8),

                                  // Rule 10
                                  Row(
                                    children: [
                                      Icon(Icons.credit_card, color: Colors.black),
                                      SizedBox(width: 10),
                                      Expanded(child: Text("Damages must be reported and paid for")),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                ],
                              )

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

