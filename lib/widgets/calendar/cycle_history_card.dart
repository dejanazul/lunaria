import 'package:flutter/material.dart';
import 'package:lunaria/providers/calendar_ai_provider.dart';
import 'package:lunaria/widgets/calendar/white_card.dart';
import 'package:lunaria/widgets/calendar/header_with_button.dart';
import 'package:lunaria/widgets/calendar/cycle_card.dart';
import 'package:lunaria/screens/calendar/cyclehistory_new.dart';
import 'package:provider/provider.dart';

class CycleHistoryCard extends StatelessWidget {
  final BuildContext parentContext;

  const CycleHistoryCard({super.key, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarAiProvider>(
      builder: (context, provider, child) {
        // Dapatkan data riwayat siklus dari provider
        final cycleHistory = provider.getCycleHistory();

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

              ...cycleHistory.asMap().entries.map((entry) {
                final data = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: CycleCard(
                    duration: data['duration'],
                    dateRange: data['dateRange'],
                    days: List<Color>.from(data['days']),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
