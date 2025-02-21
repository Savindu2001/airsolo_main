
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';

class TripResultsScreen extends StatelessWidget {
  //final List<Map<String, String>> tripPlans;

  //TripResultsScreen({required this.tripPlans});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Trip Plans")),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: 2,
        itemBuilder: (context, index) {
          //final plan = tripPlans[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Container(
              height: 160,
              child: ListTile(
                leading: Image(image: AssetImage(AImages.hostelImage2)),
                title: Text('data'),//Text(plan['title'] ?? "Trip Plan ${index + 1}"),
                subtitle: Text('data'),//Text(plan['description'] ?? "Detailed trip plan information"),
                trailing: ElevatedButton(
                  onPressed: () {}, // Implement navigation to detailed trip view
                  child: Text("View"),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
