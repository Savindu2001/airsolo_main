import 'package:flutter/material.dart';

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
      id: json['id'] ?? '',
      icon: _parseIcon(json['icon']),
      name: json['name'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toString()),
    );
  }

  static IconData? _parseIcon(String? iconName) {
    if (iconName == null) return null;
    switch (iconName.toLowerCase()) {
      case 'wifi': return Icons.wifi;
      case 'pool': return Icons.pool;
      case 'restaurant': return Icons.restaurant;
      case 'ac': return Icons.ac_unit;
      case 'parking': return Icons.local_parking;
      default: return Icons.help_outline;
    }
  }
}