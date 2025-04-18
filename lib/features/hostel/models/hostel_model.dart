import 'dart:convert';

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
  final List<String>? gallery;
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
    this.gallery,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Hostel.fromJson(Map<String, dynamic> json) {
    return Hostel(
      id: json['id']?.toString() ?? '',
      hotelierId: json['hotelier_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      address: json['address']?.toString(),
      cityId: json['cityId']?.toString() ?? '',
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
      country: json['country']?.toString(),
      contactNumber: json['contact_number']?.toString(),
      email: json['email']?.toString() ?? '',
      website: json['website']?.toString(),
      rating: _parseDouble(json['rating']),
      gallery: _parseStringList(json['gallery']),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  get rooms => null;

  get facilityIds => null;

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
      'hotelier_id': hotelierId,
      'name': name,
      'description': description,
      'address': address,
      'cityId': cityId,
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'contact_number': contactNumber,
      'email': email,
      'website': website,
      'rating': rating,
      'gallery': gallery,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Hostel(id: $id, name: $name, cityId: $cityId)';
  }
}