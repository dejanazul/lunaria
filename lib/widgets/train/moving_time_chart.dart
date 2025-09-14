import 'package:flutter/material.dart';

class MovingTimeBarChart extends StatelessWidget {
  const MovingTimeBarChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> data = [
      {"day": "TUE", "percent": 0.7},
      {"day": "WED", "percent": 0.8},
      {"day": "THU", "percent": 0.6},
      {"day": "FRI", "percent": 0.9},
      {"day": "SAT", "percent": 1.0},
      {"day": "SUN", "percent": 0.85},
      {"day": "TODAY", "percent": 0.3},
    ];
    double progress = 0.25; // 25% progress
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Moving Time',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '0/20 min',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 5,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF913F9E),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.fitness_center,
                    color: Color(0xFF913F9E),
                    size: 22,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(color: Colors.grey[300], thickness: 1, height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children:
                  data.map((item) {
                    final isToday = item["day"] == "TODAY";
                    final double percent = item["percent"] as double;
                    final double barHeight = 100.0;
                    final double filledHeight = barHeight * percent;
                    final double emptyHeight = barHeight - filledHeight;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 12,
                            height: barHeight,
                            child: Column(
                              children: [
                                Container(
                                  height: emptyHeight,
                                  width: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(6),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: filledHeight,
                                  width: 12,
                                  decoration: BoxDecoration(
                                    color:
                                        isToday
                                            ? Colors.grey[300]
                                            : const Color(0xFF913F9E),
                                    borderRadius: const BorderRadius.vertical(
                                      bottom: Radius.circular(6),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item["day"],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey[300], thickness: 1, height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Weekly Average",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
              ),
              const Text(
                "18 min",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
