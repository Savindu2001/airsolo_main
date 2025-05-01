import 'dart:async';
import 'dart:ui';

import 'package:airsolo/features/taxi/controllers/taxi_booking_controller.dart';
import 'package:airsolo/features/taxi/models/taxi_booking_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class FetchingDriverScreen extends StatefulWidget {
  final String bookingId;
  final Function(TaxiBooking) onDriverAccepted;
  final Function() onTimeout;

  const FetchingDriverScreen({
    Key? key,
    required this.bookingId,
    required this.onDriverAccepted,
    required this.onTimeout,
  }) : super(key: key);

  @override
  _FetchingDriverScreenState createState() => _FetchingDriverScreenState();
}


class _FetchingDriverScreenState extends State<FetchingDriverScreen> {
  final TaxiBookingController controller = Get.find();
  late Timer _timer;
  int _elapsedSeconds = 0;
  final int _timeoutSeconds = 120; // 2 minutes timeout

  @override
  void initState() {
    super.initState();
    _startPolling();
  }


  // Add to FetchingDriverScreen's initState
// void _setupFirebaseListener() {
//   FirebaseFirestore.instance
//       .collection('bookings')
//       .doc(widget.bookingId)
//       .snapshots()
//       .listen((snapshot) {
//     if (snapshot.exists) {
//       final status = snapshot.data()?['status'];
//       if (status == 'driver_accepted') {
//         // Stop the timer
//         _timer.cancel();
        
//         // Fetch full booking details
//         controller.getAcceptedBooking(widget.bookingId).then((_) {
//           if (controller.currentBooking.value != null) {
//             widget.onDriverAccepted(controller.currentBooking.value!);
//           }
//         });
//       } else if (status == 'cancelled' || status == 'rejected') {
//         _timer.cancel();
//         Get.back();
//         Get.snackbar('Info', 'No driver accepted your booking');
//       }
//     }
//   });
// }

void _startPolling() {
  // Check every 3 seconds for updates
  _timer = Timer.periodic(Duration(seconds: 3), (timer) async {
    if (_elapsedSeconds >= _timeoutSeconds) {
      timer.cancel();
      widget.onTimeout();
      return;
    }

    _elapsedSeconds += 3;
    
    try {
      // Use checkBookingStatus instead of getAcceptedBooking
      final status = await controller.checkBookingStatus(widget.bookingId);
      
      if (status == 'driver_accepted') {
        timer.cancel();
        // Now get full booking details
        await controller.getBookingDetails(widget.bookingId);
        if (controller.currentBooking.value != null) {
          widget.onDriverAccepted(controller.currentBooking.value!);
        }
      } else if (status == 'cancelled' || status == 'rejected') {
        timer.cancel();
        Get.back();
        Get.snackbar('Info', 'No driver accepted your booking');
      }
    } catch (e) {
      print('Error polling booking status: $e');
    }
  });
}

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finding a Driver'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              _timer.cancel();
              controller.updateBookingStatus(bookingId: widget.bookingId, status: 'cancelled');
              Get.back();
            },
            child: Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Searching for available drivers...'),
            SizedBox(height: 10),
            Text('Time elapsed: ${_elapsedSeconds}s'),
            SizedBox(height: 20),
            Text('We\'ll notify you when a driver accepts', 
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}



