import 'package:flutter/material.dart';

class BookingRequest {
  final String pickupLocation;
  final String dropLocation;
  final double pickupLat;
  final double pickupLng;
  final double dropLat;
  final double dropLng;
  final DateTime date;
  final TimeOfDay time;
  final String vehicleTypeId;
  
  BookingRequest({
    required this.pickupLocation,
    required this.dropLocation,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropLat,
    required this.dropLng,
    required this.date,
    required this.time,
    required this.vehicleTypeId,
  });
}


class TaxiBooking {
  final String id;
  final String vehicleId;
  final String travelerId;
  final double distance;
  final double totalPrice;
  final bool isShared;
  final int seatsToShare;
  final int bookedSeats;
  final List<String> travelerIds;
  final DateTime bookingDate;
  final String status;

  TaxiBooking({
    required this.id,
    required this.vehicleId,
    required this.travelerId,
    required this.distance,
    required this.totalPrice,
    required this.isShared,
    required this.seatsToShare,
    required this.bookedSeats,
    required this.travelerIds,
    required this.bookingDate,
    required this.status,
  });

  factory TaxiBooking.fromJson(Map<String, dynamic> json) {
    return TaxiBooking(
      id: json['id'],
      vehicleId: json['vehicleId'],
      travelerId: json['travelerId'],
      distance: json['distance'].toDouble(),
      totalPrice: json['totalPrice'].toDouble(),
      isShared: json['isShared'],
      seatsToShare: json['seatsToShare'],
      bookedSeats: json['bookedSeats'],
      travelerIds: List<String>.from(json['travelerIds']),
      bookingDate: DateTime.parse(json['bookingDate']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'travelerId': travelerId,
      'distance': distance,
      'totalPrice': totalPrice,
      'isShared': isShared,
      'seatsToShare': seatsToShare,
      'bookedSeats': bookedSeats,
      'travelerIds': travelerIds,
      'bookingDate': bookingDate.toIso8601String(),
      'status': status,
    };
  }
}