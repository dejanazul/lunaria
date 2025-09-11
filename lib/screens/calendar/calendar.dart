import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'cyclehistory.dart';
import 'symptoms.dart';
import 'symptomschecker.dart';
import 'logactivity.dart';  
import 'detailcalendar.dart'; 

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDate = DateTime.now();

  String get _monthYear =>
      DateFormat.yMMMM().format(DateTime(_focusedDate.year, _focusedDate.month));

  Future<void> _pickMonthYear() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _focusedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: "Select Month & Year",
    );
    if (picked != null) {
      setState(() {
        _focusedDate = picked;
      });
    }
  }

  List<DateTime> _getWeekDates(DateTime base) {
    final startOfWeek = base.subtract(Duration(days: base.weekday % 7));
    return List.generate(7, (i) => startOfWeek.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔹 Header Calendar
            Container(
              padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink.shade300, Colors.pink.shade200],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  // Top bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const Logactivity()),
                          );
                        },
                      ),
                      GestureDetector(
                        onTap: _pickMonthYear,
                        child: Text(
                          _monthYear,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today,
                            color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const DetailCalendar()),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // 🔹 Mini Calendar
                  SizedBox(
                    height: 80,
                    child: PageView.builder(
                      controller: PageController(initialPage: 5000),
                      onPageChanged: (index) {
                        setState(() {
                          _focusedDate = DateTime.now()
                              .add(Duration(days: (index - 5000) * 7));
                        });
                      },
                      itemBuilder: (context, index) {
                        final baseDate = DateTime.now()
                            .add(Duration(days: (index - 5000) * 7));
                        final weekDates = _getWeekDates(baseDate);

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: weekDates.map((date) {
                            bool isToday =
                                DateUtils.isSameDay(date, DateTime.now());
                            return _DateItem(
                              label: DateFormat('E').format(date),
                              day: date.day.toString(),
                              isToday: isToday,
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 🔹 Period Info
                  const Text(
                    "Period",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Day 1",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 🔹 Log Activity Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.pink,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const Logactivity()),
                      );
                    },
                    child: const Text(
                      "Log Activity",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // 🔹 My Cycles Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "My Cycles",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _detailsCard(),
                  const SizedBox(height: 16),
                  _cycleHistoryCard(context),
                  const SizedBox(height: 16),
                  _symptomsCard(context),
                  const SizedBox(height: 16),
                  _symptomsCheckerCard(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Details Card
  Widget _detailsCard() {
    return const _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Details",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 12),
          _DetailRow(title: "Previous Period Length", value: "6 Days"),
          Divider(),
          _DetailRow(title: "Previous Cycle Length", value: "33 Days"),
          Divider(),
          _DetailRow(title: "Cycle Length Variation", value: "27-33 Days"),
        ],
      ),
    );
  }

  // 🔹 Cycle History Card
  Widget _cycleHistoryCard(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeaderWithButton(
            title: "Cycle History",
            buttonText: "See All",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Cyclehistory()),
              );
            },
          ),
          const SizedBox(height: 12),

          // Current Cycle
          _CycleCard(
            duration: "Current Cycle: 1 Day",
            dateRange: "Started Aug 11",
            days: [
              Colors.pink,
              ...List.filled(32, Colors.grey.shade300),
            ],
          ),
          const SizedBox(height: 12),

          // Previous Cycle
          _CycleCard(
            duration: "33 Days",
            dateRange: "Jul 9 - Aug 10",
            days: [
              ...List.filled(6, Colors.pink),
              ...List.filled(6, const Color(0xFFB3C7FF)),
              Colors.purple,
              ...List.filled(20, Colors.grey.shade300),
            ],
          ),
          const SizedBox(height: 12),

          _CycleCard(
            duration: "29 Days",
            dateRange: "Jun 10 - Jul 8",
            days: [
              ...List.filled(5, Colors.pink),
              ...List.filled(5, const Color(0xFFB3C7FF)),
              Colors.purple,
              ...List.filled(18, Colors.grey.shade300),
            ],
          ),
        ],
      ),
    );
  }

  // 🔹 Symptoms Card (popup)
  Widget _symptomsCard(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeaderWithButton(
            title: "Symptoms",
            buttonText: "Add +",
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const Symptoms(),
              );
            },
          ),
          const SizedBox(height: 8),
          const Text("How are you feeling today?"),
        ],
      ),
    );
  }

  // 🔹 Symptoms Checker Card
  Widget _symptomsCheckerCard(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeaderWithButton(
            title: "Symptoms Checker",
            buttonText: "See All",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Symptomschecker()),
              );
            },
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "We detected at least one symptom that may need your attention.",
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ================= Helper Widgets ================= //

class _DateItem extends StatelessWidget {
  final String label;
  final String day;
  final bool isToday;

  const _DateItem(
      {required this.label, required this.day, this.isToday = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: isToday ? Colors.pink : Colors.white,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isToday ? Colors.white : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Text(
            day,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isToday ? Colors.pink : Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String title;
  final String value;

  const _DetailRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.black54)),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          children: const [
            Text(
              "NORMAL",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            SizedBox(width: 4),
            Icon(Icons.check_circle, color: Colors.green, size: 18),
          ],
        ),
      ],
    );
  }
}

class _HeaderWithButton extends StatelessWidget {
  final String title;
  final String buttonText;
  final VoidCallback? onTap;

  const _HeaderWithButton(
      {required this.title, required this.buttonText, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
      ],
    );
  }
}

class _WhiteCard extends StatelessWidget {
  final Widget child;
  const _WhiteCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

// 🔹 CycleCard Widget (buletan kecil)
class _CycleCard extends StatelessWidget {
  final String duration;
  final String dateRange;
  final List<Color> days;

  const _CycleCard({
    required this.duration,
    required this.dateRange,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            duration,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            dateRange,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 3,
            runSpacing: 3,
            children: days
                .map(
                  (color) => Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
