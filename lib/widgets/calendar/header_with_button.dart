import 'package:flutter/material.dart';
import 'package:lunaria/helpers/responsive_helper.dart';

class HeaderWithButton extends StatelessWidget {
  final String title;
  final String buttonText;
  final VoidCallback? onTap;

  const HeaderWithButton({
    Key? key,
    required this.title,
    required this.buttonText,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
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
        ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.isMobile(context) ? 16 : 20,
              vertical: ResponsiveHelper.isMobile(context) ? 8 : 10,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveHelper.getFontSize(
                context,
                small: 13,
                medium: 14,
                large: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
