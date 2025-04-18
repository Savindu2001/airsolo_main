import 'dart:convert';

enum RoomType {
  mixed_dormitory,
  shared_dormitory,
  womens_dormitory,
  mens_dormitory,
  deluxe_dormitory,
  private_room,
}

enum BedType {
  Double,
  Bunk_Bed,
  Single_Bed,
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
  final List<String>? images;
  final List<String>? facilityIds;
  final DateTime createdAt;
  final DateTime updatedAt;

  Room({
    required this.id,
    required this.hostelId,
    required this.name,
    required this.type,
    required this.bedType,
    required this.bedQty,
    required this.maxOccupancy,
    required this.pricePerPerson,
    this.images,
    this.facilityIds,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id']?.toString() ?? '',
      hostelId: json['hostel_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      type: _parseRoomType(json['type']),
      bedType: _parseBedType(json['bed_type']),
      bedQty: json['bed_qty'] as int? ?? 0,
      maxOccupancy: json['max_occupancy'] as int? ?? 1,
      pricePerPerson: _parseDouble(json['price_per_person']) ?? 0.0,
      images: _parseStringList(json['images']),
      facilityIds: _parseStringList(json['facility_ids']),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  static RoomType _parseRoomType(String? type) {
    if (type == null) return RoomType.mixed_dormitory;
    return RoomType.values.firstWhere(
      (e) => e.toString().split('.').last == type,
      orElse: () => RoomType.mixed_dormitory,
    );
  }

  static BedType _parseBedType(String? type) {
    if (type == null) return BedType.Single_Bed;
    return BedType.values.firstWhere(
      (e) => e.toString().split('.').last == type,
      orElse: () => BedType.Single_Bed,
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static List<String>? _parseStringList(dynamic data) {
    if (data == null) return null;
    
    if (data is String) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is List) {
          return List<String>.from(decoded.map((x) => x.toString()));
        }
        return [data];
      } catch (e) {
        return [data];
      }
    }
    
    if (data is List) {
      return List<String>.from(data.map((x) => x.toString()));
    }
    
    return null;
  }

  static DateTime _parseDateTime(dynamic dateTimeData) {
    if (dateTimeData == null) return DateTime.now();
    
    if (dateTimeData is DateTime) {
      return dateTimeData;
    }
    
    if (dateTimeData is String) {
      try {
        return DateTime.parse(dateTimeData);
      } catch (e) {
        return DateTime.now();
      }
    }
    
    if (dateTimeData is int) {
      return DateTime.fromMillisecondsSinceEpoch(dateTimeData);
    }
    
    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hostel_id': hostelId,
      'name': name,
      'type': type.toString().split('.').last,
      'bed_type': bedType.toString().split('.').last,
      'bed_qty': bedQty,
      'max_occupancy': maxOccupancy,
      'price_per_person': pricePerPerson,
      'images': images,
      'facility_ids': facilityIds,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}