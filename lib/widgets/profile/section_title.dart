import 'package:flutter/material.dart';
import 'package:lunaria/helpers/responsive_helper.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(
              context,
              small: 15,
              medium: 16,
              large: 18,
            ),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
