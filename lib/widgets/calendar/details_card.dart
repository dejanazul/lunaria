import 'package:flutter/material.dart';
import 'package:lunaria/helpers/responsive_helper.dart';
import 'package:lunaria/widgets/calendar/white_card.dart';
import 'package:lunaria/widgets/calendar/detail_row.dart';

class DetailsCard extends StatelessWidget {
  final String periodLength;
  final String cycleLength;
  final String cycleVariation;
  const DetailsCard({
    super.key,
    required this.periodLength,
    required this.cycleLength,
    required this.cycleVariation,
  });

  @override
  Widget build(BuildContext context) {
    return WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Details",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveHelper.getFontSize(
                context,
                small: 16,
                medium: 18,
                large: 20,
              ),
            ),
          ),
          SizedBox(height: ResponsiveHelper.isMobile(context) ? 12 : 16),
          DetailRow(
            title: "Previous Period Length",
            value: '$periodLength days',
          ),
          const Divider(),
          DetailRow(title: "Previous Cycle Length", value: '$cycleLength days'),
          const Divider(),
          DetailRow(
            title: "Cycle Length Variation",
            value: '$cycleVariation - ${int.parse(cycleVariation) + 3} days',
          ),
        ],
      ),
    );
  }
}
