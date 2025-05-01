import 'dart:convert';

import 'package:airsolo/config.dart';
import 'package:airsolo/features/taxi/screens/join/available_shared_rides_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:airsolo/features/taxi/controllers/taxi_booking_controller.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/sizes.dart';

class JoinTaxiSearchScreen extends StatefulWidget {
  @override
  _JoinTaxiSearchScreenState createState() => _JoinTaxiSearchScreenState();
}

class _JoinTaxiSearchScreenState extends State<JoinTaxiSearchScreen> {
  final _pickupController = TextEditingController();
  final _dropController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  
  LatLng? _pickupLocation;
  LatLng? _dropLocation;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _seats = 1;

@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (mounted) {
      setState(() {
        _dateController.text = DateFormat('MMM dd, yyyy').format(DateTime.now());
        _timeController.text = TimeOfDay.now().format(context);
        _selectedDate = DateTime.now();
        _selectedTime = TimeOfDay.now();
      });
    }
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Shared Ride'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ASizes.defaultSpace),
        child: Column(
          children: [
            _buildLocationCard(),
            SizedBox(height: ASizes.spaceBtwItems),
            _buildDateTimeCard(),
            SizedBox(height: ASizes.spaceBtwItems),
            _buildSeatsSelector(),
            SizedBox(height: ASizes.spaceBtwSections),
            ElevatedButton(
              onPressed: _findSharedRides,
              child: Text('Find Shared Rides'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(ASizes.defaultSpace),
        child: Column(
          children: [
            _buildLocationField('Pickup Location', _pickupController, true),
            Divider(height: ASizes.spaceBtwItems),
            _buildLocationField('Drop Location', _dropController, false),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationField(String label, TextEditingController controller, bool isPickup) {
    return Row(
      children: [
        Icon(isPickup ? Icons.my_location : Icons.location_on, 
            color: AColors.primary),
        SizedBox(width: ASizes.spaceBtwItems),
        Expanded(
          child: GooglePlacesAutoCompleteTextFormField(
            textEditingController: controller,
            googleAPIKey: Config.googleMapApiKey,
            decoration: InputDecoration(
              labelText: label,
              border: InputBorder.none,
            ),
            onSuggestionClicked: (prediction) async {
              controller.text = prediction.description ?? '';
              final placeId = prediction.placeId;
              if (placeId != null) {
                final latLng = await _getPlaceCoordinates(placeId);
                setState(() {
                  if (isPickup) {
                    _pickupLocation = latLng;
                  } else {
                    _dropLocation = latLng;
                  }
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(ASizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Schedule', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: ASizes.spaceBtwItems),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () => _selectDate(context),
                  ),
                ),
                SizedBox(width: ASizes.spaceBtwItems),
                Expanded(
                  child: TextFormField(
                    controller: _timeController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Time',
                      suffixIcon: Icon(Icons.access_time),
                    ),
                    onTap: () => _selectTime(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeatsSelector() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(ASizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Number of Seats', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: ASizes.spaceBtwItems),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(4, (index) {
                final seats = index + 1;
                return _buildSeatButton(seats);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeatButton(int seats) {
    final isSelected = _seats == seats;
    return GestureDetector(
      onTap: () => setState(() => _seats = seats),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? AColors.primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            seats.toString(),
            style: TextStyle(
              fontSize: 18,
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Future<LatLng> _getPlaceCoordinates(String placeId) async {
    final url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${Config.googleMapApiKey}';
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);
    final location = data['result']['geometry']['location'];
    return LatLng(location['lat'], location['lng']);
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('MMM dd, yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
        _timeController.text = pickedTime.format(context);
      });
    }
  }

  void _findSharedRides() {
    if (_pickupLocation == null || _dropLocation == null) {
      Get.snackbar('Error', 'Please select pickup and drop locations');
      return;
    }

    final scheduledAt = _selectedDate != null && _selectedTime != null
        ? DateTime(
            _selectedDate!.year,
            _selectedDate!.month,
            _selectedDate!.day,
            _selectedTime!.hour,
            _selectedTime!.minute,
          )
        : null;

    // Get.to(() => AvailableSharedRidesScreen(
    //   pickupLocation: _pickupController.text,
    //   dropLocation: _dropController.text,
    //   pickupLat: _pickupLocation!.latitude,
    //   pickupLng: _pickupLocation!.longitude,
    //   dropLat: _dropLocation!.latitude,
    //   dropLng: _dropLocation!.longitude,
    //   seats: _seats,
    //   scheduledAt: scheduledAt,
    // ));
  }
}