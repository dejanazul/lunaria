class UserModel {
  final String? id; // maps to user_id (uuid)
  final String username; // not null
  final String email; // not null
  final String? passwordHash; // sensitive; optional in client models
  final String? name;
  final DateTime? birthDate; // date
  final int cookieBalance; // default 0
  // final DateTime? createdAt; // timestamptz
  final List<String>? preferredActivities; // text[]
  // final double? height; // height in cm
  // final double? weight; // weight in kg
  final String? lifestyle; // lifestyle information
  final double? bmi; // calculated body mass index
  // final String? fitnessLevel; // beginner, intermediate, advanced

  const UserModel({
    this.id,
    required this.username,
    required this.email,
    this.passwordHash,
    this.name,
    this.birthDate,
    this.cookieBalance = 0,
    // this.createdAt,
    this.preferredActivities,
    // this.height,
    // this.weight,
    this.lifestyle,
    this.bmi,
    // this.fitnessLevel,
  });

  // Convert model to JSON (keys follow table columns)
  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'username': username,
      'email': email,
      'password_hash': passwordHash,
      'name': name,
      'birth_date': birthDate?.toIso8601String(), // acceptable for DATE
      'cookie_balance': cookieBalance,
      // 'created_at': createdAt?.toUtc().toIso8601String(), // timestamptz in UTC
      'preferred_activities': preferredActivities,
      // 'height': height,
      // 'weight': weight,
      'lifestyle': lifestyle,
      'bmi': bmi,
      // 'fitness_level': fitnessLevel,
    };
  }

  // Create model from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user_id']?.toString(),
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      passwordHash: json['password_hash']?.toString(),
      name: json['name']?.toString(),
      birthDate:
          json['birth_date'] != null && json['birth_date'].toString().isNotEmpty
              ? DateTime.parse(json['birth_date'].toString())
              : null,
      cookieBalance:
          json['cookie_balance'] != null
              ? int.tryParse(json['cookie_balance'].toString()) ?? 0
              : 0,
      // createdAt:
      //     json['created_at'] != null && json['created_at'].toString().isNotEmpty
      //         ? DateTime.parse(json['created_at'].toString())
      //         : null,
      preferredActivities:
          (json['preferred_activities'] as List?)
              ?.map((e) => e.toString())
              .toList(),
      // height:
      //     json['height'] != null
      //         ? double.tryParse(json['height'].toString())
      //         : null,
      // weight:
      //     json['weight'] != null
      //         ? double.tryParse(json['weight'].toString())
      //         : null,
      lifestyle: json['lifestyle']?.toString(),
      bmi: json['bmi'] != null ? double.tryParse(json['bmi'].toString()) : null,
      // fitnessLevel: json['fitness_level']?.toString(),
    );
  }

  // Create a copy with updated fields
  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? passwordHash,
    String? name,
    DateTime? birthDate,
    int? cookieBalance,
    DateTime? createdAt,
    List<String>? preferredActivities,
    double? height,
    double? weight,
    String? lifestyle,
    double? bmi,
    String? fitnessLevel,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      cookieBalance: cookieBalance ?? this.cookieBalance,
      // createdAt: createdAt ?? this.createdAt,
      preferredActivities: preferredActivities ?? this.preferredActivities,
      // height: height ?? this.height,
      // weight: weight ?? this.weight,
      lifestyle: lifestyle ?? this.lifestyle,
      bmi: bmi ?? this.bmi,
      // fitnessLevel: fitnessLevel ?? this.fitnessLevel,
    );
  }
}
