import 'package:flutter/material.dart';
import 'package:lunaria/providers/calendar_ai_provider.dart';
import 'package:provider/provider.dart';
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
      body: Consumer<CalendarAiProvider>(
        builder: (context, provider, child) {
          // Dapatkan data riwayat siklus dari provider
          final cycleHistory = provider.getCycleHistory();

          return SingleChildScrollView(
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      _LegendDot(
                        color: Color.fromARGB(255, 255, 17, 0),
                        text: "Menstruasi",
                      ),
                      _LegendDot(color: Color(0xFFCE93D8), text: "Folikular"),
                      _LegendDot(color: Color(0xFF6A1B9A), text: "Ovulasi"),
                      _LegendDot(color: Color(0xFFBDBDBD), text: "Luteal"),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Tampilkan siklus berdasarkan data dari provider
                if (cycleHistory.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 32.0),
                      child: Text(
                        "Belum ada data siklus tersedia",
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                else
                  // 🔹 Section 2025 (tahun saat ini)
                  _buildYearSection(
                    context,
                    "2025",
                    cycleHistory
                        .map(
                          (data) => _CycleCard(
                            duration: data['duration'],
                            dateRange: data['dateRange'],
                            days: List<Color>.from(data['days']),
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
          );
        },
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

  Widget _buildYearSection(
    BuildContext context,
    String year,
    List<_CycleCard> cycles,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            year,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        // List cycle cards with InkWell wrapper
        ...cycles.map(
          (cycle) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Cyclehistorydetail()),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: cycle,
            ),
          ),
        ),
      ],
    );
  }
}

// 🔹 Widget untuk menampilkan dot dalam legenda
class _LegendDot extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendDot({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

// 🔹 Widget untuk tampilan satu cycle
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
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  duration,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  dateRange,
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 3,
              runSpacing: 3,
              children:
                  days
                      .map(
                        (color) => Container(
                          width: 12,
                          height: 12,
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
      ),
    );
  }
}
