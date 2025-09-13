import 'dart:convert';

class PeriodPhase {
  final String phaseName; // menstruasi, folikular, ovulasi, luteal
  final DateTime startDate; // YYYY-MM-DD
  final DateTime endDate; // YYYY-MM-DD

  const PeriodPhase({
    required this.phaseName,
    required this.startDate,
    required this.endDate,
  });

  factory PeriodPhase.fromMap(Map<String, dynamic> map) {
    // Ambil string tanggal dan parse ISO-8601 (subset) ke DateTime
    final start = _parseYmd(map['start_date'] as String?);
    final end = _parseYmd(map['end_date'] as String?);

    final name = (map['phase_name'] as String?)?.trim();
    if (name == null || name.isEmpty) {
      throw const FormatException(
        'phase_name wajib ada dan tidak boleh kosong',
      );
    }

    if (end.isBefore(start)) {
      throw const FormatException(
        'end_date fase tidak boleh sebelum start_date',
      );
    }

    return PeriodPhase(phaseName: name, startDate: start, endDate: end);
  }

  Map<String, dynamic> toMap() {
    return {
      'phase_name': phaseName,
      'start_date': _formatYmd(startDate),
      'end_date': _formatYmd(endDate),
    };
  }
}

class MenstrualAnalysis {
  final DateTime endDate; // YYYY-MM-DD
  final int averageCycleLength;
  final int averagePeriodLength;
  final DateTime nextPeriodStart; // YYYY-MM-DD
  final List<PeriodPhase> periodPhase;

  const MenstrualAnalysis({
    required this.endDate,
    required this.averageCycleLength,
    required this.averagePeriodLength,
    required this.nextPeriodStart,
    required this.periodPhase,
  });

  /// Parse dari Map<String, dynamic>
  factory MenstrualAnalysis.fromMap(Map<String, dynamic> map) {
    final endDate = _parseYmd(map['end_date'] as String?);
    final nextStart = _parseYmd(map['next_period_start'] as String?);

    final avgCycle = _parsePositiveInt(
      map['average_cycle_length'],
      'average_cycle_length',
    );
    final avgPeriod = _parsePositiveInt(
      map['average_period_length'],
      'average_period_length',
    );

    final phasesRaw = map['period_phase'];
    if (phasesRaw is! List) {
      throw const FormatException('period_phase wajib berupa List');
    }

    final phases = phasesRaw
        .map((e) {
          if (e is! Map<String, dynamic>) {
            throw const FormatException(
              'Setiap item period_phase wajib berupa objek',
            );
          }
          return PeriodPhase.fromMap(e);
        })
        .toList(growable: false);

    final analysis = MenstrualAnalysis(
      endDate: endDate,
      averageCycleLength: avgCycle,
      averagePeriodLength: avgPeriod,
      nextPeriodStart: nextStart,
      periodPhase: phases,
    );

    // Validasi struktur dan aturan bisnis minimum
    analysis.validate();

    return analysis;
  }

  /// Parse langsung dari string JSON
  factory MenstrualAnalysis.fromJsonString(String jsonString) {
    final decoded = jsonDecode(jsonString);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Root JSON wajib berupa objek');
    }
    return MenstrualAnalysis.fromMap(decoded);
  }

  /// Serialize ke Map (untuk jsonEncode)
  Map<String, dynamic> toMap() {
    return {
      'end_date': _formatYmd(endDate),
      'average_cycle_length': averageCycleLength,
      'average_period_length': averagePeriodLength,
      'next_period_start': _formatYmd(nextPeriodStart),
      'period_phase': periodPhase.map((p) => p.toMap()).toList(growable: false),
    };
  }

  /// Serialize ke string JSON
  String toJsonString() => jsonEncode(toMap());

  /// Validasi aturan:
  /// - Semua tanggal format YYYY-MM-DD (dijamin oleh _parseYmd)
  /// - average_cycle_length & average_period_length > 0
  /// - period_phase berisi tepat 4 fase dan urut: menstruasi, folikular, ovulasi, luteal
  /// - Tanggal tiap fase berurutan tak tumpang tindih (opsional minimal: tidak mundur)
  void validate() {
    if (averageCycleLength <= 0) {
      throw const FormatException('average_cycle_length harus > 0');
    }
    if (averagePeriodLength <= 0) {
      throw const FormatException('average_period_length harus > 0');
    }

    const requiredOrder = ['menstruasi', 'folikular', 'ovulasi', 'luteal'];
    if (periodPhase.length != requiredOrder.length) {
      throw const FormatException(
        'period_phase harus memuat 4 fase: menstruasi, folikular, ovulasi, luteal',
      );
    }

    for (var i = 0; i < requiredOrder.length; i++) {
      final expected = requiredOrder[i];
      final actual = periodPhase[i].phaseName.toLowerCase();
      if (actual != expected) {
        throw FormatException(
          'Urutan fase tidak sesuai, index $i harus "$expected" tetapi ditemukan "$actual"',
        );
      }
    }

    // Cek kronologi fase tidak mundur
    for (var i = 1; i < periodPhase.length; i++) {
      final prev = periodPhase[i - 1];
      final curr = periodPhase[i];
      if (curr.startDate.isBefore(prev.startDate)) {
        throw const FormatException('Tanggal fase tidak boleh mundur');
      }
    }
  }
}

/// Util: validasi & parse YYYY-MM-DD -> DateTime
DateTime _parseYmd(String? input) {
  if (input == null) throw const FormatException('Tanggal wajib ada');
  final re = RegExp(r'^\d{4}-\d{2}-\d{2}$');
  if (!re.hasMatch(input)) {
    throw FormatException(
      'Format tanggal tidak valid (harus YYYY-MM-DD): $input',
    );
  }
  // DateTime.parse menerima subset ISO-8601; "YYYY-MM-DD" valid
  return DateTime.parse(input);
}

/// Util: format DateTime -> YYYY-MM-DD (ambil bagian tanggal dari ISO 8601)
String _formatYmd(DateTime dt) {
  // toIso8601String menghasilkan "yyyy-MM-ddTHH:mm:ss.mmmuuu[Z?]"
  // Ambil bagian sebelum 'T' agar menjadi YYYY-MM-DD
  return dt.toIso8601String().split('T').first;
}

int _parsePositiveInt(Object? value, String field) {
  if (value is int) return value;
  if (value is String) {
    final parsed = int.tryParse(value);
    if (parsed != null) return parsed;
  }
  throw FormatException('$field wajib berupa integer');
}
