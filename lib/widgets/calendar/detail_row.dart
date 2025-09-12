import 'package:flutter/material.dart';
import 'package:lunaria/helpers/responsive_helper.dart';

class DetailRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isNormal;

  const DetailRow({
    Key? key,
    required this.title,
    required this.value,
    this.isNormal = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.black54,
                fontSize: ResponsiveHelper.getFontSize(
                  context,
                  small: 12,
                  medium: 13,
                  large: 14,
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: ResponsiveHelper.getFontSize(
                  context,
                  small: 16,
                  medium: 18,
                  large: 20,
                ),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (isNormal)
          Row(
            children: [
              Text(
                "NORMAL",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: ResponsiveHelper.getFontSize(
                    context,
                    small: 11,
                    medium: 12,
                    large: 13,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: ResponsiveHelper.isMobile(context) ? 18 : 20,
              ),
            ],
          ),
      ],
    );
  }
}
