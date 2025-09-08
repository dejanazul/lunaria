import 'package:flutter/material.dart';
import 'package:lunaria/helpers/responsive_helper.dart';

class ChatErrorMessage extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onDismiss;

  const ChatErrorMessage({
    super.key,
    required this.errorMessage,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: ResponsiveHelper.getHorizontalPadding(context),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.getMediumSpacing(context),
          vertical: ResponsiveHelper.getSmallSpacing(context),
        ),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getCardBorderRadius(context),
          ),
          border: Border.all(color: Colors.red.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                "Error: $errorMessage",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: ResponsiveHelper.getCaptionFontSize(context),
                  color: Colors.red.shade700,
                ),
              ),
            ),
            TextButton(
              onPressed: onDismiss,
              child: const Text(
                "Tutup",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
