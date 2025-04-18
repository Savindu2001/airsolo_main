import 'dart:convert';

class City {
  final String id;
  final String name;
  final List<String> images;
  final String description;
  final double? longitude;
  final double? latitude;
  final List<String> thingsToDo;

  City({
    required this.id,
    required this.name,
    required this.images,
    required this.description,
    this.longitude,
    this.latitude,
    required this.thingsToDo,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      images: _parseImages(json['images']),
      longitude: _parseDouble(json['longitude']),
      latitude: _parseDouble(json['latitude']),
      thingsToDo: _parseThingsToDo(json['things_to_do']),
    );
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

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static List<String> _parseThingsToDo(dynamic thingsData) {
    if (thingsData == null) return [];
    
    if (thingsData is List) {
      return List<String>.from(thingsData.whereType<String>());
    }
    
    if (thingsData is String) {
      try {
        final decoded = jsonDecode(thingsData);
        if (decoded is List) {
          return List<String>.from(decoded.whereType<String>());
        }
        return [decoded.toString()];
      } catch (e) {
        return [thingsData];
      }
    }
    
    return [thingsData.toString()];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'images': images,
        'longitude': longitude,
        'latitude': latitude,
        'things_to_do': thingsToDo,
      };
}