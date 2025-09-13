class UserSignupModel {
  final String username;
  final String email;
  final String passwordHash;
  final String? name;
  final DateTime? birthDate; // date
  final List<String>? preferredActivities; // text[]
  final String? lifestyle; // lifestyle information
  final double? bmi; // calculated body mass index
  final double? height; // in cm
  final double? weight; // in kg

  const UserSignupModel({
    required this.username,
    required this.email,
    required this.passwordHash,
    this.name,
    this.birthDate,
    this.preferredActivities,
    this.lifestyle,
    this.bmi,
    this.height,
    this.weight,
  });

  // Convert model to JSON (keys follow table columns)
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password_hash': passwordHash,
      'name': name,
      'birth_date': birthDate?.toIso8601String(), // acceptable for DATE
      'preferred_activities': preferredActivities,
      'lifestyle': lifestyle,
      'bmi': bmi,
      'height': height,
      'weight': weight,
    };
  }

  // Create model from JSON
  factory UserSignupModel.fromJson(Map<String, dynamic> json) {
    return UserSignupModel(
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      passwordHash: json['password_hash']!.toString(),
      name: json['name']?.toString(),
      birthDate:
          json['birth_date'] != null && json['birth_date'].toString().isNotEmpty
              ? DateTime.parse(json['birth_date'].toString())
              : null,
      preferredActivities:
          (json['preferred_activities'] as List?)
              ?.map((e) => e.toString())
              .toList(),
      lifestyle: json['lifestyle']?.toString(),
      bmi: json['bmi'] != null ? double.tryParse(json['bmi'].toString()) : null,
      height:
          json['height'] != null
              ? double.tryParse(json['height'].toString())
              : null,
      weight:
          json['weight'] != null
              ? double.tryParse(json['weight'].toString())
              : null,
    );
  }

  // Create a copy with updated fields
  UserSignupModel copyWith({
    String? username,
    String? email,
    String? passwordHash,
    String? name,
    DateTime? birthDate,
    List<String>? preferredActivities,
    String? lifestyle,
    double? bmi,
    double? height,
    double? weight,
  }) {
    return UserSignupModel(
      username: username ?? this.username,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      preferredActivities: preferredActivities ?? this.preferredActivities,
      lifestyle: lifestyle ?? this.lifestyle,
      bmi: bmi ?? this.bmi,
      height: height ?? this.height,
      weight: weight ?? this.weight,
    );
  }
}
