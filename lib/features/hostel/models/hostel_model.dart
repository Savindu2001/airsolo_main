import 'dart:convert';

import 'package:airsolo/features/hostel/models/facility_model.dart';
import 'package:airsolo/features/hostel/models/house_rule_model.dart';
import 'package:airsolo/features/hostel/models/room_model.dart';
import 'package:intl/intl.dart';

class Hostel {
  final String id;
  final String hotelierId;
  final String name;
  final String? description;
  final String? address;
  final String cityId;
  final double? latitude;
  final double? longitude;
  final String? country;
  final String? contactNumber;
  final String email;
  final String? website;
  final double? rating;
  final List<String> gallery;
  final List<Room> rooms;
  final List<Facility> facilities;
  final List<HouseRule> houseRules;
  final DateTime createdAt;
  final DateTime updatedAt;

  Hostel({
    required this.id,
    required this.hotelierId,
    required this.name,
    this.description,
    this.address,
    required this.cityId,
    this.latitude,
    this.longitude,
    this.country,
    this.contactNumber,
    required this.email,
    this.website,
    this.rating,
    required this.gallery,
    required this.rooms,
    required this.facilities,
    required this.houseRules,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Hostel.fromJson(Map<String, dynamic> json) {
    return Hostel(
      id: json['id'] ?? '',
      hotelierId: json['hotelier_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      address: json['address'],
      cityId: json['cityId'] ?? '',
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
      country: json['country'],
      contactNumber: json['contact_number'],
      email: json['email'] ?? '',
      website: json['website'],
      rating: _parseDouble(json['rating']),
      gallery: _parseImages(json['gallery']),
      rooms: _parseRoomList(json['rooms'] ?? []),
      facilities: _parseFacilityList(json['facilities'] ?? []),
      houseRules: _parseHouseRuleList(json['house_rules'] ?? []),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }


   static List<String> _parseImages(dynamic imagesData) {
    if (imagesData == null) return [];
    
    // Handle string case (could be JSON string)
    if (imagesData is String) {
      try {
        // Remove any extra quotes or brackets if present
        final cleanedString = imagesData
            .replaceAll('"[', '[')
            .replaceAll(']"', ']')
            .replaceAll('\\"', '"');
        
        final decoded = jsonDecode(cleanedString);
        if (decoded is List) {
          return List<String>.from(decoded.whereType<String>());
        }
        return [decoded.toString()];
      } catch (e) {
        // If parsing fails, treat the whole string as a single image URL
        return [imagesData];
      }
    }
    
    // Handle list case
    if (imagesData is List) {
      return List<String>.from(imagesData.whereType<String>());
    }
    
    return [];
  }

 


  static List<Room> _parseRoomList(List<dynamic> data) {
    if (data == null) return [];
    if (data is List){
      return data.map((json) => Room.fromJson(json)).toList();
    }
    return [];
  }

  static List<Facility> _parseFacilityList(List<dynamic> data) {
    return data.map((json) => Facility.fromJson(json)).toList();
  }

  static List<HouseRule> _parseHouseRuleList(List<dynamic> data) {
    return data.map((json) => HouseRule.fromJson(json)).toList();
  }

  static DateTime _parseDateTime(dynamic dateTimeData) {
    if (dateTimeData == null) return DateTime.now();
    if (dateTimeData is String) return DateTime.parse(dateTimeData);
    return DateTime.now();
  }

  String get formattedCreatedAt => DateFormat('MMM d, y').format(createdAt);



  Hostel copyWith({
    String? id,
    String? hotelierId,
    String? name,
    String? description,
    String? address,
    String? cityId,
    double? latitude,
    double? longitude,
    String? country,
    String? contactNumber,
    String? email,
    String? website,
    double? rating,
    List<String>? gallery,
    List<Room>? rooms,
    List<Facility>? facilities,
    List<HouseRule>? houseRules,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Hostel(
      id: id ?? this.id,
      hotelierId: hotelierId ?? this.hotelierId,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      cityId: cityId ?? this.cityId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      country: country ?? this.country,
      contactNumber: contactNumber ?? this.contactNumber,
      email: email ?? this.email,
      website: website ?? this.website,
      rating: rating ?? this.rating,
      gallery: gallery ?? this.gallery,
      rooms: rooms ?? this.rooms,
      facilities: facilities ?? this.facilities,
      houseRules: houseRules ?? this.houseRules,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}