import 'package:flutter/material.dart';
import 'package:lunaria/helpers/responsive_helper.dart';

class ProfileListTile extends StatelessWidget {
  final String title;
  final Widget page;
  final String? trailingText;
  final VoidCallback? onTap;
  
  const ProfileListTile({
    Key? key, 
    required this.title, 
    required this.page,
    this.trailingText,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title, 
        style: TextStyle(
          fontSize: ResponsiveHelper.getFontSize(context, small: 14, medium: 15, large: 16),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText!,
              style: TextStyle(
                color: Colors.grey, 
                fontSize: ResponsiveHelper.getFontSize(context, small: 13, medium: 14, large: 15),
              ),
            ),
          const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
        ],
      ),
      onTap: onTap ?? () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
    );
  }
}
