class MenstrualCycleModel {
  final String userId; // foreign key to users table
  final DateTime startDate; // start_date (date)
  final DateTime? endDate; // end_date (date), can be null
  final int? periodLength; // period_length (integer), can be null

  const MenstrualCycleModel({
    required this.userId,
    required this.startDate,
    this.endDate,
    this.periodLength,
  });

  // Convert model to JSON (keys follow table columns)
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'start_date': startDate.toIso8601String(), // acceptable for DATE
      'end_date': endDate?.toIso8601String(), // acceptable for DATE
      'period_length': periodLength,
    };
  }

  // Create model from JSON
  factory MenstrualCycleModel.fromJson(Map<String, dynamic> json) {
    return MenstrualCycleModel(
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
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
    int? periodLength,
  }) {
    return MenstrualCycleModel(
      userId: userId ?? this.userId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      periodLength: periodLength ?? this.periodLength,
    );
  }
}
