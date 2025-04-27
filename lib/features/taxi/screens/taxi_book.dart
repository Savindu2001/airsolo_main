import 'dart:convert';
import 'package:airsolo/config.dart';
import 'package:airsolo/features/taxi/controllers/taxi_booking_controller.dart';
import 'package:airsolo/features/taxi/models/taxi_booking_model.dart';
import 'package:airsolo/features/taxi/models/vehicle_type_model.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class TaxiBookingScreen extends StatefulWidget {
  @override
  _TaxiBookingScreenState createState() => _TaxiBookingScreenState();
}

class _TaxiBookingScreenState extends State<TaxiBookingScreen> {
  final TaxiBookingController controller = Get.put(TaxiBookingController());
  final _formKey = GlobalKey<FormState>();
  List<LatLng> _routePoints = [];
  final _pickupController = TextEditingController();
  final _dropController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  LatLng? _pickupLocation;
  LatLng? _dropLocation;
  String? _selectedVehicleTypeId;
  bool _isShared = false;
  double? _distanceInKm;
  double? _estimatedFare;

  @override
  void initState() {
    super.initState();
    controller.fetchVehicleTypes();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _pickupLocation = LatLng(position.latitude, position.longitude);
        _pickupController.text = _pickupLocation.toString();
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> _getPlaceCoordinates(String placeId, bool isPickup) async {
    final url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${Config.googleMapApiKey}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final location = data['result']['geometry']['location'];
      final latLng = LatLng(location['lat'], location['lng']);
      
      setState(() {
        if (isPickup) {
          _pickupLocation = latLng;
        } else {
          _dropLocation = latLng;
        }
      });

      if (_pickupLocation != null && _dropLocation != null) {
        await _calculateDistanceAndFare();
      }
    }
  }

Future<void> _calculateDistanceAndFare() async {
  if (_pickupLocation == null || _dropLocation == null) return;

  final url = 'https://maps.googleapis.com/maps/api/directions/json'
      '?origin=${_pickupLocation!.latitude},${_pickupLocation!.longitude}'
      '&destination=${_dropLocation!.latitude},${_dropLocation!.longitude}'
      '&key=${Config.googleMapApiKey}';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    
    final data = json.decode(response.body);
    if (data['routes'] != null && data['routes'].isNotEmpty) {
      final distanceMeters = data['routes'][0]['legs'][0]['distance']['value'];
      final distanceKm = distanceMeters / 1000;

      // 🛠 Move encodedPolyline inside the if block
      final encodedPolyline = data['routes'][0]['overview_polyline']['points'];
      print('Encoded polyline: $encodedPolyline');

      setState(() {
        _distanceInKm = distanceKm;
        _routePoints = _decodePolyline(encodedPolyline);
      });

      print('Decoded points: ${_routePoints.length} points');

      _calculateEstimatedFare();
    } else {
      print('No route found in Directions API');
    }
  } else {
    print('Failed Directions API: ${response.statusCode}');
  }
}



List<LatLng> _decodePolyline(String encoded) {
  List<LatLng> points = [];
  int index = 0, len = encoded.length;
  int lat = 0, lng = 0;

  while (index < len) {
    int b, shift = 0, result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lng += dlng;

    points.add(LatLng(lat / 1E5, lng / 1E5));
  }
  return points;
}



  void _calculateEstimatedFare() {
    if (_distanceInKm == null ) return;

    final selectedVehicle = controller.vehicleTypes.firstWhere(
      (v) => v.id == _selectedVehicleTypeId,
    );

    double totalFare = 0;
    if (_distanceInKm! <= 5) {
      totalFare = selectedVehicle.priceFor5Km;
    } else {
      totalFare = selectedVehicle.priceFor5Km + ((_distanceInKm! - 5) * selectedVehicle.additionalPricePerKm);
    }

    setState(() {
      _estimatedFare = totalFare;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book a Taxi', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_pickupLocation != null && _dropLocation != null) _buildMapPreview() else Text('data'),
              
              
              if (_distanceInKm != null) _buildDistanceAndFareCard(),
              _buildLocationSection(),
              SizedBox(height: 20),
              _buildDateTimeSection(),
              SizedBox(height: 20),
              
              _buildVehicleTypeSection(),
              SizedBox(height: 20),
              _buildSharedBookingToggle(),
              SizedBox(height: 20),
              _buildBookNowButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildAutoCompleteField('Pickup Location', _pickupController, true),
            Divider(height: 20),
            _buildAutoCompleteField('Drop Location', _dropController, false),
          ],
        ),
      ),
    );
  }

  Widget _buildAutoCompleteField(String label, TextEditingController controller, bool isPickup) {
    return Row(
      children: [
        Icon(isPickup ? Icons.my_location : Icons.location_on, color: isPickup ? Colors.green : Colors.red),
        SizedBox(width: 10),
        Expanded(
          child: GooglePlacesAutoCompleteTextFormField(
                  textEditingController: controller,
                  googleAPIKey: Config.googleMapApiKey,
                  decoration: InputDecoration(
                    labelText: label,
                    border: InputBorder.none,
                    hintText: isPickup ? 'Where are you now?' : 'Where to go?',
                  ),
                  debounceTime: 800,
                  fetchCoordinates: true,
                  onSuggestionClicked: (prediction) {
                    controller.text = prediction.description ?? '';
                    _getPlaceCoordinates(prediction.placeId!, isPickup);
                  },
                )


        ),
      ],
    );
  }

  Widget _buildDateTimeSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Schedule', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedDate = DateTime.now();
                        _selectedTime = TimeOfDay.now();
                      });
                    },
                    icon: Icon(Icons.access_time),
                    label: Text('Now'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _isNowSelected() ? Colors.blue : Colors.grey,
                      side: BorderSide(color: _isNowSelected() ? Colors.blue : Colors.grey),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showDateTimePicker(context),
                    icon: Icon(Icons.calendar_today),
                    label: Text('Later'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: !_isNowSelected() ? Colors.blue : Colors.grey,
                      side: BorderSide(color: !_isNowSelected() ? Colors.blue : Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapPreview() {
  if (_pickupLocation == null || _dropLocation == null) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(
          7.00, 81.00
          ),
        zoom: 12
        ),
      );
  }

  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Container(
      height: 600,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GoogleMap(
          myLocationButtonEnabled: false,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              (_pickupLocation!.latitude + _dropLocation!.latitude) / 2,
              (_pickupLocation!.longitude + _dropLocation!.longitude) / 2,
            ),
            zoom: 15, 
          ),
          markers: {
            Marker(markerId: MarkerId('pickup'), position: _pickupLocation!, icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)),
            Marker(markerId: MarkerId('drop'), position: _dropLocation!, icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)),
          },
          polylines: _routePoints.isNotEmpty
              ? {
                  Polyline(
                    polylineId: PolylineId('route'),
                    points: _routePoints,
                    color: AColors.primary,
                    width: 7,
                  ),
                }
              : {},
        ),
      ),
    ),
  );
}



  Widget _buildDistanceAndFareCard() {
    return Card(
      margin: EdgeInsets.only(top: 20),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Distance: ${_distanceInKm!.toStringAsFixed(2)} km', style: TextStyle(fontSize: 16)),
            if (_estimatedFare != null)
              Text('Estimated Fare: LKR ${_estimatedFare!.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, color: Colors.green)),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Choose Vehicle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        Obx(() {
          if (controller.vehicleTypes.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          return Container(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.vehicleTypes.length,
              itemBuilder: (context, index) {
                final type = controller.vehicleTypes[index];
                return _buildVehicleTypeCard(type);
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildVehicleTypeCard(VehicleType type) {
    final isSelected = _selectedVehicleTypeId == type.id;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedVehicleTypeId = type.id;
          _calculateEstimatedFare();
        });
      },
      child: Container(
        width: 140,
        margin: EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Colors.blue : Colors.grey[300]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/icons/taxi.png', width: 80, height: 60),
            SizedBox(height: 8),
            Text(type.type, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 8,),
            Text(_estimatedFare.toString()),
            
          ],
        ),
      ),
    );
  }

  Widget _buildSharedBookingToggle() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Shared Ride', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Switch(
              value: _isShared,
              onChanged: (value) {
                setState(() {
                  _isShared = value;
                });
              },
              activeColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookNowButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitPrivateBooking,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text('BOOK NOW', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[800],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  bool _isNowSelected() {
    final now = DateTime.now();
    return _selectedDate.year == now.year &&
           _selectedDate.month == now.month &&
           _selectedDate.day == now.day;
  }

  Future<void> _showDateTimePicker(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (date != null) {
      final time = await showTimePicker(context: context, initialTime: _selectedTime);
      if (time != null) {
        setState(() {
          _selectedDate = date;
          _selectedTime = time;
        });
      }
    }
  }

  
  void _submitPrivateBooking() {
  if (_pickupLocation == null || _dropLocation == null) {
    Get.snackbar('Missing Info', 'Please select both pickup and drop locations.');
    return;
  }

  if (_selectedVehicleTypeId == null) {
    Get.snackbar('Missing Info', 'Please select a vehicle type.');
    return;
  }

  if (_formKey.currentState!.validate()) {
    final request = BookingRequest(
      pickupLocation: _pickupController.text,
      dropLocation: _dropController.text,
      pickupLat: _pickupLocation!.latitude,
      pickupLng: _pickupLocation!.longitude,
      dropLat: _dropLocation!.latitude,
      dropLng: _dropLocation!.longitude,
      date: _selectedDate,
      time: _selectedTime,
      vehicleTypeId: _selectedVehicleTypeId!,
    );
    controller.createBooking(request, _isShared);
  }
}

}
