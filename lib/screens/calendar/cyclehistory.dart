import 'package:flutter/material.dart';
import 'cyclehistorydetail.dart'; // 🔹 Import halaman detail

class Cyclehistory extends StatelessWidget {
  const Cyclehistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // 🔹 Background abu-abu muda
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Cycle History",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip("All", true),
                  _buildFilterChip("Last 3 Cycles", false),
                  _buildFilterChip("Last 6 Cycles", false),
                  _buildFilterChip("2025", false),
                  _buildFilterChip("2024", false),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 🔹 Legend
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  _LegendDot(color: Colors.pink, text: "Period"),
                  _LegendDot(color: Color(0xFFB3C7FF), text: "Fertile Window"),
                  _LegendDot(color: Colors.purple, text: "Ovulation"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Section 2025
            _buildYearSection(context, "2025", [
              _CycleCard(
                duration: "1 Day",
                dateRange: "Started Aug 11",
                days: [Colors.pink],
              ),
              _CycleCard(
                duration: "33 Days",
                dateRange: "Jul 9 - Aug 10",
                days: [
                  ...List.filled(5, Colors.pink),
                  ...List.filled(5, Color(0xFFB3C7FF)),
                  Colors.purple,
                  ...List.filled(20, Colors.grey.shade300),
                ],
              ),
              _CycleCard(
                duration: "29 Days",
                dateRange: "Jun 10 - Jul 8",
                days: [
                  ...List.filled(5, Colors.pink),
                  ...List.filled(4, Color(0xFFB3C7FF)),
                  Colors.purple,
                  ...List.filled(18, Colors.grey.shade300),
                ],
              ),
            ]),

            const SizedBox(height: 20),

            // 🔹 Section 2024
            _buildYearSection(context, "2024", [
              _CycleCard(
                duration: "30 Days",
                dateRange: "Dec 16 - Jan 14",
                days: [
                  ...List.filled(5, Colors.pink),
                  ...List.filled(6, Color(0xFFB3C7FF)),
                  Colors.purple,
                  ...List.filled(18, Colors.grey.shade300),
                ],
              ),
              _CycleCard(
                duration: "29 Days",
                dateRange: "Nov 16 - Dec 15",
                days: [
                  ...List.filled(5, Colors.pink),
                  ...List.filled(6, Color(0xFFB3C7FF)),
                  Colors.purple,
                  ...List.filled(17, Colors.grey.shade300),
                ],
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool selected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        selectedColor: Colors.purple.shade100,
        labelStyle: TextStyle(
          color: selected ? Colors.purple : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        onSelected: (_) {},
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildYearSection(BuildContext context, String year, List<_CycleCard> cycles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          year,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...cycles.map((card) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Cyclehistorydetail()),
              );
            },
            child: card,
          );
        }),
      ],
    );
  }
}

// 🔹 Legend Dot Widget
class _LegendDot extends StatelessWidget {
  final Color color;
  final String text;
  const _LegendDot({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 6, backgroundColor: color),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

// 🔹 Cycle Card Widget
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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // 🔹 Info bagian kiri
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(duration,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(dateRange,
                      style: const TextStyle(
                          fontSize: 14, color: Colors.black54)),
                  const SizedBox(height: 8),
                  Row(
                    children: days
                        .map((color) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 1),
                              child: CircleAvatar(
                                  radius: 5, backgroundColor: color),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            // 🔹 Tombol >
            const Icon(Icons.chevron_right, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}
