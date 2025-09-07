import 'package:flutter/material.dart';
import '../../helpers/responsive_helper.dart';
import '../../widgets/bottom_nav.dart';
import '../../routes/routes.dart';
import '../../constants/app_colors.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final int _currentIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Community',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: ResponsiveHelper.getSubheadingFontSize(context),
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_outline,
                size: ResponsiveHelper.getIconSize(context) * 3,
                color: Colors.white,
              ),
              SizedBox(height: ResponsiveHelper.getMediumSpacing(context)),
              Text(
                'Community Screen',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: ResponsiveHelper.getHeadingFontSize(context) + 8,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: ResponsiveHelper.getSmallSpacing(context)),
              Text(
                'Connect with other pet owners\nand share experiences',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: ResponsiveHelper.getBodyFontSize(context),
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          NavigationService.navigateToBottomNavScreen(
            context,
            index,
            _currentIndex,
          );
        },
      ),
    );
  }
}
