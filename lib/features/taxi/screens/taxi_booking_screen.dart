// import 'package:airsolo/config.dart';
// import 'package:airsolo/features/taxi/controllers/taxi_booking_controller.dart';
// import 'package:airsolo/features/taxi/models/taxi_booking_model.dart';
// import 'package:airsolo/features/taxi/models/vehicle_type_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
// import 'package:intl/intl.dart';
// import 'package:geolocator/geolocator.dart';

// class TaxiBookingScreen extends StatefulWidget {
//   @override
//   _TaxiBookingScreenState createState() => _TaxiBookingScreenState();
// }

// class _TaxiBookingScreenState extends State<TaxiBookingScreen> {
//   final TaxiBookingController controller = Get.put(TaxiBookingController());
//   final _formKey = GlobalKey<FormState>();
//   final _pickupController = TextEditingController();
//   final _dropController = TextEditingController();
//   DateTime _selectedDate = DateTime.now();
//   TimeOfDay _selectedTime = TimeOfDay.now();
//   LatLng? _pickupLocation;
//   LatLng? _dropLocation;
//   String? _selectedVehicleTypeId;
//   bool _isShared = false;

//   @override
//   void initState() {
//     super.initState();
//     controller.fetchVehicleTypes();
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         return;
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           return;
//         }
//       }

//       Position position = await Geolocator.getCurrentPosition();
//       setState(() {
//         _pickupLocation = LatLng(position.latitude, position.longitude);
//         _pickupController.text = 'Current Location';
//       });
//     } catch (e) {
//       print("Error getting location: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Book a Taxi', style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//         backgroundColor: Colors.blue[800],
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Section 1: Pickup/Drop Location
//               _buildLocationSection(),
//               SizedBox(height: 20),
              
//               // Section 2: Now/Later Selection
//               _buildDateTimeSection(),
//               SizedBox(height: 20),
              
//               // Section 3: Map Preview
//               if (_pickupLocation != null && _dropLocation != null)
//                 _buildMapPreview(),
              
//               // Section 4: Vehicle Types
//               _buildVehicleTypeSection(),
//               SizedBox(height: 20),
              
//               // Section 5: Shared Booking Toggle
//               _buildSharedBookingToggle(),
//               SizedBox(height: 20),
              
//               // Section 6: Book Now Button
//               _buildBookNowButton(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }





// Widget _buildLocationSection() {
//   return Card(
//     elevation: 2,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(12),
//     ),
//     child: Padding(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         children: [
//           // Pickup Location
//           Row(
//             children: [
//               Icon(Icons.my_location, color: Colors.green),
//               SizedBox(width: 10),
//               Expanded(
//                 child: GooglePlacesAutoCompleteTextFormField(
//                   textEditingController: _pickupController,
//                   googleAPIKey: Config.googleMapApiKey,
//                   decoration: InputDecoration(
//                     labelText: 'Pickup Location',
//                     border: InputBorder.none,
//                     hintText: 'Where are you now?',
//                   ),
//                   debounceTime: 800,
//                   onChanged: (value) {
                    
//                   },
                  
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(Icons.gps_fixed),
//                 onPressed: _getCurrentLocation,
//                 tooltip: 'Use current location',
//               ),
//             ],
//           ),
//           Divider(height: 20, thickness: 1),
          
//           // Drop Location
//           Row(
//             children: [
//               Icon(Icons.location_on, color: Colors.red),
//               SizedBox(width: 10),
//               Expanded(
//                 child: GooglePlacesAutoCompleteTextFormField(
//                   textEditingController: _dropController,
//                   googleAPIKey: Config.googleMapApiKey,
//                   decoration: InputDecoration(
//                     labelText: 'Drop Location',
//                     border: InputBorder.none,
//                     hintText: 'Where to go?',
//                   ),
//                   debounceTime: 800,
//                   onChanged: (value) {
                    
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }

// Future<void> _getPlaceCoordinates(String placeId, bool isPickup) async {
  
// }




//   Widget _buildDateTimeSection() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Schedule', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             SizedBox(height: 12),
            
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // Now Button
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     onPressed: () {
//                       setState(() {
//                         _selectedDate = DateTime.now();
//                         _selectedTime = TimeOfDay.now();
//                       });
//                     },
//                     icon: Icon(Icons.access_time, size: 18),
//                     label: Text('Now'),
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: _isNowSelected() ? Colors.blue : Colors.grey,
//                       side: BorderSide(color: _isNowSelected() ? Colors.blue : Colors.grey),
//                       padding: EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),
                
//                 SizedBox(width: 12),
                
//                 // Later Button
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     onPressed: () => _showDateTimePicker(context),
//                     icon: Icon(Icons.calendar_today, size: 18),
//                     label: Text('Later'),
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: !_isNowSelected() ? Colors.blue : Colors.grey,
//                       side: BorderSide(color: !_isNowSelected() ? Colors.blue : Colors.grey),
//                       padding: EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
            
//             if (!_isNowSelected()) ...[
//               SizedBox(height: 12),
//               Container(
//                 padding: EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[100],
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text('Selected Time:', style: TextStyle(color: Colors.grey[600])),
//                     Text(
//                       '${DateFormat('MMM dd, yyyy').format(_selectedDate)} at ${_selectedTime.format(context)}',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildVehicleTypeSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Choose Vehicle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         SizedBox(height: 12),
        
//         Obx(() {
//           if (controller.vehicleTypes.isEmpty) {
//             return Center(child: CircularProgressIndicator());
//           }
          
//           return Container(
//             height: 160,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: controller.vehicleTypes.length,
//               itemBuilder: (context, index) {
//                 final type = controller.vehicleTypes[index];
//                 return _buildVehicleTypeCard(type);
//               },
//             ),
//           );
//         }),
//       ],
//     );
//   }

//   Widget _buildVehicleTypeCard(VehicleType type) {
//     final isSelected = _selectedVehicleTypeId == type.id;
//     // Calculate approximate price for 5km
//     final basePrice = type.priceFor5Km;
//     final additionalPrice = type.additionalPricePerKm * 5; // Example for 5km
//     final totalPrice = basePrice + additionalPrice;
    
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedVehicleTypeId = type.id;
//         });
//       },
//       child: Container(
//         width: 140,
//         margin: EdgeInsets.only(right: 12),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.blue[50] : Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected ? Colors.blue : Colors.grey[300]!,
//             width: isSelected ? 2 : 1,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 4,
//               offset: Offset(0, 2),
//         )],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Vehicle Image (replace with your actual assets)
//             Container(
//               width: 80,
//               height: 60,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage('assets/images/icons/taxi.png'),
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ),
//             SizedBox(height: 8),
            
//             // Vehicle Type Name
//             Text(
//               type.type,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//             SizedBox(height: 4),
            
//             // Price Information
//             Text(
//               '\$${totalPrice.toStringAsFixed(2)}',
//               style: TextStyle(
//                 color: Colors.green[700],
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             SizedBox(height: 4),
            
            
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSharedBookingToggle() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Shared Ride',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Switch(
//               value: _isShared,
//               onChanged: (value) {
//                 setState(() {
//                   _isShared = value;
//                 });
//               },
//               activeColor: Colors.blue,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMapPreview() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Container(
//         height: 200,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(12),
//           child: GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: _pickupLocation!,
//               zoom: 14,
//             ),
//             markers: {
//               Marker(
//                 markerId: MarkerId('pickup'),
//                 position: _pickupLocation!,
//                 icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
//               ),
//               Marker(
//                 markerId: MarkerId('drop'),
//                 position: _dropLocation!,
//                 icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//               ),
//             },
//             polylines: {
//               Polyline(
//                 polylineId: PolylineId('route'),
//                 points: [_pickupLocation!, _dropLocation!],
//                 color: Colors.blue,
//                 width: 3,
//               ),
//             },
//           ),
//         ),
//       ),
//     );
//   }

// Widget _buildBookNowButton() {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: _submitPrivateBooking,
//         child: Padding(
//           padding: EdgeInsets.symmetric(vertical: 16),
//           child: Text(
//             'BOOK NOW',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               letterSpacing: 1.2,
//             ),
//           ),
//         ),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.blue[800],
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           elevation: 2,
//         ),
//       ),
//     );
//   }

//   bool _isNowSelected() {
//     final now = DateTime.now();
//     return _selectedDate.year == now.year &&
//            _selectedDate.month == now.month &&
//            _selectedDate.day == now.day &&
//            _selectedTime.hour == TimeOfDay.now().hour &&
//            _selectedTime.minute == TimeOfDay.now().minute;
//   }

//   Future<void> _showDateTimePicker(BuildContext context) async {
//     final date = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(Duration(days: 30)),
//     );
    
//     if (date != null) {
//       final time = await showTimePicker(
//         context: context,
//         initialTime: _selectedTime,
//       );
      
//       if (time != null) {
//         setState(() {
//           _selectedDate = date;
//           _selectedTime = time;
//         });
//       }
//     }
//   }

//   void _submitPrivateBooking() {
//     if (_formKey.currentState!.validate() &&
//         _pickupLocation != null &&
//         _dropLocation != null &&
//         _selectedVehicleTypeId != null) {
//       final request = BookingRequest(
//         pickupLocation: _pickupController.text,
//         dropLocation: _dropController.text,
//         pickupLat: _pickupLocation!.latitude,
//         pickupLng: _pickupLocation!.longitude,
//         dropLat: _dropLocation!.latitude,
//         dropLng: _dropLocation!.longitude,
//         date: _selectedDate,
//         time: _selectedTime,
//         vehicleTypeId: _selectedVehicleTypeId!,
//       );
//       controller.createBooking(request, _isShared);
//     }
//   }
// }