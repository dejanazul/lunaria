import 'package:flutter/material.dart';
import 'package:lunaria/widgets/calendar/white_card.dart';
import 'package:lunaria/widgets/calendar/header_with_button.dart';
import 'package:lunaria/widgets/calendar/cycle_card.dart';
import 'package:lunaria/screens/calendar/cyclehistory.dart';

class CycleHistoryCard extends StatelessWidget {
  final BuildContext parentContext;

  const CycleHistoryCard({Key? key, required this.parentContext})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderWithButton(
            title: "Cycle History",
            buttonText: "See All",
            onTap: () {
              Navigator.push(
                parentContext,
                MaterialPageRoute(builder: (_) => const Cyclehistory()),
              );
            },
          ),
          const SizedBox(height: 12),

          // Current Cycle
          CycleCard(
            duration: "Current Cycle: 1 Day",
            dateRange: "Started Aug 11",
            days: [Colors.pink, ...List.filled(32, Colors.grey.shade300)],
          ),
          const SizedBox(height: 12),

          // Previous Cycle
          CycleCard(
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

          CycleCard(
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
}
