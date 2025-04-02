import 'package:flutter/material.dart';

class RoomDetailsPage extends StatelessWidget {
  final String location;
  final DateTimeRange? dateRange;
  final int guests;

  const RoomDetailsPage({super.key, 
    required this.location,
    required this.dateRange,
    required this.guests,
  });

  @override
  Widget build(BuildContext context) {
    // Sample room data
    final List<Map<String, dynamic>> availableRooms = [
      {
        'roomType': 'Domitory Room',
        'price': 100,
        'description': 'A spacious room with a king-sized bed and stunning views.',
        'availability': 2,
      },
      {
        'roomType': 'Standard Room',
        'price': 80,
        'description': 'A comfortable room with essential amenities.',
        'availability': 5,
      },
      {
        'roomType': 'Shared Dormitory',
        'price': 30,
        'description': 'A budget-friendly option with multiple beds.',
        'availability': 10,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Available Rooms in $location"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Selected Dates: ${dateRange?.start.toLocal()} - ${dateRange?.end.toLocal()}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              "Number of Guests: $guests",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: availableRooms.length,
                itemBuilder: (context, index) {
                  final room = availableRooms[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            room['roomType'],
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(room['description']),
                          const SizedBox(height: 8),
                          Text("Price: \$${room['price']} per night"),
                          const SizedBox(height: 8),
                          Text("Available: ${room['availability']} rooms"),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              // Handle booking logic here
                              print("Booked ${room['roomType']} for $guests guests.");
                              // You can navigate to a confirmation page or show a dialog
                            },
                            child: const Text("Book Now"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
