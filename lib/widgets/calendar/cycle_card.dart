import 'package:flutter/material.dart';
import 'package:lunaria/helpers/responsive_helper.dart';

class CycleCard extends StatelessWidget {
  final String duration;
  final String dateRange;
  final List<Color> days;

  const CycleCard({
    Key? key,
    required this.duration,
    required this.dateRange,
    required this.days,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveHelper.isMobile(context) ? 6 : 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            duration,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveHelper.getFontSize(
                context,
                small: 14,
                medium: 15,
                large: 16,
              ),
            ),
          ),
          Text(
            dateRange,
            style: TextStyle(
              color: Colors.grey,
              fontSize: ResponsiveHelper.getFontSize(
                context,
                small: 12,
                medium: 13,
                large: 14,
              ),
            ),
          ),
          SizedBox(height: ResponsiveHelper.isMobile(context) ? 6 : 8),
          Wrap(
            spacing: ResponsiveHelper.isMobile(context) ? 3 : 4,
            runSpacing: ResponsiveHelper.isMobile(context) ? 3 : 4,
            children:
                days
                    .map(
                      (color) => Container(
                        width: ResponsiveHelper.isMobile(context) ? 10 : 12,
                        height: ResponsiveHelper.isMobile(context) ? 10 : 12,
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
    );
  }
}
