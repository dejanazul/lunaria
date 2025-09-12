class UserModel {
  final String? id; // maps to user_id (uuid)
  final String username; // not null
  final String email; // not null
  final String? passwordHash; // sensitive; optional in client models
  final String? name;
  final DateTime? birthDate; // date
  final int cookieBalance; // default 0
  final List<String>? preferredActivities; // text[]
  final String? lifestyle; // lifestyle information
  final double? bmi; // calculated body mass index
  final int level; // Tambahkan ini
  final int exp; // Tambahkan ini

  const UserModel({
    this.id,
    required this.username,
    required this.email,
    this.passwordHash,
    this.name,
    this.birthDate,
    this.cookieBalance = 0,
    this.preferredActivities,
    this.lifestyle,
    this.bmi,
    this.level = 1, // Default level 1
    this.exp = 0, // Default XP 0
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
      'preferred_activities': preferredActivities,
      'lifestyle': lifestyle,
      'bmi': bmi,
      'level': level,
      'xp': exp,
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
      preferredActivities:
          (json['preferred_activities'] as List?)
              ?.map((e) => e.toString())
              .toList(),
      lifestyle: json['lifestyle']?.toString(),
      bmi: json['bmi'] != null ? double.tryParse(json['bmi'].toString()) : null,
      level:
          json['level'] != null
              ? int.tryParse(json['level'].toString()) ?? 0
              : 0,
      exp: json['exp'] ?? 0,
      
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
    List<String>? preferredActivities,
    String? lifestyle,
    double? bmi,
    int? level,
    int? exp,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      cookieBalance: cookieBalance ?? this.cookieBalance,
      preferredActivities: preferredActivities ?? this.preferredActivities,
      lifestyle: lifestyle ?? this.lifestyle,
      bmi: bmi ?? this.bmi,
      level: level ?? this.level,
      exp: exp ?? this.exp,
    );
  }
}
