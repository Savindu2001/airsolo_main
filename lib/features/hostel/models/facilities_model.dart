
import 'package:flutter/widgets.dart';

class Facility {
  final String id;
  final IconData? icon; 
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  Facility({
    required this.id,
    this.icon,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(
      id: json['id']?.toString() ?? '',
      icon: json['icon']?? '',
      name: json['name']?.toString() ?? '',
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
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
      'icon': icon,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Facility(id: $id, name: $name, icon: $icon)';
  }

  // Optional: You might want to add equality comparison
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Facility &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}