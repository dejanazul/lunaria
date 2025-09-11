class MenstrualCycleModel {
  final String? id; // maps to cycle_id (uuid)
  final String userId; // foreign key to users table
  final DateTime startDate; // start_date (date)
  final DateTime? endDate; // end_date (date), can be null
  final int? periodLength; // period_length (integer), can be null

  const MenstrualCycleModel({
    this.id,
    required this.userId,
    required this.startDate,
    this.endDate,
    this.periodLength,
  });

  // Convert model to JSON (keys follow table columns)
  Map<String, dynamic> toJson() {
    return {
      'cycle_id': id,
      'user_id': userId,
      'start_date': startDate.toIso8601String(), // acceptable for DATE
      'end_date': endDate?.toIso8601String(), // acceptable for DATE
      'period_length': periodLength,
    };
  }

  // Create model from JSON
  factory MenstrualCycleModel.fromJson(Map<String, dynamic> json) {
    return MenstrualCycleModel(
      id: json['cycle_id']?.toString(),
      userId: json['user_id']?.toString() ?? '',
      startDate:
          json['start_date'] != null
              ? DateTime.parse(json['start_date'].toString())
              : DateTime.now(),
      endDate:
          json['end_date'] != null && json['end_date'].toString().isNotEmpty
              ? DateTime.parse(json['end_date'].toString())
              : null,
      periodLength:
          json['period_length'] != null
              ? int.tryParse(json['period_length'].toString())
              : null,
    );
  }

  // Create a copy with updated fields
  MenstrualCycleModel copyWith({
    String? id,
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
    int? periodLength,
  }) {
    return MenstrualCycleModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      periodLength: periodLength ?? this.periodLength,
    );
  }
}
