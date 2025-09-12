import 'package:flutter/material.dart';
import 'package:lunaria/helpers/responsive_helper.dart';
import 'package:lunaria/widgets/calendar/white_card.dart';
import 'package:lunaria/widgets/calendar/detail_row.dart';

class DetailsCard extends StatelessWidget {
  const DetailsCard({Key? key}) : super(key: key);

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
          const DetailRow(title: "Previous Period Length", value: "6 Days"),
          const Divider(),
          const DetailRow(title: "Previous Cycle Length", value: "33 Days"),
          const Divider(),
          const DetailRow(title: "Cycle Length Variation", value: "27-33 Days"),
        ],
      ),
    );
  }
}
