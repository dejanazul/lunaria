import 'package:flutter/material.dart';
import 'profile_summary_components.dart';

/// Widget BMI Gauge Card dengan default values untuk testing
class SafeBmiGaugeCard extends StatelessWidget {
  const SafeBmiGaugeCard({
    super.key,
    this.bmi = 21.5, // Default BMI dalam range normal
    this.bmiLabel = "Normal",
    this.color = const Color(0xFF22C55E),
  });

  final double bmi;
  final String bmiLabel;
  final Color color;

  @override
  Widget build(BuildContext context) {
    try {
      return BmiGaugeCard(bmi: bmi, bmiLabel: bmiLabel, color: color);
    } catch (e) {
      debugPrint('Error rendering BmiGaugeCard: $e');
      // Fallback widget sederhana jika terjadi error
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Center(child: Text('BMI Information')),
      );
    }
  }
}

/// Widget Summary Row dengan default values untuk testing
class SafeSummaryRow extends StatelessWidget {
  const SafeSummaryRow({
    super.key,
    required this.title,
    this.icon = Icons.info_outline,
    this.value = 'Not available',
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    try {
      return SummaryRow(icon: icon, title: title, value: value);
    } catch (e) {
      debugPrint('Error rendering SummaryRow: $e');
      // Fallback widget sederhana jika terjadi error
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(value),
              ],
            ),
          ],
        ),
      );
    }
  }
}
