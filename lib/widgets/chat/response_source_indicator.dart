import 'package:flutter/material.dart';

/// Widget kecil yang menampilkan indikator bahwa respons menggunakan database atau hanya LLM
class ResponseSourceIndicator extends StatelessWidget {
  final bool isFromDatabase;

  const ResponseSourceIndicator({Key? key, this.isFromDatabase = false})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color:
            isFromDatabase
                ? Colors.green.withOpacity(0.1)
                : Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isFromDatabase
                  ? Colors.green.withOpacity(0.3)
                  : Colors.blue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isFromDatabase ? Icons.storage : Icons.psychology,
            size: 12,
            color:
                isFromDatabase ? Colors.green.shade700 : Colors.blue.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            isFromDatabase ? "Database" : "AI",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color:
                  isFromDatabase ? Colors.green.shade700 : Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
