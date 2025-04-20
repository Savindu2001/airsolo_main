import 'dart:convert';

import 'package:get/get.dart';

enum RoomType {
  mixed_dormitory,
  shared_dormitory,
  womens_dormitory,
  mens_dormitory,
  deluxe_dormitory,
  private_room,
}

enum BedType {
  double,
  bunk_bed,
  single_bed,
}

class Room {
  final String id;
  final String hostelId;
  final String name;
  final RoomType type;
  final BedType bedType;
  final int bedQty;
  final int maxOccupancy;
  final double pricePerPerson;
  final List<String> images;
  final List<String> facilityIds;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double? size; 
  final bool hasPrivateBathroom;
  final String? bedDescription;
  final String? hostelName;
  final double? hostelLatitude;
  final double? hostelLongitude;
  final String? description;

  Room({
    required this.id,
    required this.hostelId,
    required this.name,
    required this.type,
    required this.bedType,
    required this.bedQty,
    required this.maxOccupancy,
    required this.pricePerPerson,
    required this.images,
    required this.facilityIds,
    required this.createdAt,
    required this.updatedAt,
    this.size = 18,
    this.hasPrivateBathroom = true,
    this.bedDescription,
    this.hostelName,
    this.hostelLatitude,
    this.hostelLongitude,
    this.description,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: _parseString(json['id']),
      hostelId: _parseString(json['hostel_id']),
      name: _parseString(json['name']),
      type: _parseRoomType(json['type']),
      bedType: _parseBedType(json['bed_type']),
      bedQty: _parseInt(json['bed_qty']),
      maxOccupancy: _parseInt(json['max_occupancy']),
      pricePerPerson: _parseDouble(json['price_per_person']),
      images: _parseImages(json['images']),
      facilityIds: _parseStringList(json['facility_ids']),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      size: _parseDouble(json['size'] ?? '18m'),
      hasPrivateBathroom: json['has_private_bathroom'] ?? false,
      bedDescription: json['bed_description'],
      hostelName: json['hostel_name'],
      hostelLatitude: _parseDouble(json['hostel_latitude']),
      hostelLongitude: _parseDouble(json['hostel_longitude']),
      description: json['description'],
    );
  }

  // Getters
  String get formattedPrice => '\$${pricePerPerson.toStringAsFixed(2)}/night';
  String get typeDisplayName => type.toString().split('.').last.replaceAll('_', ' ').capitalizeFirst!;
  String get bedTypeDisplayName => bedType.toString().split('.').last.replaceAll('_', ' ').capitalizeFirst!;
  String get bedQuantityDescription => '$bedQty ${bedTypeDisplayName.toLowerCase()}${bedQty > 1 ? 's' : ''}';
  String? get sizeDescription => size != null ? '${size!.toStringAsFixed(0)} sq ft' : null;

  // Helper parsing methods
  static String _parseString(dynamic value) => value?.toString() ?? '';

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
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

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static List<String> _parseStringList(dynamic value) {
    if (value is List) return value.map((e) => e.toString()).toList();
    return [];
  }

  static DateTime _parseDateTime(dynamic value) {
    try {
      return DateTime.parse(value.toString());
    } catch (e) {
      return DateTime.now();
    }
  }

  static RoomType _parseRoomType(dynamic value) {
    final type = value?.toString().toLowerCase() ?? '';
    return RoomType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => RoomType.mixed_dormitory,
    );
  }

  static BedType _parseBedType(dynamic value) {
    final type = value?.toString().toLowerCase().replaceAll(' ', '_') ?? '';
    return BedType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => BedType.single_bed,
    );
  }
}