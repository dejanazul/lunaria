import 'package:flutter/material.dart';
import 'package:lunaria/helpers/responsive_helper.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const LogoutButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "Logout",
        style: TextStyle(
          fontSize: ResponsiveHelper.getFontSize(
            context,
            small: 14,
            medium: 15,
            large: 16,
          ),
          color: Colors.red,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
