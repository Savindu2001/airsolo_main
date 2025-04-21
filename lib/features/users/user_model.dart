enum UserRole {
  traveler,
  hotelier,
  driver,
  admin,
  staff,
}

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String country;
  final String username;
  final UserRole role;
  final String? profilePhoto;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.country,
    required this.username,
    required this.role,
    this.profilePhoto,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      country: json['country'] ?? '',
      username: json['username'] ?? '',
      role: _parseRole(json['role']),
      profilePhoto: json['profile_photo'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toString()),
    );
  }

  static UserRole _parseRole(String? role) {
    if (role == null) return UserRole.traveler;
    return UserRole.values.firstWhere(
      (e) => e.toString().split('.').last == role,
      orElse: () => UserRole.traveler,
    );
  }

  String get fullName => '$firstName $lastName';
}