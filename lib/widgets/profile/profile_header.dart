import 'package:flutter/material.dart';
import 'package:lunaria/helpers/responsive_helper.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String username;
  final VoidCallback onTap;

  const ProfileHeader({
    Key? key,
    required this.name,
    required this.email,
    required this.username,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveHelper.isMobile(context) ? 40 : 50,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFF7B2CBF),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: ResponsiveHelper.isMobile(context) ? 45 : 55,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: ResponsiveHelper.isMobile(context) ? 50 : 60,
                color: Color(0xFF7B2CBF),
              ),
            ),
            SizedBox(height: 10),
            Text(
              name,
              style: TextStyle(
                fontSize: ResponsiveHelper.getFontSize(
                  context,
                  small: 18,
                  medium: 20,
                  large: 22,
                ),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              email,
              style: TextStyle(
                color: Colors.white70,
                fontSize: ResponsiveHelper.getFontSize(
                  context,
                  small: 13,
                  medium: 14,
                  large: 16,
                ),
              ),
            ),
            Text(
              "@$username",
              style: TextStyle(
                color: Colors.white70,
                fontSize: ResponsiveHelper.getFontSize(
                  context,
                  small: 13,
                  medium: 14,
                  large: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
