import 'package:flutter/material.dart';
import 'package:lunaria/helpers/responsive_helper.dart';

class TrackCycleSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const TrackCycleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(
        "Track Cycle",
        style: TextStyle(
          fontSize: ResponsiveHelper.getFontSize(
            context,
            small: 14,
            medium: 15,
            large: 16,
          ),
        ),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}
