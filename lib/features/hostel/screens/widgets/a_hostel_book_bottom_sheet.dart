import 'package:airsolo/features/hostel/screens/widgets/hostel_room_details.dart';
import 'package:airsolo/utils/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class BookHostelStayBottomSheet extends StatefulWidget {
  const BookHostelStayBottomSheet({super.key});

  @override
  _BookHostelStayBottomSheetState createState() => _BookHostelStayBottomSheetState();

  static Future<void> show(BuildContext context, int initialIndex) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true, // Allows better content fitting
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return const BookHostelStayBottomSheet();
      },
    );
  }
}

class _BookHostelStayBottomSheetState extends State<BookHostelStayBottomSheet> {
  final TextEditingController _placeController = TextEditingController();
  DateTimeRange? _selectedDateRange;
  int _selectedGuests = 1;

  void _goToNextTab(int tabIndex) {
    DefaultTabController.of(context).animateTo(tabIndex);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // TabBar
            const TabBar(
              tabs: [
                Tab(text: "Location"),
                Tab(text: "Dates"),
                Tab(text: "Guests"),
              ],
            ),
            const SizedBox(height: 16),
            // TabBarView
            SizedBox(
              height: 500, // Set a fixed height
              child: TabBarView(
                children: [
                  // Location Tab
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextField(
                          controller: _placeController,
                          decoration: const InputDecoration(
                            labelText: "Enter destination",
                          ),
                          onSubmitted: (value) => _goToNextTab(1),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => _goToNextTab(1),
                          child: const Text("Next"),
                        ),
                      ],
                    ),
                  ),

                  // Dates Tab
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            DateTimeRange? picked = await showDateRangePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() {
                                _selectedDateRange = picked;
                              });
                            }
                          },
                          child: Text(_selectedDateRange == null
                              ? "Select Dates"
                              : "Selected: ${_selectedDateRange!.start.toLocal()} - ${_selectedDateRange!.end.toLocal()}"),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => _goToNextTab(2),
                          child: const Text("Next"),
                        ),
                      ],
                    ),
                  ),

                  // Guests Tab
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Number of Guests:"),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    if (_selectedGuests > 1) {
                                      setState(() {
                                        _selectedGuests--;
                                      });
                                    }
                                  },
                                ),
                                Text("$_selectedGuests"),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      _selectedGuests++;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                        onPressed: () {
                          // Navigate to Room Details Page with selected details
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RoomDetailsPage(
                                location: _placeController.text,
                                dateRange: _selectedDateRange,
                                guests: _selectedGuests,
                              ),
                            ),
                          );
                        },
                        child: const Text("Confirm Booking"),
                      ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Close Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text(ATexts.close),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
