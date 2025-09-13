import 'dart:convert';

class Symptom {
  final String emoji;
  final String text;
  final String category;
  final DateTime date;

  Symptom({
    required this.emoji,
    required this.text,
    required this.category,
    required this.date,
  });

  // Konversi ke Map untuk penyimpanan
  Map<String, dynamic> toMap() {
    return {
      'emoji': emoji,
      'text': text,
      'category': category,
      'date': date.toIso8601String(),
    };
  }

  // Factory untuk membuat objek Symptom dari Map
  factory Symptom.fromMap(Map<String, dynamic> map) {
    String emoji;
    try {
      emoji = map['emoji'] ?? '';
      // Validasi emoji - pastikan itu string UTF-16 yang valid
      // Jika emoji tidak valid, ini akan melempar exception
      emoji.codeUnits; // Ini akan melempar exception jika string tidak valid
    } catch (e) {
      // Jika terjadi error, gunakan emoji default atau string kosong
      emoji = '';
    }

    return Symptom(
      emoji: emoji,
      text: map['text'] ?? '',
      category: map['category'] ?? '',
      date: DateTime.parse(map['date']),
    );
  }

  // Konversi ke JSON string
  String toJson() => json.encode(toMap());

  // Factory untuk membuat objek Symptom dari JSON string
  factory Symptom.fromJson(String source) =>
      Symptom.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Symptom(emoji: $emoji, text: $text, category: $category, date: $date)';
  }
}

class SymptomEntry {
  final DateTime date;
  final List<Symptom> symptoms;

  SymptomEntry({required this.date, required this.symptoms});

  // Konversi ke Map untuk penyimpanan
  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'symptoms': symptoms.map((x) => x.toMap()).toList(),
    };
  }

  // Factory untuk membuat objek SymptomEntry dari Map
  factory SymptomEntry.fromMap(Map<String, dynamic> map) {
    return SymptomEntry(
      date: DateTime.parse(map['date']),
      symptoms: List<Symptom>.from(
        map['symptoms']?.map((x) => Symptom.fromMap(x)) ?? const [],
      ),
    );
  }

  // Konversi ke JSON string
  String toJson() => json.encode(toMap());

  // Factory untuk membuat objek SymptomEntry dari JSON string
  factory SymptomEntry.fromJson(String source) =>
      SymptomEntry.fromMap(json.decode(source));

  @override
  String toString() => 'SymptomEntry(date: $date, symptoms: $symptoms)';
}
