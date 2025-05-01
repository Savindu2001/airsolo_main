import 'dart:convert';
import 'package:airsolo/config.dart';
import 'package:airsolo/features/taxi/controllers/taxi_booking_controller.dart';
import 'package:airsolo/features/taxi/models/taxi_booking_model.dart';
import 'package:airsolo/features/taxi/models/vehicle_type_model.dart';
import 'package:airsolo/features/taxi/screens/fetch_driver_screen.dart';
import 'package:airsolo/features/taxi/screens/ongoing_booking_screen.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';

class TaxiBookingScreen extends StatefulWidget {
  const TaxiBookingScreen({super.key});

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

      //  Move encodedPolyline inside the if block
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


  // Calculation
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
        title: Text('Book a Taxi', style: Get.textTheme.headlineMedium!.copyWith(color:AHelperFunctions.isDarkMode(context) ? AColors.black : AColors.white)),
        centerTitle: true,
        backgroundColor: AHelperFunctions.isDarkMode(context) ? AColors.primary : AColors.homePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_pickupLocation != null && _dropLocation != null) _buildMapPreview() 
              else  Container(
                height: 300,
                
                child: Image.asset('assets/images/banners/taxi.jpg'),
              ),
              
              
              
              _buildLocationSection(),
              const SizedBox(height: ASizes.spaceBtwItems),
              _buildDateTimeSection(),
              const SizedBox(height: ASizes.spaceBtwItems),
              
              _buildVehicleTypeSection(),
              const SizedBox(height: ASizes.spaceBtwItems),
              if (_distanceInKm != null) Center(child: _buildDistanceAndFareCard()),
              const SizedBox(height: ASizes.spaceBtwItems),
              _buildSharedBookingToggle(),
              const SizedBox(height: ASizes.spaceBtwItems),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildAutoCompleteField('Pickup Location', _pickupController, true),
            const Divider(height: 20),
            _buildAutoCompleteField('Drop Location', _dropController, false),
          ],
        ),
      ),
    );
  }

  Widget _buildAutoCompleteField(String label, TextEditingController controller, bool isPickup) {
    return Row(
      children: [
        Icon(isPickup ? Icons.my_location : Icons.location_on, color: isPickup ? AColors.primary : AColors.homePrimary),
        const SizedBox(width: 10),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Schedule', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
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
                    icon: const Icon(Icons.access_time),
                    label: const Text('Now'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _isNowSelected() ? AColors.homePrimary : Colors.white,
                      side: BorderSide(color: _isNowSelected() ? AColors.homePrimary : Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showDateTimePicker(context),
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Later'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: !_isNowSelected() ? AColors.homePrimary : Colors.white,
                      side: BorderSide(color: !_isNowSelected() ? AColors.homePrimary : Colors.white),
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
    return const SizedBox();
  }

  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: SizedBox(
      height: 450,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GoogleMap(
          myLocationButtonEnabled: false,
          zoomGesturesEnabled: false,
          zoomControlsEnabled: true,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              (_pickupLocation!.latitude + _dropLocation!.latitude) / 2,
              (_pickupLocation!.longitude + _dropLocation!.longitude) / 2,
            ),
            zoom: 10, 
          ),
          markers: {
            Marker(markerId: const MarkerId('pickup'), position: _pickupLocation!, icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)),
            Marker(markerId: const MarkerId('drop'), position: _dropLocation!, icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)),
          },
          polylines: _routePoints.isNotEmpty
              ? {
                  Polyline(
                    polylineId: const PolylineId('route'),
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
      borderOnForeground: true,
      margin: const EdgeInsets.only(top: 20),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Distance: ${_distanceInKm!.toStringAsFixed(2)} km', style: const TextStyle(fontSize: 16)),
            if (_estimatedFare != null)
              Text('Estimated Fare: LKR ${_estimatedFare!.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, color: AColors.success)),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Choose Vehicle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Obx(() {
          if (controller.vehicleTypes.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return SizedBox(
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


    String vehicleImage;
    switch (type.type) {
      case 'Tuk Tuk':
        vehicleImage = 'assets/images/icons/tuk.png';
        break;
      case 'Car':
        vehicleImage = 'assets/images/icons/car.png';
        break;
      case 'Van':
        vehicleImage = 'assets/images/icons/van.png';
        break;
      case 'SUV':
        vehicleImage = 'assets/images/icons/suv.png';
      default:
        vehicleImage = 'assets/images/icons/taxi.png'; 
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedVehicleTypeId = type.id;
          _calculateEstimatedFare();
        });
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected ? AColors.primary: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AColors.primary : AColors.homePrimary),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(vehicleImage, width: 80, height: 60),
            const SizedBox(height: 8),
            Text(type.type, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AHelperFunctions.isDarkMode(context) ? AColors.black : AColors.homePrimary)),
            const SizedBox(height: 8,),
            
          ],
        ),
      ),
    );
  }

  Widget _buildSharedBookingToggle() {
    return Card(
      color: AColors.homePrimary,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Shared Ride', style: Get.textTheme.titleLarge!.copyWith(color:AHelperFunctions.isDarkMode(context) ? AColors.black : AColors.white)),
            Switch(
              value: _isShared,
              onChanged: (value) {
                setState(() {
                  _isShared = value;
                });
              },
              activeColor: AColors.white,
              inactiveTrackColor: AColors.black,
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
        child: Text('BOOK TAXI', 
            style: Get.textTheme.titleLarge!.copyWith(color: AHelperFunctions.isDarkMode(context) ? AColors.black : AColors.primary)))
            ,
        
      
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
      lastDate: DateTime.now().add(const Duration(days: 30)),
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

  

// void _submitPrivateBooking() async {
//   if (_pickupLocation == null || _dropLocation == null) {
//     Get.snackbar('Missing Info', 'Please select both pickup and drop locations.');
//     return;
//   }

//   if (_selectedVehicleTypeId == null) {
//     Get.snackbar('Missing Info', 'Please select a vehicle type.');
//     return;
//   }

//   if (_formKey.currentState!.validate()) {
//     // Show loading indicator
//     Get.dialog(
//       const Center(child: CircularProgressIndicator()),
//       barrierDismissible: false,
//     );

//     try {
//       // Call the controller to create booking
//       final bookingResult = await controller.createBooking(
//         pickupLocation: _pickupController.text,
//         dropLocation: _dropController.text,
//         pickupLat: _pickupLocation!.latitude,
//         pickupLng: _pickupLocation!.longitude,
//         dropLat: _dropLocation!.latitude,
//         dropLng: _dropLocation!.longitude,
//         vehicleTypeId: _selectedVehicleTypeId!,
//         isShared: _isShared,
//         seats: _isShared ? 2 : 1,
//         scheduledAt: _isNowSelected()
//             ? null
//             : DateTime(
//                 _selectedDate.year,
//                 _selectedDate.month,
//                 _selectedDate.day,
//                 _selectedTime.hour,
//                 _selectedTime.minute,
//               ),
//       );

//       // Check booking result status
//       if (bookingResult != null) {
//         // Successfully created booking, show available drivers UI
//         Get.to(() =>  FetchingDriverScreen());
//       } else {
//         // Booking failed, show error
//         Get.snackbar('Booking Error', 'Unable to create the booking. Please try again.');
//       }
//     } catch (e) {
//       // Dismiss loading indicator
//       Get.back();
//       // Show error message
//       Get.snackbar('Error', 'Failed to create booking: ${e.toString()}');
//     }
//   }
// }

void _submitPrivateBooking() async {
  if (_pickupLocation == null || _dropLocation == null) {
    Get.snackbar('Missing Info', 'Please select both pickup and drop locations.');
    return;
  }

  if (_selectedVehicleTypeId == null) {
    Get.snackbar('Missing Info', 'Please select a vehicle type.');
    return;
  }

  Get.dialog(
    const Center(child: CircularProgressIndicator()),
    barrierDismissible: false,
  );

  try {
    final bookingResult = await controller.createBooking(
      pickupLocation: _pickupController.text,
      dropLocation: _dropController.text,
      pickupLat: _pickupLocation!.latitude,
      pickupLng: _pickupLocation!.longitude,
      dropLat: _dropLocation!.latitude,
      dropLng: _dropLocation!.longitude,
      vehicleTypeId: _selectedVehicleTypeId!,
      isShared: _isShared,
      seats: _isShared ? 2 : 1,
      scheduledAt: _isNowSelected() ? null : DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      ),
    );

    if (bookingResult != null) {
      Get.back(); // Dismiss initial loading
      
      // Navigate to fetching screen
      Get.to(() => FetchingDriverScreen(
        bookingId: bookingResult.id,
        onDriverAccepted: (booking) {
          // Show booking details when driver accepts
          _showBookingDetails(booking);
        },
        onTimeout: () {
          Get.back();
          Get.snackbar('Timeout', 'No driver found. Please try again later.');
        },
      ));
    } else {
      Get.back();
      Get.snackbar('Error', 'Failed to create booking');
    }
  } catch (e) {
    Get.back();
    Get.snackbar('Error', 'Failed to create booking: ${e.toString()}');
  }
}

void _showBookingDetails(TaxiBooking booking) {
  // Extract driver and vehicle details safely
  final driverName = booking.assignedVehicle?.driverId ?? 'Driver';
  final vehicleInfo = booking.assignedVehicle != null 
      ? '(${booking.assignedVehicle!.vehicleNumber})'
      : 'Vehicle info not available';

  Get.bottomSheet(
    Container(
      //height: MediaQuery.of(Get.context).size.height *0.75,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Driver Found!', style: Get.textTheme.titleLarge),
            SizedBox(height: 20),
            
            // Driver Information
            ListTile(
              leading: Icon(Iconsax.user, color: Colors.blue),
              title: Text('Driver', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                '$driverName.substring(0, 8).toUpperCase()'
                'Rating: 4.8 ★', // You can add actual rating if available
                style: TextStyle(color: Colors.black54),
              ),
            ),
            
            // Vehicle Information
            ListTile(
              leading: Icon(Iconsax.car, color: Colors.green),
              title: Text('Vehicle', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vehicleInfo),
                  
                ],
              ),
            ),
            
            // Trip Information
            ListTile(
              leading: Icon(Iconsax.location3, color: Colors.red),
              title: Text('Pickup Location', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                booking.pickupLocation,
                style: TextStyle(color: Colors.black87),
              ),
            ),
            
            ListTile(
              leading: Icon(Iconsax.flag, color: Colors.orange),
              title: Text('Drop Location', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                booking.dropLocation,
                style: TextStyle(color: Colors.black87),
              ),
            ),
            
            // Fare Information
            ListTile(
              leading: Icon(Icons.attach_money, color: Colors.green),
              title: Text('Estimated Fare', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                'LKR ${booking.totalPrice}',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.back(); 
                Get.to(()=> OngoingBookingScreen(booking: booking)); 
              },
              child: Text('VIEW TRIP DETAILS', style: Get.textTheme.titleLarge),
            ),
          ],
        ),
      ),
    ),
  );
}

}
