import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailCalendar extends StatefulWidget {
  const DetailCalendar({super.key});

  @override
  State<DetailCalendar> createState() => _DetailCalendarState();
}

class _DetailCalendarState extends State<DetailCalendar> {
  bool _isEditing = false;

  Set<DateTime> _periodDays = {
    DateTime.utc(2025, 9, 2),
    DateTime.utc(2025, 9, 3),
    DateTime.utc(2025, 9, 4),
  };

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
  }

  @override
  Widget build(BuildContext context) {
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
                      final monthName =
                          DateFormat.MMMM().format(DateTime(0, i + 1));
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
                    items: years.map((year) {
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
                final weekday =
                    DateFormat.E().format(DateTime(2023, 1, i + 2));
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
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
                  final isPeriodDay = _periodDays.any((d) =>
                      d.year == day.year &&
                      d.month == day.month &&
                      d.day == day.day);
                  final isToday = day.year == today.year &&
                      day.month == today.month &&
                      day.day == today.day;

                  return GestureDetector(
                    onTap: () {
                      if (_isEditing) {
                        setState(() {
                          if (isPeriodDay) {
                            _periodDays.removeWhere((d) =>
                                d.year == day.year &&
                                d.month == day.month &&
                                d.day == day.day);
                          } else {
                            _periodDays.add(day);
                          }
                        });
                      }
                    },
                    child: Center( // ⬅️ biar lingkaran fix ukurannya
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                        alignment: Alignment.center,
                        width: 33,   // ⬅️ ukuran lingkaran fix
                        height: 33,  // ⬅️ ukuran lingkaran fix
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isPeriodDay
                              ? Colors.pink.shade400
                              : (isToday
                                  ? Colors.blue.shade400.withOpacity(0.85)
                                  : Colors.transparent),
                          border: Border.all(
                            color: isPeriodDay
                                ? Colors.pink.shade300
                                : (isToday
                                    ? Colors.blue.shade300
                                    : Colors.grey.shade300),
                            width: isToday ? 1.5 : 1,
                          ),
                        ),
                        child: Text(
                          "${day.day}",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isPeriodDay || isToday
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isPeriodDay || isToday
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
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                )
              ],
            ),
            child: !_isEditing
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
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                  )
                : Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.pink.shade400,
                            side: BorderSide(
                                color: Colors.pink.shade400, width: 1.5),
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
