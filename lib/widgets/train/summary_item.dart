import 'package:flutter/material.dart';

class SummaryItem extends StatelessWidget {
  final String title;
  final String value;
  final String goal;

  const SummaryItem({
    Key? key,
    required this.title,
    required this.value,
    required this.goal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        // Divider khusus untuk Steps dan Time Asleep
        if (title == 'Steps' || title == 'Time Asleep') ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                  height: 20,
                ),
              ),
            ],
          ),
        ] else ...[
          const SizedBox(height: 4),
        ],
        Text(
          goal,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}
