class Information {
  final String id;
  final String name;
  final String? description;
  final String infoType;
  final String cityId;
  final String contact1;
  final String? contact2;
  final DateTime createdAt;
  final DateTime updatedAt;

  Information({
    required this.id,
    required this.name,
    this.description,
    required this.infoType,
    required this.cityId,
    required this.contact1,
    this.contact2,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Information.fromJson(Map<String, dynamic> json) {
    return Information(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      infoType: json['info_type'],
      cityId: json['cityId'],
      contact1: json['contact_1'],
      contact2: json['contact_2'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'info_type': infoType,
        'cityId': cityId,
        'contact_1': contact1,
        'contact_2': contact2,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}