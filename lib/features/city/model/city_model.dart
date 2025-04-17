class City {
  final int id;
  final String name;
  final String description;
  final String? imageUrl;
  final List<String> images;
  final DateTime createdAt;
  final DateTime updatedAt;

  City({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    this.images = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: _parseInt(json['id']),
      name: json['name'],
      description: json['description'],
      images: _parseImages(json['images']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  static List<String> _parseImages(dynamic imagesJson) {
    if (imagesJson == null) return [];
    if (imagesJson is List) {
      return List<String>.from(imagesJson);
    }
    if (imagesJson is String) {
      return [imagesJson];
    }
    return [];
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}



// Add these to your City model if needed
// final double? rating;
// final double? distanceFromUser; // in km
// final bool? isFeatured;