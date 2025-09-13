class UserModel {
  final String userId;
  final String? username;
  final String? passwordHash;
  final String? email;
  final String? name;
  final DateTime? birthDate; // date
  final int? cookieBalance;
  final List<String>? preferredActivities; // text[]
  final String? lifestyle;
  final double? bmi;
  final int? level;
  final int? exp;
  final double? height;
  final double? weight; 

  const UserModel({
    required this.userId,
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
    this.cookieBalance,
    this.level,
    this.exp,
  });

  // Convert model to JSON (keys follow table columns)
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
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
      'cookie_balance': cookieBalance,
      'level': level,
      'exp': exp,
    };
  }

  // Create model from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id']!.toString(),
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString(),
      birthDate:
          json['birth_date'] != null && json['birth_date'].toString().isNotEmpty
              ? DateTime.parse(json['birth_date'].toString())
              : null,
      cookieBalance:
          json['cookie_balance'] != null
              ? int.tryParse(json['cookie_balance'].toString())
              : null,
      preferredActivities:
          (json['preferred_activities'] as List?)
              ?.map((e) => e.toString())
              .toList(),
      lifestyle: json['lifestyle']?.toString(),
      bmi: json['bmi'] != null ? double.tryParse(json['bmi'].toString()) : null,
      level:
          json['level'] != null ? int.tryParse(json['level'].toString()) : null,
      exp: json['exp'] != null ? int.tryParse(json['exp'].toString()) : null,
      height:
          json['height'] != null
              ? double.tryParse(json['height'].toString())
              : null,
      weight:
          json['weight'] != null
              ? double.tryParse(json['weight'].toString())
              : null,
      passwordHash: json['password_hash']?.toString() ?? '',
    );
  }

  // Create a copy with updated fields
  UserModel copyWith({
    String? userId,
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
    double? height,
    double? weight,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
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
      height: height ?? this.height,
      weight: weight ?? this.weight,
    );
  }
}
