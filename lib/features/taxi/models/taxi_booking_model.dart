import 'dart:convert';

import 'package:airsolo/features/taxi/models/vehicle_model.dart';
import 'package:airsolo/features/users/user_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TaxiBooking {
  final String id;
  final String travelerId;
  final String? vehicleId;
  final String pickupLocation;
  final String dropLocation;
  final LatLng pickupLatLng;
  final LatLng dropLatLng;
  final double distance;
  final double totalPrice;
  final bool isShared;
  final int bookedSeats;
  final List<String> travelerIds;
  final DateTime bookingDateTime;
  final String status;
  final String paymentStatus;
  final DateTime? scheduledAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final Vehicle? assignedVehicle;
  final User? traveler;

  TaxiBooking({
    required this.id,
    required this.travelerId,
    this.vehicleId,
    required this.pickupLocation,
    required this.dropLocation,
    required this.pickupLatLng,
    required this.dropLatLng,
    required this.distance,
    required this.totalPrice,
    required this.isShared,
    required this.bookedSeats,
    required this.travelerIds,
    required this.bookingDateTime,
    required this.status,
    required this.paymentStatus,
    this.scheduledAt,
    this.startedAt,
    this.completedAt,
    this.assignedVehicle,
    this.traveler,
  });






factory TaxiBooking.fromJson(Map<String, dynamic> json) {
  // Helper function to parse dynamic values to double
  double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  // Helper to parse travelerIds which comes as a JSON string
  List<String> parseTravelerIds(dynamic value) {
    if (value == null) return [];
    if (value is List) return List<String>.from(value);
    if (value is String) {
      try {
        return List<String>.from(jsonDecode(value));
      } catch (e) {
        return [value];
      }
    }
    return [];
  }

  return TaxiBooking(
    id: json['id']?.toString() ?? '',
    travelerId: json['travelerId']?.toString() ?? '',
    vehicleId: json['vehicleId']?.toString(),
    pickupLocation: json['pickupLocation']?.toString() ?? '',
    dropLocation: json['dropLocation']?.toString() ?? '',
    pickupLatLng: LatLng(
      parseDouble(json['pickupLat']),
      parseDouble(json['pickupLng']),
    ),
    dropLatLng: LatLng(
      parseDouble(json['dropLat']),
      parseDouble(json['dropLng']),
    ),
    distance: parseDouble(json['distance']),
    totalPrice: parseDouble(json['totalPrice']), // Handles string "1036.72"
    isShared: json['isShared'] ?? false,
    bookedSeats: json['bookedSeats'] is int ? json['bookedSeats'] : int.tryParse(json['bookedSeats']?.toString() ?? '1') ?? 1,
    travelerIds: parseTravelerIds(json['travelerIds']), // Handles JSON string
    bookingDateTime: DateTime.parse(json['bookingDateTime'] ?? DateTime.now().toIso8601String()),
    status: json['status']?.toString() ?? 'pending',
    paymentStatus: json['paymentStatus']?.toString() ?? 'pending',
    scheduledAt: json['scheduledAt'] != null ? DateTime.tryParse(json['scheduledAt'].toString()) : null,
    startedAt: json['startedAt'] != null ? DateTime.tryParse(json['startedAt'].toString()) : null,
    completedAt: json['completedAt'] != null ? DateTime.tryParse(json['completedAt'].toString()) : null,

    assignedVehicle: json['assignedVehicle'] != null 
          ? Vehicle.fromJson(json['assignedVehicle'])
          : null,
      traveler: json['traveler'] != null
          ? User.fromJson(json['traveler'])
          : null,
          
  );
}









  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'travelerId': travelerId,
      'vehicleId': vehicleId,
      'pickupLocation': pickupLocation,
      'dropLocation': dropLocation,
      'pickupLat': pickupLatLng.latitude,
      'pickupLng': pickupLatLng.longitude,
      'dropLat': dropLatLng.latitude,
      'dropLng': dropLatLng.longitude,
      'distance': distance,
      'totalPrice': totalPrice,
      'isShared': isShared,
      'bookedSeats': bookedSeats,
      'travelerIds': travelerIds,
      'bookingDateTime': bookingDateTime.toIso8601String(),
      'status': status,
      'payment_status': paymentStatus,
      'scheduled_at': scheduledAt?.toIso8601String(),
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}