import 'package:flutter/material.dart';
import 'package:lunaria/constants/app_colors.dart';
import 'package:lunaria/helpers/responsive_helper.dart';

class ChatTypingIndicator extends StatelessWidget {
  const ChatTypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getMediumSpacing(context),
        vertical: ResponsiveHelper.getSmallSpacing(context),
      ),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getCardBorderRadius(context),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: ResponsiveHelper.getMediumSpacing(context),
            height: ResponsiveHelper.getMediumSpacing(context),
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          SizedBox(width: ResponsiveHelper.getSmallSpacing(context)),
          Text(
            "Luna sedang mengetik...",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: ResponsiveHelper.getCaptionFontSize(context),
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
