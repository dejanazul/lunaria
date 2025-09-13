import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lunaria/models/menstrual_analysis_model.dart';
import 'package:lunaria/models/symptom_model.dart';
import 'package:lunaria/services/calendar_ai_service.dart';
import 'package:lunaria/services/github_ai_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalendarAiProvider extends ChangeNotifier {
  final GitHubAIService _gitHubAIService = GitHubAIService();
  final CalendarAIService _calendarAIService = CalendarAIService();
  static const String _analysisKey = 'calendar_analysis_data';
  static const String _analysisCompletedKey = 'has_completed_analysis';
  static const String _symptomsKey = 'user_symptoms_data';

  MenstrualAnalysis? _currentAnalysis;
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasCompletedAnalysis =
      false; // State untuk melacak apakah pengguna sudah melakukan analisis

  // Menyimpan daftar gejala berdasarkan tanggal
  final Map<String, List<Symptom>> _userSymptoms = {};

  CalendarAiProvider() {
    // Load state dari SharedPreferences saat provider dibuat
    _loadState();
  }

  // Getters
  MenstrualAnalysis? get currentAnalysis => _currentAnalysis;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasCompletedAnalysis => _hasCompletedAnalysis;
  Map<String, List<Symptom>> get userSymptoms => _userSymptoms;

  /// Analisis siklus menstruasi menggunakan AI dan konversi ke model MenstrualAnalysis
  Future<MenstrualAnalysis?> analyzeMenstrualCycle(String userId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Ambil data siklus menstruasi pengguna
      final userData = await _calendarAIService.getUserMenstrualCycle(userId);
      if (userData == null) {
        _errorMessage = 'Data siklus menstruasi tidak ditemukan';
        _isLoading = false;
        notifyListeners();
        return null;
      }

      final userDataJson = json.encode(userData.toJson());
      debugPrint("User Data JSON: $userDataJson");

      // Buat prompt untuk AI
      String prompt = """
PERSONALITY:
Kamu adalah seorang asisten yang ahli dalam menganalisis data menstruasi dan kesehatan reproduksi wanita. 
CONTEXT:
Kamu akan diberikan data user dalam format JSON yang berisi informasi tentang siklus menstruasi pengguna yaitu start_date, dan period_length.
GOAL:
Berdasarkan data tersebut, hasilkan analisis dalam format json yang mencakup:
{
  "end_date": "YYYY-MM-DD",
  "average_cycle_length": int,
  "average_period_length": int,
  "next_period_start": "YYYY-MM-DD",
  "period_phase": [
    {
      "phase_name": "menstruasi",
      "start_date": "YYYY-MM-DD",
      "end_date": "YYYY-MM-DD"
    },
    {
      "phase_name": "folikular",
      "start_date": "YYYY-MM-DD",
      "end_date": "YYYY-MM-DD"
    },
    {
      "phase_name": "ovulasi",
      "start_date": "YYYY-MM-DD",
      "end_date": "YYYY-MM-DD"
    },
    {
      "phase_name": "luteal",
      "start_date": "YYYY-MM-DD",
      "end_date": "YYYY-MM-DD"
    }
  ]
}
ANALYSIS GUIDELINES:
1. Gunakan data start_date dan period_length untuk menghitung end_date.
2. Hitung average_cycle_length (panjang siklus). 
3. Tentukan next_period_start berdasarkan average_cycle_length.
4. Bagi siklus menstruasi menjadi 4 fase dengan detail sebagai berikut:
   - Menstruasi: Dimulai dari start_date dengan durasi sesuai period_length
   - Folikular: Dimulai setelah fase menstruasi berakhir dengan durasi sekitar 7-10 hari
   - Ovulasi: Berlangsung sekitar 3-5 hari di tengah siklus
   - Luteal: Fase akhir hingga menstruasi berikutnya, sekitar 10-14 hari
5. Pastikan semua tanggal dalam format "YYYY-MM-DD" dengan tanda kutip ganda.
6. Pastikan semua integer TIDAK menggunakan tanda kutip.

CONSTRAINTS:
1. Hanya gunakan data yang diberikan dalam JSON.
2. Jangan menambahkan informasi atau asumsi di luar data yang diberikan.
3. Pastikan output dalam format JSON yang valid, dengan semua key menggunakan tanda kutip ganda.
4. Pastikan terdapat 4 fase dalam period_phase dan selalu berurutan: menstruasi, folikular, ovulasi, luteal.
5. Jangan hasilkan teks lain selain JSON. Jangan sertakan penjelasan, markdown, atau tanda kutip tambahan.

INPUT:
User Data: 
$userDataJson
""";

      // Kirim prompt ke AI dan dapatkan analisis
      final analysisResponse = await _gitHubAIService.sendMessage(
        userMessage: prompt,
      );
      debugPrint("Raw AI Response: $analysisResponse");

      // Ekstrak JSON dari respons
      final jsonStr = _extractJsonFromResponse(analysisResponse);
      if (jsonStr == null) {
        _errorMessage = 'Format respons AI tidak valid';
        _isLoading = false;
        notifyListeners();
        return null;
      }

      // Konversi JSON ke objek MenstrualAnalysis
      try {
        final analysis = MenstrualAnalysis.fromJsonString(jsonStr);
        _currentAnalysis = analysis;
        _isLoading = false;
        _hasCompletedAnalysis = true; // Set true setelah analisis selesai
        notifyListeners();
        _saveState(); // Simpan state ke SharedPreferences
        return analysis;
      } catch (e) {
        debugPrint("Error parsing MenstrualAnalysis: $e");
        _errorMessage = 'Format data analisis tidak valid: ${e.toString()}';
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      debugPrint("Error in analyzeMenstrualCycle: $e");
      _errorMessage = 'Gagal menganalisis siklus: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Ekstrak string JSON dari respons AI yang mungkin berisi teks tambahan
  String? _extractJsonFromResponse(String response) {
    try {
      // Hapus karakter backtick jika ada
      var cleaned = response.replaceAll('```json', '').replaceAll('```', '');

      // Cobalah untuk menemukan JSON object dengan regex
      final jsonRegex = RegExp(r'(\{[\s\S]*\})');
      final match = jsonRegex.firstMatch(cleaned);

      if (match != null) {
        final jsonCandidate = match.group(1);

        // Validasi bahwa string adalah JSON yang valid
        if (jsonCandidate != null) {
          // Coba parse untuk validasi
          json.decode(jsonCandidate);
          return jsonCandidate;
        }
      }

      // Jika tidak berhasil dengan regex, coba parse langsung
      json.decode(cleaned);
      return cleaned;
    } catch (e) {
      debugPrint("Error extracting JSON: $e");
      return null;
    }
  }

  /// Mendapatkan warna untuk fase menstruasi
  Color getPhaseColor(String phaseName) {
    switch (phaseName.toLowerCase()) {
      case 'menstruasi':
        return Colors.red.shade300;
      case 'folikular':
        return Colors.blue.shade300;
      case 'ovulasi':
        return Colors.green.shade300;
      case 'luteal':
        return Colors.purple.shade300;
      default:
        return Colors.grey.shade300;
    }
  }

  /// Mendapatkan deskripsi singkat untuk setiap fase
  String getPhaseDescription(String phaseName) {
    switch (phaseName.toLowerCase()) {
      case 'menstruasi':
        return 'Fase menstruasi terjadi ketika lapisan rahim dikeluarkan.';
      case 'folikular':
        return 'Fase folikular adalah fase pertumbuhan folikel di ovarium.';
      case 'ovulasi':
        return 'Fase ovulasi terjadi ketika sel telur dilepaskan dari ovarium.';
      case 'luteal':
        return 'Fase luteal adalah fase setelah ovulasi dan sebelum menstruasi berikutnya.';
      default:
        return 'Deskripsi fase tidak tersedia.';
    }
  }

  /// Mendapatkan tips untuk setiap fase
  List<String> getPhaseTips(String phaseName) {
    switch (phaseName.toLowerCase()) {
      case 'menstruasi':
        return [
          'Istirahat yang cukup untuk mengurangi kelelahan',
          'Konsumsi makanan kaya zat besi',
          'Hindari kafein dan alkohol',
          'Lakukan peregangan ringan untuk meredakan kram',
        ];
      case 'folikular':
        return [];
      case 'ovulasi':
        return [];
      case 'luteal':
        return [];
      default:
        return ['Tips tidak tersedia untuk fase ini.'];
    }
  }

  /// Reset state analisis
  Future<void> resetAnalysisState() async {
    _currentAnalysis = null;
    _errorMessage = null;
    _hasCompletedAnalysis = false;
    notifyListeners();

    // Hapus data dari SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_analysisKey);
      await prefs.remove(_analysisCompletedKey);
    } catch (e) {
      debugPrint('Error clearing calendar analysis state: $e');
    }
  }

  /// Setel status analisis secara manual (berguna untuk debugging atau memuat dari cache)
  void setAnalysisState({MenstrualAnalysis? analysis, bool completed = false}) {
    _currentAnalysis = analysis;
    _hasCompletedAnalysis = completed;
    notifyListeners();
    _saveState();
  }

  /// Menyimpan state ke SharedPreferences
  Future<void> _saveState() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save analysis data
      if (_currentAnalysis != null) {
        await prefs.setString(_analysisKey, _currentAnalysis!.toJsonString());
      }

      // Save completed status
      await prefs.setBool(_analysisCompletedKey, _hasCompletedAnalysis);

      // Save symptoms data
      if (_userSymptoms.isNotEmpty) {
        // Convert symptoms map to storable format
        final Map<String, dynamic> symptomsMap = {};
        _userSymptoms.forEach((dateStr, symptoms) {
          symptomsMap[dateStr] = symptoms.map((s) => s.toMap()).toList();
        });
        await prefs.setString(_symptomsKey, json.encode(symptomsMap));
      }
    } catch (e) {
      debugPrint('Error saving calendar state: $e');
    }
  }

  /// Memuat state dari SharedPreferences
  Future<void> _loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load completed status
      _hasCompletedAnalysis = prefs.getBool(_analysisCompletedKey) ?? false;

      // Load analysis data jika ada
      final analysisJson = prefs.getString(_analysisKey);
      if (analysisJson != null && analysisJson.isNotEmpty) {
        try {
          _currentAnalysis = MenstrualAnalysis.fromJsonString(analysisJson);
        } catch (e) {
          debugPrint('Error parsing saved analysis: $e');
        }
      }

      // Load symptoms data jika ada
      final symptomsJson = prefs.getString(_symptomsKey);
      if (symptomsJson != null && symptomsJson.isNotEmpty) {
        try {
          final Map<String, dynamic> symptomsMap = json.decode(symptomsJson);
          _userSymptoms.clear();

          symptomsMap.forEach((dateStr, symptomsList) {
            try {
              final List<Symptom> symptoms = [];
              for (var symptomMap in (symptomsList as List)) {
                try {
                  final symptom = Symptom.fromMap(
                    symptomMap as Map<String, dynamic>,
                  );
                  symptoms.add(symptom);
                } catch (e) {
                  debugPrint('Error parsing individual symptom: $e');
                  // Lanjutkan ke gejala berikutnya jika satu gejala gagal diparsing
                }
              }
              if (symptoms.isNotEmpty) {
                _userSymptoms[dateStr] = symptoms;
              }
            } catch (e) {
              debugPrint('Error parsing symptoms for date $dateStr: $e');
              // Lanjutkan ke tanggal berikutnya jika satu tanggal gagal diparsing
            }
          });
        } catch (e) {
          debugPrint('Error parsing saved symptoms: $e');
        }
      }

      // Beritahu UI bahwa state telah diperbarui
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading calendar analysis state: $e');
    }
  }

  /// Tambahkan symptoms baru untuk tanggal tertentu
  void addSymptoms(List<Symptom> symptoms, {DateTime? date}) {
    if (symptoms.isEmpty) return;

    final targetDate = date ?? DateTime.now();
    final dateStr = _formatDateKey(targetDate);

    // Tambahkan symptoms baru atau update jika sudah ada untuk tanggal itu
    if (_userSymptoms.containsKey(dateStr)) {
      // Buat map untuk menyimpan gejala yang sudah ada (kunci = emoji+text)
      final Map<String, bool> existingSymptomMap = {};
      for (var symptom in _userSymptoms[dateStr]!) {
        existingSymptomMap['${symptom.emoji} ${symptom.text}'] = true;
      }

      // Tambahkan hanya gejala yang belum ada
      for (var symptom in symptoms) {
        final key = '${symptom.emoji} ${symptom.text}';
        if (existingSymptomMap[key] != true) {
          _userSymptoms[dateStr]!.add(symptom);
        }
      }
    } else {
      _userSymptoms[dateStr] = symptoms;
    }

    notifyListeners();
    _saveState();
  }

  /// Dapatkan symptoms untuk tanggal tertentu
  List<Symptom> getSymptomsForDate(DateTime date) {
    final dateStr = _formatDateKey(date);
    return _userSymptoms[dateStr] ?? [];
  }

  /// Dapatkan symptoms untuk tanggal saat ini
  List<Symptom> getTodaysSymptoms() {
    return getSymptomsForDate(DateTime.now());
  }

  /// Hapus semua symptoms untuk tanggal tertentu
  void clearSymptomsForDate(DateTime date) {
    final dateStr = _formatDateKey(date);
    _userSymptoms.remove(dateStr);
    notifyListeners();
    _saveState();
  }

  /// Format tanggal untuk digunakan sebagai key
  String _formatDateKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  /// Mendapatkan data riwayat siklus untuk tampilan CycleHistoryCard
  List<Map<String, dynamic>> getCycleHistory() {
    final List<Map<String, dynamic>> history = [];

    if (_currentAnalysis == null) {
      return [];
    }

    // Dapatkan tanggal saat ini
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    try {
      // Siklus saat ini
      final currentCycleStartDate =
          _currentAnalysis!.periodPhase.first.startDate;
      final daysSinceStart = today.difference(currentCycleStartDate).inDays;

      // Hanya tampilkan siklus saat ini jika sudah dimulai
      if (!today.isBefore(currentCycleStartDate)) {
        // Buat daftar warna untuk siklus saat ini
        final List<Color> currentCycleDays = [];

        // Isi warna untuk hari yang sudah lewat dan abu-abu untuk hari yang akan datang
        final totalCycleDays = _currentAnalysis!.averageCycleLength;

        // Tambahkan warna sesuai dengan fase untuk hari yang sudah lewat
        for (int i = 0; i < totalCycleDays; i++) {
          final day = currentCycleStartDate.add(Duration(days: i));

          if (day.isAfter(today)) {
            // Hari yang belum terjadi (abu-abu)
            currentCycleDays.add(Colors.grey.shade300);
          } else {
            // Cari fase untuk tanggal ini
            for (var phase in _currentAnalysis!.periodPhase) {
              final normalizedStartDate = DateTime(
                phase.startDate.year,
                phase.startDate.month,
                phase.startDate.day,
              );

              final normalizedEndDate = DateTime(
                phase.endDate.year,
                phase.endDate.month,
                phase.endDate.day,
              );

              final normalizedDay = DateTime(day.year, day.month, day.day);

              if ((normalizedDay.isAtSameMomentAs(normalizedStartDate) ||
                      normalizedDay.isAfter(normalizedStartDate)) &&
                  (normalizedDay.isAtSameMomentAs(normalizedEndDate) ||
                      normalizedDay.isBefore(normalizedEndDate))) {
                switch (phase.phaseName.toLowerCase()) {
                  case 'menstruasi':
                    currentCycleDays.add(const Color.fromARGB(255, 255, 17, 0));
                    break;
                  case 'folikular':
                    currentCycleDays.add(Colors.purple.shade200);
                    break;
                  case 'ovulasi':
                    currentCycleDays.add(Colors.purple.shade800);
                    break;
                  case 'luteal':
                    currentCycleDays.add(Colors.grey.shade400);
                    break;
                  default:
                    currentCycleDays.add(Colors.grey.shade300);
                }
                break;
              }
            }
          }
        }

        // Format tanggal untuk tampilan
        final startDateFormatted =
            '${_getMonthAbbreviation(currentCycleStartDate.month)} ${currentCycleStartDate.day}';

        // Tambahkan ke history
        history.add({
          'duration':
              'Current Cycle: ${daysSinceStart + 1} Day${daysSinceStart == 0 ? '' : 's'}',
          'dateRange': 'Started $startDateFormatted',
          'days': currentCycleDays,
        });
      }

      // Hitung siklus sebelumnya berdasarkan data yang ada
      if (_currentAnalysis!.averageCycleLength > 0) {
        // Siklus sebelumnya
        final prevCycleEndDate = currentCycleStartDate.subtract(
          const Duration(days: 1),
        );
        final prevCycleStartDate = prevCycleEndDate.subtract(
          Duration(days: _currentAnalysis!.averageCycleLength - 1),
        );

        // Format tanggal
        final prevStartFormatted =
            '${_getMonthAbbreviation(prevCycleStartDate.month)} ${prevCycleStartDate.day}';
        final prevEndFormatted =
            '${_getMonthAbbreviation(prevCycleEndDate.month)} ${prevCycleEndDate.day}';

        // Buat daftar warna berdasarkan rata-rata
        final List<Color> prevCycleDays = [];

        // Perkirakan distribusi fase pada siklus sebelumnya
        final menstruasiDays = _currentAnalysis!.averagePeriodLength;
        final folikularDays =
            (_currentAnalysis!.averageCycleLength * 0.25).round();
        final ovulasiDays = 1; // Biasanya hanya 1 hari
        final lutealDays =
            _currentAnalysis!.averageCycleLength -
            menstruasiDays -
            folikularDays -
            ovulasiDays;

        // Isi dengan warna sesuai fase
        prevCycleDays.addAll(
          List.filled(menstruasiDays, const Color.fromARGB(255, 255, 17, 0)),
        );
        prevCycleDays.addAll(
          List.filled(folikularDays, Colors.purple.shade200),
        );
        prevCycleDays.add(Colors.purple.shade800); // Ovulasi
        prevCycleDays.addAll(List.filled(lutealDays, Colors.grey.shade400));

        // Tambahkan ke history
        history.add({
          'duration': '${_currentAnalysis!.averageCycleLength} Days',
          'dateRange': '$prevStartFormatted - $prevEndFormatted',
          'days': prevCycleDays,
        });

        // Siklus sebelum sebelumnya (2 siklus sebelumnya)
        final prev2CycleEndDate = prevCycleStartDate.subtract(
          const Duration(days: 1),
        );
        final prev2CycleStartDate = prev2CycleEndDate.subtract(
          Duration(days: _currentAnalysis!.averageCycleLength - 1),
        );

        // Format tanggal
        final prev2StartFormatted =
            '${_getMonthAbbreviation(prev2CycleStartDate.month)} ${prev2CycleStartDate.day}';
        final prev2EndFormatted =
            '${_getMonthAbbreviation(prev2CycleEndDate.month)} ${prev2CycleEndDate.day}';

        // Buat daftar warna yang serupa dengan siklus sebelumnya (dengan sedikit variasi)
        final List<Color> prev2CycleDays = [];

        // Sedikit variasi pada periode sebelumnya (menggunakan variasi statis)
        final variationMenstruasiDays = menstruasiDays - 1;
        final variationFolikularDays = folikularDays - 1;
        final variationLutealDays =
            _currentAnalysis!.averageCycleLength -
            variationMenstruasiDays -
            variationFolikularDays -
            ovulasiDays;

        // Isi dengan warna sesuai fase
        prev2CycleDays.addAll(
          List.filled(
            variationMenstruasiDays.toInt(),
            const Color.fromARGB(255, 255, 17, 0),
          ),
        );
        prev2CycleDays.addAll(
          List.filled(variationFolikularDays.toInt(), Colors.purple.shade200),
        );
        prev2CycleDays.add(Colors.purple.shade800); // Ovulasi
        prev2CycleDays.addAll(
          List.filled(variationLutealDays, Colors.grey.shade400),
        );

        // Tambahkan ke history
        history.add({
          'duration': '${_currentAnalysis!.averageCycleLength} Days',
          'dateRange': '$prev2StartFormatted - $prev2EndFormatted',
          'days': prev2CycleDays,
        });
      }
    } catch (e) {
      debugPrint('Error getting cycle history: $e');
    }

    return history;
  }

  /// Mendapatkan singkatan nama bulan
  String _getMonthAbbreviation(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  /// Mendapatkan fase saat ini dan hari ke berapa di fase tersebut
  Map<String, dynamic> getCurrentPhaseInfo({DateTime? date}) {
    final targetDate = date ?? DateTime.now();

    // Hilangkan waktu dari targetDate agar hanya membandingkan tanggal
    final targetDateOnly = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
    );

    if (_currentAnalysis == null) {
      return {'phaseName': 'Unknown', 'phaseDay': 0};
    }

    // Periksa dalam fase mana tanggal saat ini berada
    String phaseName = 'Unknown';
    int phaseDay = 0;

    try {
      for (var phase in _currentAnalysis!.periodPhase) {
        // Normalkan waktu dari tanggal fase agar hanya membandingkan tanggal
        final phaseStartDate = phase.startDate;
        final phaseEndDate = phase.endDate;

        // Hilangkan waktu dari tanggal fase
        final phaseStartDateOnly = DateTime(
          phaseStartDate.year,
          phaseStartDate.month,
          phaseStartDate.day,
        );
        final phaseEndDateOnly = DateTime(
          phaseEndDate.year,
          phaseEndDate.month,
          phaseEndDate.day,
        );

        // Cek apakah targetDate berada dalam rentang fase ini
        // termasuk tanggal awal dan akhir fase
        if (targetDateOnly.isAtSameMomentAs(phaseStartDateOnly) ||
            targetDateOnly.isAtSameMomentAs(phaseEndDateOnly) ||
            (targetDateOnly.isAfter(phaseStartDateOnly) &&
                targetDateOnly.isBefore(phaseEndDateOnly))) {
          phaseName = phase.phaseName;

          // Hitung hari keberapa dalam fase ini
          phaseDay = targetDateOnly.difference(phaseStartDateOnly).inDays + 1;
          break;
        }
      }
    } catch (e) {
      debugPrint('Error menghitung fase saat ini: $e');
    }

    return {'phaseName': phaseName, 'phaseDay': phaseDay};
  }
}
