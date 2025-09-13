import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lunaria/providers/calendar_ai_provider.dart';
import 'package:provider/provider.dart';
import 'rekomendasi_olahraga.dart';

class DetailCalendar extends StatefulWidget {
  const DetailCalendar({super.key});

  @override
  State<DetailCalendar> createState() => _DetailCalendarState();
}

class _DetailCalendarState extends State<DetailCalendar> {
  bool _isEditing = false;

  final Set<DateTime> _periodDays = {};

  // Map untuk menyimpan warna fase berdasarkan tanggal
  final Map<DateTime, Color> _phaseColorMap = {};
  // Map untuk menyimpan nama fase berdasarkan tanggal
  final Map<DateTime, String> _phaseNameMap = {};

  late DateTime today;
  late int selectedMonth;
  late int selectedYear;

  final List<int> years = List.generate(10, (i) => 2020 + i);

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    selectedMonth = today.month;
    selectedYear = today.year;

    // Update fase setelah widget dibangun
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updatePhaseMaps();
    });
  }

  // Metode untuk memperbarui peta fase berdasarkan data dari provider
  void _updatePhaseMaps() {
    final calendarAiProvider = Provider.of<CalendarAiProvider>(
      context,
      listen: false,
    );
    if (calendarAiProvider.currentAnalysis != null) {
      final phases = calendarAiProvider.currentAnalysis!.periodPhase;
      _phaseColorMap.clear();
      _phaseNameMap.clear();

      for (final phase in phases) {
        final start = phase.startDate;
        final end = phase.endDate;
        final color = _getPhaseColor(phase.phaseName);

        // Isi semua tanggal dalam rentang dengan warna dan nama fase
        for (var i = 0; i <= end.difference(start).inDays; i++) {
          final date = DateTime(start.year, start.month, start.day + i);
          _phaseColorMap[date] = color;
          _phaseNameMap[date] = phase.phaseName;
        }
      }

      setState(() {});
    }
  }

  // Mendapatkan warna sesuai fase
  Color _getPhaseColor(String phaseName) {
    switch (phaseName.toLowerCase()) {
      case 'menstruasi':
        return const Color.fromARGB(255, 247, 16, 0);
      case 'folikular':
        return Colors.purple.shade200; // ungu muda
      case 'ovulasi':
        return Colors.purple.shade800; // ungu tua
      case 'luteal':
        return Colors.grey.shade400; // abu-abu
      default:
        return Colors.grey.shade300;
    }
  }

  // Method to get current phase symptoms based on today's date
  List<String> _getCurrentPhaseSymptoms() {
    final today = DateTime.now();
    final phaseName = _phaseNameMap[today] ?? '';

    // Return common symptoms based on phase
    switch (phaseName.toLowerCase()) {
      case 'menstruasi':
        return ['Cramps', 'Backache', 'Abdominal Pain'];
      case 'folikular':
        return ['Energy fluctuations', 'Mood swings'];
      case 'ovulasi':
        return ['Mild pain', 'Tender breasts', 'Bloating'];
      case 'luteal':
        return ['Fatigue', 'Bloating', 'Headache', 'Mood changes'];
      default:
        return ['General discomfort'];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dengarkan perubahan pada provider untuk update warna fase
    final calendarAiProvider = Provider.of<CalendarAiProvider>(context);
    if (calendarAiProvider.currentAnalysis != null) {
      // Update fase ketika analisis berubah
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updatePhaseMaps();
      });
    }

    final daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
    final days = List.generate(
      daysInMonth,
      (i) => DateTime(selectedYear, selectedMonth, i + 1),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Calendar",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.fitness_center, color: Colors.purple),
            tooltip: 'Exercise Recommendations',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => RekomendasiOlahragaScreen(
                        symptoms: _getCurrentPhaseSymptoms(),
                      ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Pilihan bulan & tahun
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    value: selectedMonth,
                    items: List.generate(12, (i) {
                      final monthName = DateFormat.MMMM().format(
                        DateTime(0, i + 1),
                      );
                      return DropdownMenuItem(
                        value: i + 1,
                        child: Text(monthName),
                      );
                    }),
                    onChanged: (val) {
                      setState(() {
                        selectedMonth = val!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdown(
                    value: selectedYear,
                    items:
                        years.map((year) {
                          return DropdownMenuItem(
                            value: year,
                            child: Text("$year"),
                          );
                        }).toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedYear = val!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // Nama hari
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (i) {
                final weekday = DateFormat.E().format(DateTime(2023, 1, i + 2));
                return Expanded(
                  child: Center(
                    child: Text(
                      weekday.substring(0, 2),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          // Kalender grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14.0,
                vertical: 8.0,
              ),
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 4,
                ),
                itemCount: days.length,
                itemBuilder: (context, index) {
                  final day = days[index];
                  final isPeriodDay = _periodDays.any(
                    (d) =>
                        d.year == day.year &&
                        d.month == day.month &&
                        d.day == day.day,
                  );
                  final isToday =
                      day.year == today.year &&
                      day.month == today.month &&
                      day.day == today.day;

                  // Cek apakah tanggal memiliki fase
                  final normalizedDate = DateTime(day.year, day.month, day.day);
                  final phaseColor = _phaseColorMap[normalizedDate];
                  final phaseName = _phaseNameMap[normalizedDate];

                  return GestureDetector(
                    onTap: () {
                      if (_isEditing) {
                        setState(() {
                          if (isPeriodDay) {
                            _periodDays.removeWhere(
                              (d) =>
                                  d.year == day.year &&
                                  d.month == day.month &&
                                  d.day == day.day,
                            );
                          } else {
                            _periodDays.add(day);
                          }
                        });
                      } else if (phaseName != null) {
                        // Tampilkan info fase saat diklik
                        _showPhaseInfo(context, phaseName, normalizedDate);
                      }
                    },
                    child: Center(
                      // ⬅️ biar lingkaran fix ukurannya
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                        alignment: Alignment.center,
                        width: 33, // ⬅️ ukuran lingkaran fix
                        height: 33, // ⬅️ ukuran lingkaran fix
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              phaseColor != null
                                  ? phaseColor.withOpacity(0.8)
                                  : (isPeriodDay
                                      ? Colors.pink.shade400
                                      : (isToday
                                          ? Colors.blue.shade400.withOpacity(
                                            0.85,
                                          )
                                          : Colors.transparent)),
                          border: Border.all(
                            color:
                                phaseColor ??
                                (isPeriodDay
                                    ? Colors.pink.shade300
                                    : (isToday
                                        ? Colors.blue.shade300
                                        : Colors.grey.shade300)),
                            width: phaseColor != null || isToday ? 1.5 : 1,
                          ),
                        ),
                        child: Text(
                          "${day.day}",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight:
                                isPeriodDay || isToday || phaseColor != null
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                            color:
                                (phaseColor != null &&
                                            phaseColor.computeLuminance() <
                                                0.5) ||
                                        isPeriodDay ||
                                        isToday
                                    ? Colors.white
                                    : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Tombol bawah (floating style)
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child:
                !_isEditing
                    ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink.shade400,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        setState(() {
                          _isEditing = true;
                        });
                      },
                      child: const Text(
                        "Edit period dates",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    )
                    : Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.pink.shade400,
                              side: BorderSide(
                                color: Colors.pink.shade400,
                                width: 1.5,
                              ),
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _isEditing = false;
                              });
                            },
                            child: const Text(
                              "Cancel",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink.shade400,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              setState(() {
                                _isEditing = false;
                              });
                            },
                            child: const Text(
                              "Save",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }

  // Metode untuk menampilkan informasi fase dalam dialog
  void _showPhaseInfo(BuildContext context, String phaseName, DateTime date) {
    final calendarAiProvider = Provider.of<CalendarAiProvider>(
      context,
      listen: false,
    );
    final description = calendarAiProvider.getPhaseDescription(phaseName);
    final tips = calendarAiProvider.getPhaseTips(phaseName);
    final phaseColor = _getPhaseColor(phaseName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: phaseColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Fase ${phaseName.substring(0, 1).toUpperCase()}${phaseName.substring(1)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${DateFormat('d MMMM yyyy').format(date)}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(description),
                const SizedBox(height: 16),
                const Text(
                  'Tips:',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...tips.map(
                  (tip) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(fontSize: 15)),
                        Expanded(child: Text(tip)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          items: items,
          onChanged: onChanged,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
        ),
      ),
    );
  }
}
